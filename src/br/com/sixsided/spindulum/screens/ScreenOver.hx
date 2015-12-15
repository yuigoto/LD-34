package br.com.sixsided.spindulum.screens;

// Importing packages
import br.com.sixsided.spindulum.Main;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * SIXSIDED :: [SX] Spindulum :: Screen :: Game Over
 * ============================================================
 * 
 * This is the game over screen.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.0.0
 * @copy       ®2015 SIXSIDED Developments
 */
class ScreenOver extends Sprite 
{
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Game over title.
     */
    public var textOver:TextField;
    
    /**
     * Score current text.
     */
    public var textCurrent:TextField;
    
    /**
     * Score best text.
     */
    public var textBest:TextField;
    
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
        
        // Drawing the title
        textOver = new TextField();
        textOver.defaultTextFormat = new TextFormat(
            textFont, 
            80, 
            0x000000, 
            false, 
            false, 
            false
        );
        textOver.text = "GAME OVER";
        textOver.autoSize = TextFieldAutoSize.CENTER;
        textOver.antiAliasType = AntiAliasType.ADVANCED;
        textOver.type = TextFieldType.DYNAMIC;
        textOver.multiline = false;
        textOver.selectable = false;
        textOver.x = ( Main.gameScreenW / 2 ) - ( textOver.width / 2 );
        textOver.y = 32;
        
        // Adds text to screen
        addChild( textOver );
        
        // Drawing the current level
        textCurrent = new TextField();
        textCurrent.defaultTextFormat = new TextFormat(
            textFont, 
            32, 
            0x000000, 
            false, 
            false, 
            false
        );
        if ( Main.levelCurrent > 0 ) {
            textCurrent.text = ( Main.levelCurrent < 9 ) 
                             ? "YOU MANAGED TO REACH: LEVEL 0" + ( Main.levelCurrent + 1 )
                             : "YOU MANAGED TO REACH: LEVEL " + ( Main.levelCurrent + 1 );
        } else {
            textCurrent.text = "YOU DIED IN THE FIRST LEVEL";
        }
        textCurrent.autoSize = TextFieldAutoSize.CENTER;
        textCurrent.antiAliasType = AntiAliasType.ADVANCED;
        textCurrent.type = TextFieldType.DYNAMIC;
        textCurrent.multiline = false;
        textCurrent.selectable = false;
        textCurrent.x = ( Main.gameScreenW / 2 ) - ( textCurrent.width / 2 );
        textCurrent.y = 192;
        
        // Adds text to screen
        addChild( textCurrent );
        
        // Drawing the best level
        /*
        textBest = new TextField();
        textBest.defaultTextFormat = new TextFormat(
            textFont, 
            32, 
            0x000000, 
            false, 
            false, 
            false
        );
        if ( Main.levelCurrent == Main.levelRecord && Main.levelRecord > 0 ) {
            textBest.text = "YOU DIDN'T EVEN FINISH THE FIRST LEVEL!";
        } else {
            if ( Main.levelRecord > Main.levelCurrent ) {
                textBest.text = ( Main.levelRecord < 9 ) 
                              ? "YOUR BEST: LEVEL 0" + ( Main.levelRecord + 1 )
                              : "YOUR BEST: LEVEL " + ( Main.levelRecord + 1 );
            } else {
                textBest.text = "YOU DIDN'T EVEN FINISHED THE FIRST LEVEL!";
            }
        }
        textBest.autoSize = TextFieldAutoSize.CENTER;
        textBest.antiAliasType = AntiAliasType.ADVANCED;
        textBest.type = TextFieldType.DYNAMIC;
        textBest.multiline = false;
        textBest.selectable = false;
        textBest.x = ( Main.gameScreenW / 2 ) - ( textBest.width / 2 );
        textBest.y = 240;
        
        // Adds text to screen
        addChild( textBest );
        */
        
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
        textThanks.antiAliasType = AntiAliasType.ADVANCED;
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
        textInit.antiAliasType = AntiAliasType.ADVANCED;
        textInit.type = TextFieldType.DYNAMIC;
        textInit.multiline = false;
        textInit.selectable = false;
        textInit.x = ( Main.gameScreenW / 2 ) - ( textInit.width / 2 );
        textInit.y = Main.gameScreenH - 128;
        
        // Adds text to screen
        addChild( textInit );
        
        // Add Event Listener
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keysDownListener );
    }
    
    /**
     * Keydown event, to start the game.
     * 
     * @param e
     *      KeyboardEvent handle
     */
    public function keysDownListener( e:KeyboardEvent ):Void 
    {
        if ( e.keyCode == 37 || e.keyCode == 39 ) {
            // Removes this event listener
            stage.removeEventListener( KeyboardEvent.KEY_DOWN, keysDownListener );
            
            // Tweens the alpha
            Actuate.tween(
                cast( this, ScreenOver ), 
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