package br.com.sixsided.spindulum.screens;

// Importing packages
import br.com.sixsided.spindulum.Main;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * SIXSIDED :: [SX] Spindulum :: Screen :: Game Wins
 * ============================================================
 * 
 * This is the game wins screen.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class ScreenWins extends Sprite 
{
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Game wins title.
     */
    public var textWins:TextField;
    
    /**
     * Game score title.
     */
    public var textScore:TextField;
    
    /**
     * Thanks text.
     */
    public var textThanks:TextField;
    
    /**
     * Return text.
     */
    public var textInit:TextField;
    
    /**
     * Is finished, triggers when it's ok to start.
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
        #if android
            textFont = "_sans";
        #else
            textFont = ( null != Main.gameFont && null != Main.gameFont.fontName ) 
                     ? Main.gameFont.fontName 
                     : "_sans";
        #end
        
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
        
        // Drawing the title
        textWins = new TextField();
        textWins.defaultTextFormat = new TextFormat(
            textFont, 
            80, 
            0x000000, 
            false, 
            false, 
            false
        );
        textWins.text = "YOU BEAT THE GAME!";
        textWins.autoSize = TextFieldAutoSize.CENTER;
        textWins.type = TextFieldType.DYNAMIC;
        textWins.multiline = false;
        textWins.selectable = false;
        textWins.x = ( Main.gameScreenW / 2 ) - ( textWins.width / 2 );
        textWins.y = 32;
        
        // Adds text to screen
        addChild( textWins );
        
        // Drawing the current level
        textScore = new TextField();
        textScore.defaultTextFormat = new TextFormat(
            textFont, 
            32, 
            0x000000, 
            false, 
            false, 
            false
        );
        textScore.text = "YEP, THIS GAME HAS ONLY 10 LEVELS (FOR NOW)";
        textScore.autoSize = TextFieldAutoSize.CENTER;
        textScore.type = TextFieldType.DYNAMIC;
        textScore.multiline = false;
        textScore.selectable = false;
        textScore.x = ( Main.gameScreenW / 2 ) - ( textScore.width / 2 );
        textScore.y = 192;
        
        // Adds text to screen
        addChild( textScore );
        
        // Add thanks
        textThanks = new TextField();
        textThanks.defaultTextFormat = new TextFormat(
            textFont, 
            24, 
            0xa40000, 
            false, 
            false, 
            false
        );
        textThanks.text = "THANK YOU FOR PLAYING SPINDULUM!";
        textThanks.autoSize = TextFieldAutoSize.CENTER;
        textThanks.type = TextFieldType.DYNAMIC;
        textThanks.multiline = false;
        textThanks.selectable = false;
        textThanks.x = ( Main.gameScreenW / 2 ) - ( textThanks.width / 2 );
        textThanks.y = Main.gameScreenH - 196;
        
        // Adds text to screen
        addChild( textThanks );
        
        // Add press left or right to return
        textInit = new TextField();
        textInit.defaultTextFormat = new TextFormat(
            textFont, 
            24, 
            0x888888, 
            false, 
            false, 
            false
        );
        textInit.text = "PRESS LEFT OR RIGHT TO RETURN TO THE TITLE SCREEN";
        textInit.autoSize = TextFieldAutoSize.CENTER;
        textInit.type = TextFieldType.DYNAMIC;
        textInit.multiline = false;
        textInit.selectable = false;
        textInit.x = ( Main.gameScreenW / 2 ) - ( textInit.width / 2 );
        textInit.y = Main.gameScreenH - 128;
        
        // Adds text to screen
        addChild( textInit );
        
        // Play title
        Main.soundThanks.play();
        
        // Adds event listener to check keypress
        addEventListener( Event.ENTER_FRAME, keysDownListener );
    }
    
    /**
     * Keydown event, to start the game.
     * 
     * @param e
     *      Event handle
     */
    public function keysDownListener( e:Event ):Void 
    {
        if ( Main.inputs[37] || Main.inputs[39] ) {
            // Removes this event listener
            removeEventListener( Event.ENTER_FRAME, keysDownListener );
            
            // Tweens the alpha
            Actuate.tween(
                cast( this, ScreenWins ), 
                1, 
                {
                    alpha: 0
                }
            ).onComplete( screenFinished );
        }
    }
    
    /**
     * Declares this screen "finished".
     */
    public function screenFinished():Void 
    {
        // Sets is finished to True
        isFinished = true;
    }
}