// Internal action code for project ia_submission

package rover_coursework;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class overwrite_number extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	
    	int number = (int)( (NumberTerm)args[0] ).solve();
    	
    	return un.unifies( new NumberTermImpl( number ), args[1] );
    	
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
