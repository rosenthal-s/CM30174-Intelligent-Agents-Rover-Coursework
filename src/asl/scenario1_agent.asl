// Agent scenario1_agent in project ia_submission

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("hello world.");
					scan(3);
					.
					
+! move_around : true
	<-  move(3, 2);
	    rover.ia.log_movement(3, 2); // keeps track of movement
	    scan(3);
	    .
					
+! return_to_base : true
	<-	rover.ia.get_distance_from_base(XDistance, YDistance);
		.print("I am returning to the base");
		move(XDistance, YDistance) ;
   	  	deposit("Gold");
   	  	deposit("Gold");
   	  	deposit("Gold");
	  	rover.ia.clear_movement_log;
	  	! start;
	  	.
   	  
 // move around if nothing found  	  
 + resource_not_found: true
	<-	.print("I found nothing, I am moving again....");
    	! move_around;
    	.
   
 // go to resource found
+ resource_found(ResourceType, Quantity, XDist, YDist): true
	<-  move(XDist, YDist);
	    rover.ia.log_movement(XDist, YDist);
	    .print("I am at the resource!!!!!");
	    .print("There are ", Quantity, " resources here");
	    collect("Gold");
	    collect("Gold");
	    collect("Gold");
	    ! return_to_base;
	    .