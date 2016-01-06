package br.com.sixsided.spindulum.entities;
import br.com.sixsided.spindulum.Main;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * SIXSIDED :: [SX] Spindulum :: Init Counter
 * ============================================================
 * 
 * This is the pre-round counter (a "ready....GO!" counter only :P).
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class InitCounter extends Sprite 
{
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Handle for the initial text field.
     */
    public var textInit:TextField;
    
    /**
     * Handle for the last text field.
     */
    public var textGo:TextField;
    
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
     * Identifies that the object is on view.
     */
    public var isCovering:Bool = false;
    
    /**
     * When set to true, indicates that the animation has finished.
     */
    public var isFinished:Bool = false;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Calling super constructor
        super();
        
        // Determines font name
        textFont = ( null != Main.gameFont && null != Main.gameFont.fontName ) 
                 ? Main.gameFont.fontName 
                 : "_sans";
        
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
        trace( 'Init Counter, initialized!' );
        
        // Initialize fade objects
        fadeDark = new Sprite();
        fadeLite = new Sprite();
        
        // Adding the animation event listener
        fadeToDark();
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
        if ( fadeDarkVelocity < 48 ) fadeDarkVelocity += 4;
            
        // Change alpha
        if ( fadeDark.alpha < 1 ) fadeDark.alpha += 0.25;
            
        // If fade width is less than stage width
        if ( fadeDark.width < Main.gameScreenW * 1.5 ) {
            // Increase the fade
            fadeDark.width += fadeDarkVelocity;
            fadeDark.height += fadeDarkVelocity;
        } else {
            // Defines that it's ok to Draw the game screen
            isCovering = true;
            
            // Removes this event listener
            removeEventListener( Event.ENTER_FRAME, fadeToDarkExec );
            
            // Initialize first text field
            textInit = new TextField();
            textInit.defaultTextFormat = new TextFormat(
                // Font
                textFont, 
                // Text Size
                64, 
                // Color
                0xffffff, 
                // Bold?
                false, 
                // Italic?
                false, 
                // Underline?
                false
            );
            textInit.text = "READY";
            textInit.autoSize = TextFieldAutoSize.CENTER;
            textInit.type = TextFieldType.DYNAMIC;
            textInit.multiline = false;
            textInit.selectable = false;
            textInit.x = -( textInit.width / 2 );
            textInit.y = -( textInit.height / 2 );
            textInit.alpha = 0;
            
            // Adds text to screen
            addChild( textInit );
        
            // Play title
            Main.soundReady.play();
            
            // Animating text and, after complete, initializes fadeToLite
            Actuate.tween(
                textInit, 
                .5, 
                {
                    alpha: 1
                }
            ).onComplete( fadeToLite );
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
        if ( fadeLiteVelocity < 48 ) fadeLiteVelocity += 3;
            
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
            
            // Removes the initial text
            removeChild( textInit );
            
            // Set both fades and the particles as null
            fadeDark = null;
            
            // Initialize first text field
            textGo = new TextField();
            textGo.defaultTextFormat = new TextFormat(
                // Font
                textFont, 
                // Text Size
                128, 
                // Color
                0x000000, 
                // Bold?
                false, 
                // Italic?
                false, 
                // Underline?
                false
            );
            textGo.text = "GO!";
            textGo.autoSize = TextFieldAutoSize.CENTER;
            textGo.type = TextFieldType.DYNAMIC;
            textGo.multiline = false;
            textGo.selectable = false;
            textGo.x = -( textGo.width / 2 );
            textGo.y = -( textGo.height / 2 );
            textGo.alpha = 0;
            
            // Adds text to screen
            addChild( textGo );
        
            // Play title
            Main.soundGo.play();
            
            // Removes this event listener
            removeEventListener( Event.ENTER_FRAME, fadeToLiteExec );
            
            // Animating text and, after complete, initializes fadeToLite
            Actuate.tween(
                textGo, 
                .5, 
                {
                    alpha: 1
                }
            ).onComplete( fadeThis );
        }
    }
    
    /**
     * Changes status to finished.
     */
    public function fadeThis():Void 
    {
        // Actuates this item
        Actuate.tween(
            this, 
            0.5, 
            {
                alpha: 0
            }
        ).onComplete( finishThis );
    }
    
    /**
     * Sets this object as finished.
     */
    public function finishThis():Void 
    {
        // Removes the fade to white
        removeChild( fadeLite );
        
        // Removes the finish text
        removeChild( textGo );
        
        // Defines this as finished
        isFinished = true;
    }
}