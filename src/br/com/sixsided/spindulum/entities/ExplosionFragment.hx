package br.com.sixsided.spindulum.entities;

// Importing packages
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * SIXSIDED :: [SX] Spindulum :: Explosion Fragment 
 * ============================================================
 * 
 * Fragment for the explosion object.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class ExplosionFragment extends Sprite
{
    /**
     * Handle for the item's body.
     */
    public var frag_body:Sprite;
    
    /**
     * Handle for projectile radius.
     */
    public var frag_size:Int;
    
    /**
     * Handle for projectile speed.
     */
    public var frag_velocity:Int;
    
    /**
     * Main constructor.
     * 
     * @param radius
     *      The radius of the explosion particle
     * @param velocity
     *      The initial speed of the particle
     */
    public function new( radius:Int = null, velocity:Int = null) 
    {
        // Define internal variables
        frag_size       = radius;
        frag_velocity   = velocity;
        
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
    public function init( e:Event = null ):Void 
    {
        // Remove this event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Initializing body
        frag_body       = new Sprite();
        
        // Drawing the body
        frag_body.graphics.beginFill( 0x4a0000, 1 );
        frag_body.graphics.drawCircle( 0, 0, frag_size );
        frag_body.graphics.endFill();
        
        // Adding to the stage
        addChild( frag_body );
    }
}