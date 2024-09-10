// Agent scenario2_scout in project ia_submission

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start:	true
	<-	.print( "hello world." );
		rover.ia.get_map_size( MapWidth, MapHeight );
		rover.ia.check_config( Capacity, ScanRange, ResourceType );
		rover_coursework.initialise_map( MapWidth, MapHeight, ScanRange );
		scan( 6 );
		!move;
		.

+!move:	true
	<-	rover.ia.get_distance_from_base( XDistanceTravelled, YDistanceTravelled );
		.print( "move - I am at ", -XDistanceTravelled, ",", -YDistanceTravelled ); ///
		rover_coursework.get_distance_to_next_scan_location( -XDistanceTravelled, -YDistanceTravelled, X, Y, Finished );
		if( Finished == 0 )
		{
			move( X, Y );
			rover.ia.log_movement( X, Y );
			scan( 6 );
			!move;
		}
		else
		{
			// Return to base before instructing the heavy agent to move
			rover.ia.get_map_size( MapWidth, MapHeight ); ///
			rover_coursework.get_optimal_distance_to_travel( XDistanceTravelled, YDistanceTravelled, MapWidth, MapHeight, XToBase, YToBase ); ///
			move( XToBase, YToBase ); ///
//			move( XDistanceTravelled, YDistanceTravelled ); ///
			rover.ia.clear_movement_log;
			.send( banker, achieve, new_move );
		}
		.

//-!start: true
//	<-	print(""); ///
//		.

//+!send_location: true ///
//	<-	findall([X,Y],locations(X,Y),LocalBelief).nth(0,LocalBelief,Item)
//		.print( "Location: ", X, ",", Y );
//		.

@resource_found[atomic]
// Alert the agent about the resource found
+ resource_found( ResourceType, Quantity, XDist, YDist ):	ResourceType = "Gold" | ResourceType = "Diamond"
	<-	rover.ia.get_distance_from_base( XDistanceTravelled, YDistanceTravelled );
//		.print( "resource_found - I am at ", -XDistanceTravelled, ",", -YDistanceTravelled );
//		.print( "Resource found ", XDist, ",", YDist, " away from me" );
		// Sum distances travelled and distance from scout to find total distance (We subtract because the distances from base are negative).
		// The pathing is stupid and can loop round the map multiple times, so we get the remainder by dividing by map size to simplify
		// and then decide whether to travel in negative or positive directions, whichever has the lowest absolute distance
		rover.ia.get_map_size( MapWidth, MapHeight );
		rover_coursework.get_optimal_distance_to_travel( XDist - XDistanceTravelled, YDist - YDistanceTravelled, MapWidth, MapHeight, XFinal, YFinal );
		// Send the distance to the heavy
		.print("Saving location: ", XFinal, ",", YFinal, " which contains ", ResourceType );
//		.send( heavy, achieve, resource_located( XFinal, YFinal ) );
//		+locations( XFinal, YFinal ); ///
		rover_coursework.set_resource_info( XFinal, YFinal, ResourceType, Quantity );
	    .