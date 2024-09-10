// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class initialise_map extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
//      // execute the internal action
//      ts.getAg().getLogger().info("executing internal action 'ia_submission.add_numbers'");
//      if (true) { // just to show how to throw another kind of exception
//          throw new JasonException("not implemented!");
//      }
    	
    	int mapWidth = (int)( (NumberTerm)args[0] ).solve();
    	int mapHeight = (int)( (NumberTerm)args[1] ).solve();
    	int scanRange = (int)( (NumberTerm)args[2] ).solve();
    	
    	Map map = Map.getInstance();
    	map.initialise( mapWidth, mapHeight, scanRange );
    	
    	return true;
    }
}
