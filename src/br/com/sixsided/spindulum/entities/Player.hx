package br.com.sixsided.spindulum.entities;

// Importing packages
import br.com.sixsided.spindulum.Main;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * SIXSIDED :: [SX] Spindulum :: Player handler
 * ============================================================
 * 
 * Fragment for the explosion object.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.0.0
 * @copy       ®2015 SIXSIDED Developments
 */
class Player extends Sprite 
{
    /**
     * Collector sprite handle.
     */
    public var pickerBody:Sprite;
    
    /**
     * Collector hitbox.
     */
    public var pickerHitbox:Sprite;
    
    /**
     * Player body handle.
     */
    public var playerBody:Sprite;
    
    /**
     * Player minimum allowed size.
     */
    public var playerMins:Sprite;
    
    /**
     * Player boundaries handle.
     */
    public var playerMark:Sprite;
    
    /**
     * The maximum radius for the player's boundaries.
     */
    public var markRadius:Int;
    
    /**
     * Player invisible boundaries handle.
     * 
     * Helps with rotation.
     */
    public var playerOuts:Sprite;
    
    /**
     * If TRUE, means that the player is dead and its body has reached 
     * 0px.
     */
    public var isPlayerDead:Bool = false;
    
    /**
     * If TRUE, means that the player has won the game, party TIME!
     */
    public var isPlayerGood:Bool = false;
    
    /**
     * Player rotation speed.
     */
    public var velocity:Int = 0;
    
    /**
     * Main constructor.
     * 
     * @param radius 
     *      The radius of the boundary circle, that the player must reach 
     *      to win the round.
     */
    public function new( radius:Int = 128 ) 
    {
        // Checking radius
        markRadius = ( radius > 0 && radius > 16 ) ? radius : 128;
        
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
        
        // Checking if markRadius is less than stageWidth / 2
        if ( markRadius >= ( Main.gameScreenW / 2 ) ) {
            markRadius = Math.round( Main.gameScreenW / 2 ) - 32;
        }
        
        // Drawing the invisible barrier
        playerOuts = new Sprite();
        
        // Drawing invisible barrier
        playerOuts.graphics.beginFill( 0x999999, 0 );
        playerOuts.graphics.drawCircle( 0, 0, markRadius + 32 );
        playerOuts.graphics.endFill();
        
        // Add to stage
        addChild( playerOuts );
        
        // Drawing the visible barrier
        playerMark = new Sprite();
        
        // Drawing visible barrier
        playerMark.graphics.beginFill( 0xbbbbbb, 1 );
        playerMark.graphics.drawCircle( 0, 0, markRadius );
        playerMark.graphics.endFill();
        
        // Add to stage
        addChild( playerMark );
        
        // Drawing the stick
        var sticks:Sprite = new Sprite();
        sticks.graphics.lineStyle( 2, 0xa40000 );
        sticks.graphics.moveTo( 0, 0 );
        sticks.graphics.lineTo( 0, markRadius * ( -1 ) );
        
        // Add to stage
        addChild( sticks );
        
        // Drawing the player's minimum size
        playerMins = new Sprite();
        
        // Drawing player's body
        playerMins.graphics.beginFill( 0x888888, .5 );
        playerMins.graphics.drawCircle( 0, 0, 16 );
        playerMins.graphics.endFill();
        
        // Add to stage
        addChild( playerMins );
        
        // Drawing the player's body
        playerBody = new Sprite();
        
        // Drawing player's body
        #if flash
            playerBody.graphics.beginFill( 0xa40000, 1 );
            playerBody.graphics.drawCircle( 0, 0, 16 );
            playerBody.graphics.endFill();
        #else
            playerBody.graphics.beginFill( 0xa40000, 1 );
            playerBody.graphics.drawCircle( 0, 0, 64 );
            playerBody.graphics.endFill();
            
            playerBody.width = 32;
            playerBody.height = 32;
        #end
        
        // Add to stage
        addChild( playerBody );
        
        // Drawing the collector
        pickerBody = new Sprite();
        
        // Drawing player's body
        pickerBody.graphics.beginFill( 0xef2929, 1 );
        pickerBody.graphics.drawCircle( 0, markRadius * ( - 1 ), 16 );
        pickerBody.graphics.endFill();
        
        // Add to stage
        addChild( pickerBody );
        
        // Drawing the collector's hitbox
        pickerHitbox = new Sprite();
        
        // Drawing player's body
        pickerHitbox.graphics.beginFill( 0xef2929, 1 );
        pickerHitbox.graphics.drawCircle( 0, markRadius * ( - 1 ), 10 );
        pickerHitbox.graphics.endFill();
        
        // Add to stage
        addChild( pickerHitbox );
    }
}   