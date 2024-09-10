// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class set_resource_info extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
//      // execute the internal action
//      ts.getAg().getLogger().info("executing internal action 'ia_submission.add_numbers'");
//      if (true) { // just to show how to throw another kind of exception
//          throw new JasonException("not implemented!");
//      }
    	
    	int x = (int)( (NumberTerm)args[0] ).solve();
    	int y = (int)( (NumberTerm)args[1] ).solve();
    	String resource = ( (StringTerm)args[2] ).getString();
    	int quantity = (int)( (NumberTerm)args[3] ).solve();
    	
    	int resourceID;
    	if( resource.equals( "Gold" ) )
    	{
    		resourceID = 0;
    	}
    	else if( resource.equals( "Diamond" ) )
    	{
    		resourceID = 1;
    	}
    	else
    	{
    		throw new JasonException( "Invalid resource" );
    	}
    	
    	Map map = Map.getInstance();
    	map.setResourceInfo( x, y, resourceID, quantity );
    	
    	return true;
    }
}
