package br.com.sixsided.spindulum.entities;

// Importing packages
import motion.Actuate;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * SIXSIDED :: [SX] Spindulum :: Button (Mobile) 
 * ============================================================
 * 
 * Just a mobile button handler.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class Button extends MovieClip
{
    /**
     * Some overlay, for mouse events.
     */
    public var buttonOverlays:MovieClip;
     
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Button text.
     */
    public var textData:String;
    
    /**
     * Button textfield.
     */
    public var textShow:TextField;
    
    /**
     * Keycode, to emulate left/right and other things.
     */
    public var keycode:Int = 0;
    
    /**
     * Main constructor.
     * 
     * @param text
     *      Text for the button
     */
    public function new( text:String = "X" ) 
    {
        // Determines font name
        textFont = ( null != Main.gameFont && null != Main.gameFont.fontName ) 
                 ? Main.gameFont.fontName 
                 : "_sans";
        
        // Determinig text
        textData = text;
        
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
     * Main event, initializes the game.
     * 
     * @param e 
     *      Event handler
     */
    public function init( e:Event ):Void 
    {
        // Remove this event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Debug message
        trace( 'Button Rendered!' );
        
        // Drawing the button
        graphics.beginFill( 0xdddddd, 1 );
        graphics.drawRect( 0, 0, 480, 480 );
        graphics.endFill();
        
        // Generating text box
        textShow = new TextField();
        textShow.defaultTextFormat = new TextFormat(
            textFont, 
            320, 
            0x555555, 
            false, 
            false, 
            false
        );
        textShow.text = textData;
        textShow.autoSize = TextFieldAutoSize.CENTER;
        textShow.type = TextFieldType.DYNAMIC;
        textShow.multiline = false;
        textShow.selectable = false;
        textShow.x = ( this.width / 2 ) - ( textShow.width / 2 );
        textShow.y = ( ( this.height / 2 ) - ( textShow.height / 2 ) ) + 40;
        
        // Adds text
        addChild( textShow );
        
        // Adds overlay as an invisible item
        buttonOverlays = new MovieClip();
        buttonOverlays.graphics.beginFill( 0xaaaaaa, 1 );
        buttonOverlays.graphics.drawRect( 0, 0, 480, 480 );
        buttonOverlays.graphics.endFill();
        
        // Sets overlay alpha to 0;
        buttonOverlays.alpha = 0;
        
        // Add overlay
        addChild( buttonOverlays );
        
        // Adding event listeners
        this.addEventListener( MouseEvent.MOUSE_DOWN, pointersDown );
        this.addEventListener( MouseEvent.MOUSE_UP, pointersUp );
    }
    
    /**
     * Mouse down event.
     * 
     * @param e
     *      Mouse event handle.
     */
    public function pointersDown( e:MouseEvent ):Void 
    {
        // Tweening overlay
        Actuate.tween(
            cast( buttonOverlays, MovieClip ), 
            0.5, 
            {
                alpha: .50
            }
        );
    }
    
    /**
     * Mouse up event.
     * 
     * @param e
     *      Mouse event handle.
     */
    public function pointersUp( e:MouseEvent ):Void 
    {
        // Tweening overlay
        Actuate.tween(
            cast( buttonOverlays, MovieClip ), 
            0.5, 
            {
                alpha: 0
            }
        );
    }
}