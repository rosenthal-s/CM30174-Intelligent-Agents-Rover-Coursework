// Agent scenario2_heavy in project ia_submission

/* Initial beliefs and rules */
carrying( 0 ).
deposit_location( 0, 0 ).
deposit_quantity( 0 ).
finished( 0 ).

/* Initial goals */

!start.

/* Plans */

+!start:	true
	<-	.print( "hello world." );
		.

//@depositing[atomic] ///
+!deposit_recursive:	not carrying(0)
	<-	deposit( "Gold" );
		?carrying( N );
		-+carrying( N - 1 );
		.print( "deposit_recursive - carrying N=", N-1 );
		!deposit_recursive;
		.

-!deposit_recursive:	true
	<-	!return_to_resource;
		.
			
+! return_to_base:	true
	<-	rover.ia.get_distance_from_base( XDistance, YDistance );
		.print( "return_to_base - I am at ", -XDistance, ",", -YDistance ); ///
		.print( "I am returning to the base" );
		rover.ia.get_map_size( MapWidth, MapHeight );
		rover_coursework.get_optimal_distance_to_travel( XDistance, YDistance, MapWidth, MapHeight, XToMove, YToMove ); /// sometimes goes the long way?
		.print( "return_to_base - Distance: ", XToMove, ",", YToMove ); ///
		move( XToMove, YToMove );
	  	rover.ia.clear_movement_log;
		!deposit_recursive;
	  	.

+!update_location:	true
	<-	rover.ia.check_config( Capacity, ScanRange, ResourceType );
		rover_coursework.get_resource_info( ResourceType, X, Y, Quantity, Finished );
		if( Finished == 0 )
		{
			-+deposit_quantity( Quantity );
			-+deposit_location( X, Y );
		}
		else
		{
			.print( "update_location - finished" ); /// idk if this gets reached?
			-+deposit_location( 0, 0 ); ///
			-+finished( 1 );
		}
		.

+!new_move:	true
	<-	!update_location;
		?finished( Finished );
		if( Finished == 0 )
		{
			?deposit_location( X, Y );
			rover.ia.get_distance_from_base( XDistanceTravelled, YDistanceTravelled );
			rover.ia.get_map_size( MapWidth, MapHeight );
			rover_coursework.get_optimal_distance_to_travel( X + XDistanceTravelled, Y + YDistanceTravelled, MapWidth, MapHeight, XToMove, YToMove );
			.print( "new_move - I am at ", -XDistanceTravelled, ",", -YDistanceTravelled ); ///
			.print( "new_move - Distance: ", XToMove, ",", YToMove ); ///
			move( XToMove, YToMove );
			rover.ia.log_movement( XToMove, YToMove );
			!collect_resource;
		}
		else
		{
			!return_to_base;
		}
		.

+ new_move[source( Ag )]:	true
	<-	.print( "Message received from ", Ag );
//		!new_move; ///
		.

+!return_to_resource:	finished( 0 ) ///true
	<-	?deposit_location( X, Y );
		.print( "return_to_resource - I am going to ", X, ",", Y );
		move( X, Y );
		rover.ia.log_movement( X, Y );
		!collect_resource;
		.

+!collect_resource: true
	<-	.print( "Collecting up to 6 Gold!" )
		!collect_recursive;
	    .

//@collecting[atomic] ///
+!collect_recursive: not carrying( 6 ) & not deposit_quantity( 0 )
	<-	collect( "Gold" );
		?carrying( N );
		-+carrying( N + 1 );
		.print( "collect_recursive - carrying N=", N + 1 );
		?deposit_quantity( M );
		-+deposit_quantity( M - 1 );
		.print( "collect_recursive - location deposit=", M - 1 );
		!collect_recursive;
		.

-!collect_recursive: carrying( 6 ) & not deposit_quantity( 0 )
	<-	.print( "Finished collecting - at maximum capacity" );
		!return_to_base;
		.

-!collect_recursive: carrying( 6 ) & deposit_quantity( 0 )
	<-	.print( "Finished collecting - at maximum capacity and resource is depleted" );
		!update_location;
		!return_to_base;
		.

-!collect_recursive: deposit_quantity( 0 ) & not carrying( 6 )
	<-	.print( "Finished collecting - resource is depleted" );
		!new_move;
		.

////@obstructed[atomic] ///
//// What to do if the heavy collides with the scout
//+ obstructed( XTravelled, YTravelled, XRemaining, YRemaining ): true
//	<-	.print( "Obstructed. Travelled=", XTravelled, ",", YTravelled, "; Remaining=", XRemaining, ",", YRemaining );
//		rover.ia.log_movement( XTravelled, YTravelled ); // Report already travelled distance
//		// If moving to the right or downwards, move diagonally down and right
//		if( ( XRemaining > 0 & YRemaining == 0 ) | ( XRemaining == 0 & YRemaining > 0 ) )
//		{
//			move( 1, 1 );
//			rover.ia.log_movement( 1, 1 );
//			.print( "Was moving right/downwards, now moving diagonally" ); ///
//			rover_coursework.overwrite_number( XRemaining - 1, XToGo );
//			rover_coursework.overwrite_number( YRemaining - 1, YToGo );
//		}
//		// If moving to the left or upwards, move diagonally up and left
//		elif( ( XRemaining < 0 & YRemaining == 0 ) | ( XRemaining == 0 & YRemaining < 0 ) )
//		{
//			move( -1, -1 );
//			rover.ia.log_movement( -1, -1 );
//			.print( "Was moving left/upwards, now moving diagonally" ); ///
//			rover_coursework.overwrite_number( XRemaining + 1, XToGo );
//			rover_coursework.overwrite_number( YRemaining + 1, YToGo );
//		}
//		// If moving diagonally downwards, move straight down
//		elif( YRemaining > 0 )
//		{
//			move( 0, 1 );
//			rover.ia.log_movement( 0, 1 );
//			.print( "Was moving diagonally downwards, now moving straight downwards" ); ///
//			rover_coursework.overwrite_number( XRemaining, XToGo );
//			rover_coursework.overwrite_number( YRemaining - 1, YToGo );
//		}
//		// If moving diagonally upwards, move straight up
//		else
//		{
//			.print( "Was moving diagonally upwards, now moving straight upwards" ); ///
//			move( 0, -1 );
//			rover.ia.log_movement( 0, -1 );
//			rover_coursework.overwrite_number( XRemaining, XToGo );
//			rover_coursework.overwrite_number( YRemaining + 1, YToGo );
//		}
//		// Travel the remaining distance
//		.print( "Remaining distance: ", XToGo, ",", YToGo );
//		move( XToGo, YToGo );
//		rover.ia.log_movement( XToGo, YToGo );
////		.print( "I am at the resource!!!!!" );
////	    .print( "There are ", Quantity, " resources here" );
//		.print( "I am at my destination!!!" ); ///
//	    !collect_resource; ///
//	    .