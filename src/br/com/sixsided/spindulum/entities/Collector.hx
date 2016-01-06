package br.com.sixsided.spindulum.entities;

// Importing packages
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * SIXSIDED :: [SX] Spindulum :: Collector
 * ============================================================
 * 
 * Player body collector.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
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