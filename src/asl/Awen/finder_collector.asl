// Agent finder_collector in project ia_submission

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
					.my_name(N);
					.print("hi i am ",N);
					if(N = diamond) {
						.print("diamente");
						+resource_type("Diamond");
						+other_agent(gold);
						+explore_area(0,12,0,YSize);
					} elif (N = gold) {
						.print("golde");
						+resource_type("Gold");
						+other_agent(diamond);
						+explore_area(12,XSize,0,YSize);
						move(-4,0);
						ia_submission.log_movement(-4,0);
					}
					rover.ia.check_status(En);
					+energy(En);
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
							ia_submission.get_movement(XCoord, YCoord, StX, StY, EnX, EnY, XMov, YMov);
							//get_movement returns -100 if all areas have been marked scanned
							if(XMov = -100) {
								+scan_done;
							} else {
								ia_submission.path_between(XCoord, YCoord, XMov, YMov, Mov);
								!move(Mov);
							}
							//updating energy numbers
							?energy(E);
							-energy(E);
							rover.ia.check_status(En);
							+energy(En);
							!explore.
							
+!explore: scan_done <- .print("starting to collect");
						!collect_resources.
						
+obstructed(XTrav, YTrav, XLeft, YLeft) : true <- 
							.print("Been obstructed! Logging ", XTrav, YTrav);
							ia_submission.log_movement(XTrav, YTrav);
							?other_agent(Name);
							if(Name == Gold) {
								if(XLeft == 0 & YLeft == 1) {
									move(1,0);
									ia_submission.log_movement(1,0);
								} else {
									move(0,1);
									ia_submission.log_movement(0,1);
								}
							}.
											
+scanned(XCoord, YCoord)[source(Ag)] : true <- ia_submission.log_scanned(XCoord, YCoord);
												-scanned(XCoord, YCoord)[source(Ag)].

@atomic[resource_found, move]						
+resource_found(Resource, Quantity, XDisplacement, YDisplacement) : Resource = "Gold" | Resource = "Diamond" | Resource = "Obstacle" <-
							.print("Resource at ", XDisplacement , " ", YDisplacement, " from me");
							ia_submission.get_coords(XCoord, YCoord);
							.print("I am at ", XCoord, " ", YCoord);
							?other_agent(OtherAg);
							.print("other agent is ", OtherAg);
							ia_submission.convert_to_pos_coords((XCoord + XDisplacement), (YCoord + YDisplacement), RXCoord, RYCoord);
							.print("Gona from ", (XCoord + XDisplacement), " to ", RXCoord, " plus ", (YCoord + YDisplacement), " to ", RYCoord);
							if(resources(Resource, Quantity, RXCoord, RYCoord)) {
								.print("resource exists");
							} else {
								.print("resource doesn't exist");
								+resources(Resource, Quantity, RXCoord, RYCoord);
								.send(OtherAg, tell, resource_found_other(Resource, Quantity, RXCoord, RYCoord));
								
								if(Resource = "Obstacle") {
									ia_submission.log_obstacle(RXCoord, RYCoord);
								} else {
									.print(.count(resources(R, Q, X, Y)));
									.findall(Q, resources(R, Q, X, Y), L);
									.print(L);
									.print("num gold found is ", math.sum(L));
									-found(_);
									+found(math.sum(L));
									if(math.sum(L) >= 32) {
										.print("SCAN DONEEEEEEEEEE");
										+scan_done;
										.send(OtherAg, tell, scan_done);
									}
									
									/*if(not switched) {
										rover.ia.get_map_size(XSize, YSize);
										.findall(Q, resources("Gold", Q, X, Y), GL);
										if(math.sum(GL) > 16) {
											.print("FOUND MORE THAN 16 GOLD ASAP ON THE COLLECT");
											if(OtherAg == Gold) {
												.print("other agent is gold");
												.send(OtherAg, tell, scan_done);
												-explore_area(_,_,_,_);
												+explore_area(0,XSize,0,YSize);
											} else {
												+scan_done;
												.send(OtherAg, tell, explore_area(0,XSize,0,YSize));
											}
											+switched;
										}
										
										.findall(Q, resources("Diamond", Q, X, Y), DL);
										
										if(math.sum(DL) > 16) {
											.print("FOUND MORE THAN 16 DIAMOND ASAP ON THE COLLECT");
											if(OtherAg == Diamond) {
												.print("other agent is diamond");
												.send(OtherAg, tell, scan_done);
												-explore_area(_,_,_,_);
												+explore_area(0,XSize,0,YSize);
											} else {
												+scan_done;
												.send(OtherAg, tell, explore_area(0,XSize,0,YSize));
											}
											+switched;
										}
									}*/
								}
							}.
						
/*+explore_area(SX, EX, SY, EY)[source(Ag)] : SX == 0 & EX == XSize & SY == 0 & EY == YSize & not explore_changed <-
							.print("CHANGING EXPLORE AREA");
							-explore_area(_, _, _, _)[source(self)];
							+explore_area(SX, EX, SY, EY);
							+explore_changed.*/
								
+resource_found_other(Name, Quantity, XCoord, YCoord)[source(Ag)] <-
							if(resources(Name, Quantity, XCoord, YCoord)) {
								.print("resource exists");
							} else {
								+resources(Name, Quantity, XCoord, YCoord);
								if(Name = "Obstacle") {
									ia_submission.log_obstacle(XCoord + XDisplacement, YCoord + YDisplacement);
								} else {
									.print(.count(resources(R, Q, X, Y)));
									.findall(Q, resources(R, Q, X, Y), L);
									.print(L);
									.print("num resources found is ", math.sum(L));
									-found(_);
									+found(math.sum(L));
									if(math.sum(L) >= 32) {
										.print("SCAN DONEEEEEEEEEE");
										+scan_done;
										?other_agent(OtherAg);
										.send(OtherAg, tell, scan_done);
									}
								}
							}
							-resource_found_other(Name, Quantity, XCoord, YCoord)[source(Ag)].
							
+!collect_resources : resources(Name, Quantity, RXCoord, RYCoord) & resource_type(Col_Type) & Name = Col_Type <- 
							ia_submission.get_coords(XCoord, YCoord);
							ia_submission.path_between(XCoord, YCoord, RXCoord, RYCoord, Movements);
							//+movements(Mov)
							!move(Movements);
							.print("trying to collect ", Col_Type);
							collect(Col_Type);
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
								.print("Changing collect type");
								if(Col_Type = Gold) {
									-resource_type(Col_Type);
									+resource_type(Diamond);
								} elif(Col_Type = Diamond) {
									-resource_type(Col_Type);
									+resource_type(Gold);
								}
								!collect_resources;
							} else {
								!last_deposit;
							}.
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
							ia_submission.path_between(XCoord, YCoord, 0, 0, Mov);
							!move(Mov);
							?resource_type(Type);
							deposit(Type);
							deposit(Type);
							deposit(Type);
							-holding(3);
							+holding(0).

+!last_deposit : true <- ?holding(X);
						.print("In last deposit");
						if(X > 0) {
							ia_submission.get_coords(XCoord, YCoord);
							ia_submission.path_between(XCoord, YCoord, 0, 0, Movements);
							!move(Movements)
							?resource_type(Type);
							deposit(Type);
							-holding(X);
							+holding(X-1);
							!last_deposit;
						}.