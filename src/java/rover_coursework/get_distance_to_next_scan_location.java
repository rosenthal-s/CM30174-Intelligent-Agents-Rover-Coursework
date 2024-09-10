// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class get_distance_to_next_scan_location extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
//      // execute the internal action
//      ts.getAg().getLogger().info("executing internal action 'ia_submission.add_numbers'");
//      if (true) { // just to show how to throw another kind of exception
//          throw new JasonException("not implemented!");
//      }
    	
    	int xCurrent = (int)( (NumberTerm)args[0] ).solve();
    	int yCurrent = (int)( (NumberTerm)args[1] ).solve();
    	
    	int newCoordinates[] = Map.getInstance().getScanLocation();
    	
    	int xToTravel = 0;
    	int yToTravel = 0;
    	int finished = 0;
    	
    	// If the returned coordinates are (-1,-1) then the scanner's job in complete
    	// Otherwise the distance to travel is the difference between the new location and the current one
    	if( newCoordinates[0] != -1 )
    	{
    		xToTravel = newCoordinates[0] - xCurrent;
    		yToTravel = newCoordinates[1] - yCurrent;
    	}
    	else
    	{
    		finished = 1;
    	}
    	
    	return un.unifies( new NumberTermImpl( xToTravel ), args[2] ) && un.unifies( new NumberTermImpl( yToTravel ), args[3] ) && un.unifies( new NumberTermImpl( finished ), args[4] );
    }
}
