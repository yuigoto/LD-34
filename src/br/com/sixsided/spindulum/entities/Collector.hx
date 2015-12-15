package br.com.sixsided.spindulum.entities;

// Importing packages
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * SIXSIDED :: [SX] Gobble 
 * ============================================================
 * 
 * This is a simple and abstract action game, made for LD#34.
 * 
 * Themes for this Ludum Dare are:
 * - Two button controls;
 * - Growing;
 * 
 * Controls:
 * - Left;
 * - Right;
 * 
 * You're a tiny dot attached to a collector.
 * 
 * Collect the orange dots, while avoiding the blue dots, to make yourself 
 * grow in size.
 * 
 * You've got to grow at the minimum size of the gray area before you're able 
 * to press "LEFT" and "RIGHT" at the same time, so you can explode and advance 
 * to the next level.
 * 
 * Every level, the gray area increases and the average speed for the dots also 
 * increase.
 * 
 * Can you make it to the 10th level?
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.0.0
 * @copy       ®2015 SIXSIDED Developments
 */
class Collector extends Sprite 
{
    /**
     * Handle for the body (hitbox) of the Collector.
     */
    var body:Sprite;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Calling super constructor
		super();
        
        // If stage is set
        if ( null != stage ) {
            // Executes main event
            init( null );
        } else {
            // If not, adds main event as an event listener
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    /**
     * Main event.
     * 
     * @param e Event
     */
    public function init( e:Event ):Void 
    {
        // Remove this event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Debug message
        trace( 'Collector Created!' );
        
        // Creating the body
        body = new Sprite();
        
        // Drawing the body
        body.graphics.beginFill( 0xef2929, 1 );
        body.graphics.drawCircle( 0, 0, 16 );
        body.graphics.endFill();
        
        // Adds the body to stage
        addChild( body );
    }
}