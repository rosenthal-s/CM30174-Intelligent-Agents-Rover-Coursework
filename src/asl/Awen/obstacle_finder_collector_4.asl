// Agent obstacle_finder_collector_4 in project ia_submission

/* Initial beliefs and rules */
holding(0).
space.
found(0).


/* Initial goals */

!start.

/* Plans */

//Setting up the agent's settings


+!start : true <- rover.ia.get_map_size(XSize, YSize);
					ia_submission.set_world_size(XSize, YSize);
					.print(XSize, " ", YSize);
					.my_name(N);
					.print("hi i am ",N);
					if(N = diamond) {
						.print("diamente");
						+resource_type("Diamond");
						+other_agent(gold);
						+explore_area(0,15,0,YSize);
					} elif (N = gold) {
						.print("golde");
						+resource_type("Gold");
						+other_agent(diamond);
						+explore_area(15,XSize,0,YSize);
						move(6,0);
						ia_submission.log_movement(6,0);
					}
					rover.ia.check_status(En);
					+energy(En);
					!explore.
					
-!start : true <- .print("Error in start");
				!explore.
					
//Exploring the map to find the resources
+!explore : not scan_done <- .print("explore");
							//scanning and letting the other agent know
							ia_submission.get_coords(XCoord, YCoord);
							scan(3);
							ia_submission.log_scanned(XCoord, YCoord);
							?other_agent(Name);
							.send(Name, tell, scanned(XCoord, YCoord));
							//getting coordinates to navigate to next
							?explore_area(StX, EnX, StY, EnY)
							.print("getting movement for ", XCoord, " ", YCoord);
							ia_submission.get_movement(XCoord, YCoord, StX, StY, EnX, EnY, XTo, YTo);
							//get_movement returns -100 if all areas have been marked scanned
							if(XTo == -100) {
								+scan_done;
							} else {
								.print("looking for path between ", XCoord, " ", YCoord, " and ", XTo, " ", YTo);
								ia_submission.path_between(XCoord, YCoord, XTo, YTo, Movements);
								!move(Movements);
							}
							//updating energy numbers
							?energy(E);
							-energy(E);
							rover.ia.check_status(En);
							+energy(En);
							!explore.
							
+!explore: scan_done <- .print("starting to collect");
						//not logging scan because scan is done - only want to log immediate obstacles
						scan(1);
						!collect_resources.
						
-!explore : true <- .print("Error in explore");
					!explore.
						
+obstructed(XTrav, YTrav, XLeft, YLeft) : true <- 
							.print("Been obstructed! Logging ", XTrav, YTrav);
							ia_submission.log_movement(XTrav, YTrav).
											
+scanned(XCoord, YCoord)[source(Ag)] : true <- ia_submission.log_scanned(XCoord, YCoord);
												-scanned(XCoord, YCoord)[source(Ag)].

@atomic[resource_found]						
+resource_found(Resource, Quantity, XDisplacement, YDisplacement) : Resource = "Gold" | Resource = "Diamond" | Resource = "Obstacle" <-
							//.print("Resource at ", XDisplacement , " ", YDisplacement, " from me");
							ia_submission.get_coords(XCoord, YCoord);
							//.print("I am at ", XCoord, " ", YCoord);
							?other_agent(OtherAg);
							//.print("other agent is ", OtherAg);
							ia_submission.convert_to_pos_coords((XCoord + XDisplacement), (YCoord + YDisplacement), RXCoord, RYCoord);
							//.print("Gona from ", (XCoord + XDisplacement), " to ", RXCoord, " plus ", (YCoord + YDisplacement), " to ", RYCoord);
							if(resources(Resource, Quantity, RXCoord, RYCoord)) {
								//.print("resource exists");
							} else {
								//.print("resource doesn't exist");
								.send(OtherAg, tell, resource_found_other(Resource, Quantity, RXCoord, RYCoord));
								if(Resource = "Obstacle") {
									.print("logging obstacle");
									ia_submission.log_obstacle(RXCoord, RYCoord);
								} else {
									+resources(Resource, Quantity, RXCoord, RYCoord);
									?found(NumFound);
									+found(NumFound + Quantity);
									-found(NumFound);
									if((NumFound+Quantity) >= 24) {
										.print("Found all resources so scan done");
										+scan_done;
									}
								}
							}.

+resource_found(Resource, Quantity, XDisplacement, YDisplacement) : Resource = "Agent" <-
							?other_agent(AgName);
							if(AgName == gold) {
								move(-2 * XDisplacement, -YDisplacement);
								ia_submission.log_movement(-XDisplacement, -YDisplacement)
							}.

+resource_found_other(Name, Quantity, XCoord, YCoord)[source(Ag)] <-
							if(resources(Name, Quantity, XCoord, YCoord)) {
								.print("resource exists");
							} else {
								if(Name = "Obstacle") {
									.print("logging obstacle");
									ia_submission.log_obstacle(XCoord, YCoord);
								} else {
									+resources(Name, Quantity, XCoord, YCoord);
									?found(NumFound);
									-found(NumFound);
									+found(NumFound + Quantity);
									if((NumFound+Quantity) >= 24) {
										.print("Found all resources so scan done");
										+scan_done;
									}
								}
							}
							-resource_found_other(Name, Quantity, XCoord, YCoord)[source(Ag)].
							
+!collect_resources : resources(Name, Quantity, RXCoord, RYCoord) & resource_type(Col_Type) & Name = Col_Type <- 
							ia_submission.get_coords(XCoord, YCoord);
							ia_submission.path_between(XCoord, YCoord, RXCoord, RYCoord, Movements);
							//+movements(Mov)
							!move(Movements);
							.print("trying to collect ", Col_Type, " at ", RXCoord, " ", RYCoord);
							collect(Col_Type);
							.print("past collect");
							+collected;
							-resources(Name, Quantity, RXCoord, RYCoord);
							?holding(Num);
							-holding(Num);
							+holding(Num+1);
							if(Quantity > 1) {
								+resources(Name, Quantity - 1, RXCoord, RYCoord);
							}
							!collect_resources.

+!collect_resources : not (resources(Name, Quantity, RXCoord, RYCoord) & resource_type(Col_Type) & Name = Col_Type) <-
							.print("No more resources");
							if(not collected) {
								.print("Changing collect type current is ", Col_Type);
								if(Col_Type == Gold) {
									.print("Switching from gold to diamond");
									-resource_type(Col_Type);
									+resource_type("Diamond");
								} elif(Col_Type == Diamond) {
									.print("Switching from diamond to gold");
									-resource_type(Col_Type);
									+resource_type("Gold");
								}
								!collect_resources;
							} else {
								+last_deposit;
							}.
							
-!collect_resources: true <- .print("Error in collect resources");
							!collect_resources.

+!move(Mov) <- .print("moving through path");
				for(.member([X, Y], Mov)) {
					.print("X is ", X, " Y is ", Y);
					move(X, Y);
					ia_submission.log_movement(X, Y);
				}.
				
-!move(Mov) <- .print("Error in move");
				!explore.

+holding(Num) : Num = 3 <- .print("Gonna go deposit");
							ia_submission.get_coords(XCoord, YCoord);
							ia_submission.path_between(XCoord, YCoord, 0, 0, Movements);
							!move(Movements)
							?resource_type(Type);
							deposit(Type);
							deposit(Type);
							deposit(Type);
							-holding(3);
							+holding(0).

+last_deposit : true <- ?holding(X);
						.print("In last deposit");
						if(X > 0) {
							ia_submission.get_coords(XCoord, YCoord);
							ia_submission.path_between(XCoord, YCoord, 0, 0, Movements);
							!move(Movements)
							?resource_type(Type);
							deposit(Type);
							-holding(X);
							+holding(X-1);
						} else {
							-last_deposit;
						}.