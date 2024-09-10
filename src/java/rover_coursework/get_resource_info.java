// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class get_resource_info extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
//      // execute the internal action
//      ts.getAg().getLogger().info("executing internal action 'ia_submission.add_numbers'");
//      if (true) { // just to show how to throw another kind of exception
//          throw new JasonException("not implemented!");
//      }
    	
    	String resource = ( (StringTerm)args[0] ).getString();
    	
    	int finished = 0;
    	
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
    	int info[] = map.getResourceInfo( resourceID );
    	
    	System.out.println( "get_resource_info.java: Location=(" + String.valueOf( info[0] ) + "," + String.valueOf( info[1] ) + "), Quantity=" + String.valueOf( info[2] ) ); /// test
    	
    	// If quantity is -1 then there are no more resources to collect
    	if( info[2] == -1 )
    	{
    		finished = 1;
    	}
    	
    	return un.unifies( new NumberTermImpl( info[0] ), args[1] ) && un.unifies( new NumberTermImpl( info[1] ), args[2] ) && un.unifies( new NumberTermImpl( info[2] ), args[3] ) && un.unifies( new NumberTermImpl( finished ), args[4] );
    }
}
