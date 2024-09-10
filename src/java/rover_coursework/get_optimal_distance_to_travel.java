// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class get_optimal_distance_to_travel extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	
    	int xDistance = (int)((NumberTerm) args[0]).solve();
    	int yDistance = (int)((NumberTerm) args[1]).solve();
    	
    	int mapWidth = (int)((NumberTerm) args[2]).solve();
    	int mapHeight = (int)((NumberTerm) args[3]).solve();
    	
    	// The pathing is stupid and can loop round the map multiple times, so we get the remainder by dividing by map size to simplify
    	int moduloX = xDistance % mapWidth;
    	int moduloY = yDistance % mapHeight;
    	
    	// We then decide whether to travel in negative or positive directions, whichever has the lowest absolute distance
    	int otherSignXDistance;
    	int otherSignYDistance;
    	if( moduloX >= 0 )
    	{
    		otherSignXDistance = moduloX - mapWidth;
    		otherSignYDistance = moduloY - mapHeight;
    	}
    	else
    	{
    		otherSignXDistance = moduloX + mapWidth;
    		otherSignYDistance = moduloY + mapHeight;
    	}
    	
		int optimalXDistance = Math.abs( moduloX ) < Math.abs( otherSignXDistance ) ? moduloX : otherSignXDistance;
		int optimalYDistance = Math.abs( moduloY ) < Math.abs( otherSignYDistance ) ? moduloY : otherSignYDistance;
    	
    	return un.unifies(new NumberTermImpl( optimalXDistance ), args[4]) && un.unifies(new NumberTermImpl( optimalYDistance ), args[5]);
    	
//        // execute the internal action
//        ts.getAg().getLogger().info("executing internal action 'ia_submission.add_numbers'");
//        if (true) { // just to show how to throw another kind of exception
//            throw new JasonException("not implemented!");
//        }
//
//        // everything ok, so returns true
//        return true;
    }
}
