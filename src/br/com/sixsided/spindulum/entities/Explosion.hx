package br.com.sixsided.spindulum.entities;

// Importing packages
import br.com.sixsided.spindulum.Main;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * SIXSIDED :: [SX] Spindulum :: Explosion Fragment 
 * ============================================================
 * 
 * Explosion object, serves as the transition between levels and game 
 * over too.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.0.0
 * @copy       ®2015 SIXSIDED Developments
 */
class Explosion extends Sprite 
{
    /**
     * Holds all the particles in the explosion.
     */
    public var particle:Array<ExplosionFragment>;
    
    /**
     * Maximum number of particles in the explosion.
     */
    public var particlesNumber:Int;
    
    /**
     * Whem TRUE, triggers the fade out animation.
     */
    public var triggersFade:Bool = false;
    
    /**
     * Object that works as the fade to black.
     */
    public var fadeDark:Sprite;
    
    /**
     * Initial speed for the fade to black.
     */
    public var fadeDarkVelocity:Int = 1;
    
    /**
     * Object that works as the fade to white.
     */
    public var fadeLite:Sprite;
    
    /**
     * Initial speed for the fade to white.
     */
    public var fadeLiteVelocity:Int = 1;
    
    /**
     * When set to true, indicates that the dark part is covering.
     */
    public var isCovering:Bool = false;
    
    /**
     * When set to true, indicates that the animation has finished.
     */
    public var isFinished:Bool = false;
    
    /**
     * Main constructor.
     * 
     * @param number
     *      The number of particles in the main explosion
     */
    public function new( number:Int = null ) 
    {
        // Define variables
        particlesNumber = ( number != null && number > 0 ) ? number : 64;
        
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
        
        // Debug
        trace( 'Explosion initialized!' );
        
        // Initialize particle array
        particle = new Array();
        
        // Initialize fade objects
        fadeDark = new Sprite();
        fadeLite = new Sprite();
        
        // Generating particles
        for ( i in 0...particlesNumber ) {
            // Temporary particle variable
            var temp:ExplosionFragment = new ExplosionFragment(
                // Radius
                Main.randomNumber( 16, 48 ), 
                // Speed
                Main.randomNumber( 8, 32 )
            );
            
            // Defining position (relative to this class's object)
            temp.x = 0;
            temp.y = 0;
            
            // Choosing angle
            temp.rotation = Main.randomNumber( 0, 359 );
            
            // Pushing into the array
            particle.push( temp );
            
            // Adding to the stage
            addChild( temp );
        }
        
        // Adding the animation event listener
        addEventListener( Event.ENTER_FRAME, explodeInit );
    }
    
    /**
     * Manages the "ENTER_FRAME" event during the explosion.
     * 
     * @param e 
     *      Event handle
     */
    public function explodeInit( e:Event ):Void 
    {
        // Initial loop
        for ( i in 0...particle.length ) {
            // If particle isn't null
            if ( particle[i] != null ) {
                // Reducing the particle's width
                if ( particle[i].frag_body.width > 1 ) {
                    particle[i].frag_body.width -= 2;
                }
                
                // Reducing the particle's height
                if ( particle[i].frag_body.height > 1 ) {
                    particle[i].frag_body.height -= 2;
                }
                
                // Declaring speed variable
                var currspd:Int = 0;
                
                // Getting particle speed 
                #if flash
                    currspd = particle[i].frag_velocity;
                #else
                    currspd = cast(
                        particle[i], 
                        ExplosionFragment 
                    ).frag_velocity;
                #end
                
                // Defining new position
                var newPos:Point = Main.vertexFinder(
                    particle[i].rotation, 
                    currspd, 
                    particle[i].x, 
                    particle[i].y 
                );
                
                // Moving the particle
                particle[i].x = newPos.x;
                particle[i].y = newPos.y;
                
                // Checking the need to remove or not a particle
                if (
                    particle[i].frag_body.width <= 8 
                    || particle[i].frag_body.height <= 8 
                ) {
                    // Removes child from stage
                    removeChild( particle[i] );
                    
                    // Sets particle as null
                    particle[i] = null;
                } else {
                    // Reducing the ball's speed, if isn't removed
                    if ( currspd > 1 ) {
                        #if flash 
                            particle[i].frag_velocity -= 1;
                        #else 
                            cast( 
                                particle[i], 
                                ExplosionFragment
                            ).frag_velocity -= 1;
                        #end
                    }
                }
            } else {
                // In case of null particle, is trigger isn't set, set it
                if ( !triggersFade ) triggersFade = true;
                
                // Triggers the fade to black
                fadeToDark();
            }
        }
    }
    
    /**
     * Initializes the fade to dark event.
     */
    public function fadeToDark():Void 
    {
        // Creating element
        fadeDark.graphics.beginFill( 0x000000, 1 );
        #if flash
            fadeDark.graphics.drawCircle(
                0, 
                0, 
                1
            );
        #else
            fadeDark.graphics.drawCircle(
                0, 
                0, 
                32
            );
        #end
        fadeDark.graphics.endFill();
        
        // Define position and alpha
        fadeDark.alpha = 1;
        
        // Add to stage
        addChild( fadeDark );
        
        // Add event listener
        addEventListener( Event.ENTER_FRAME, fadeToDarkExec );
    }
    
    /**
     * Event listener for the fade to dark animation.
     * 
     * @param e 
     *      Event handle
     */
    public function fadeToDarkExec( e:Event ):Void 
    {
        // Increase speed of the fade
        fadeDarkVelocity += 4;
            
        // Change alpha
        if ( fadeDark.alpha < 1 ) fadeDark.alpha += 0.25;
            
        // If fade width is less than stage width
        if ( fadeDark.width < Main.gameScreenW * 1.5 ) {
            // Increase the fade
            fadeDark.width += fadeDarkVelocity;
            fadeDark.height += fadeDarkVelocity;
        } else {
            // Removes all fragments from stage
            for ( i in 0...particle.length ) {
                // If this fragment isn't null
                if ( particle[i] != null ) {
                    // Removes this fragment from stage
                    removeChild( particle[i] );
                    
                    // Sets it as null
                    particle[i] = null;
                }
            }
            
            // Defines that this element is covering the screen
            isCovering = true;
            
            // Removes explosion event listener
            removeEventListener( Event.ENTER_FRAME, explodeInit );
            
            // Removes this event listener
            removeEventListener( Event.ENTER_FRAME, fadeToDarkExec );
            
            // Triggers white fade
            fadeToLite();
        }
    }
    
    /**
     * Initializes the fade to white event.
     */
    public function fadeToLite():Void 
    {
        // Creating element
        fadeLite.graphics.beginFill( 0xffffff, 1 );
        #if flash
            fadeLite.graphics.drawCircle(
                0, 
                0, 
                1
            );
        #else
            fadeLite.graphics.drawCircle(
                0, 
                0, 
                32
            );
        #end
        fadeLite.graphics.endFill();
        
        // Define position and alpha
        fadeLite.alpha = 0;
        
        // Add to stage
        addChild( fadeLite );
        
        // Add event listener
        addEventListener( Event.ENTER_FRAME, fadeToLiteExec );
    }
    
    /**
     * Event listener for the fade to white animation.
     * 
     * @param e 
     *      Event handle
     */
    public function fadeToLiteExec( e:Event ):Void 
    {
        // Increase speed of the fade
        fadeLiteVelocity += 3;
            
        // Change alpha
        if ( fadeLite.alpha < 1 ) fadeLite.alpha += 0.25;
            
        // If fade width is less than stage width
        if ( fadeLite.width < Main.gameScreenW * 1.5 ) {
            // Increase the fade
            fadeLite.width += fadeLiteVelocity;
            fadeLite.height += fadeLiteVelocity;
        } else {
            // Removes the fade to dark
            removeChild( fadeDark );
            
            // Removes the fade to white
            removeChild( fadeLite );
            
            // Set both fades and the particles as null
            fadeDark = null;
            fadeLite = null;
            particle = null;
            
            // Changes finished status
            isFinished = true;
            
            // Removes this event listener
            removeEventListener( Event.ENTER_FRAME, fadeToLiteExec );
        }
    }
}