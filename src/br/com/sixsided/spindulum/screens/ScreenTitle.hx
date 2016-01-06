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
 * SIXSIDED :: [SX] Spindulum :: Screen :: Title
 * ============================================================
 * 
 * This is the title screen.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class ScreenTitle extends Sprite 
{
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Handle for the game's title.
     */
    public var textName:TextField;
    
    /**
     * Ludum dare etc.
     */
    public var textLD:TextField;
    
    /**
     * Handle for the game's instructions.
     */
    public var textInstructions:TextField;
    
    /**
     * Handle for the game's press start to begin.
     */
    public var textInit:TextField;
    
    /**
     * Handle for the game's dedication.
     */
    public var textDedication:TextField;
    
    /**
     * Handle for the game's credits.
     */
    public var textCredit:TextField;
    
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
        
        // Drawing title
        textName = new TextField();
        textName.defaultTextFormat = new TextFormat(
            textFont, 
            96, 
            0x000000, 
            false, 
            false, 
            false
        );
        textName.text = "SPINDULUM";
        textName.autoSize = TextFieldAutoSize.CENTER;
        textName.type = TextFieldType.DYNAMIC;
        textName.multiline = false;
        textName.selectable = false;
        textName.x = ( Main.gameScreenW / 2 ) - ( textName.width / 2 );
        textName.y = 16;
        
        // Add to stage
        addChild( textName );
        
        // Drawing title
        textLD = new TextField();
        textLD.defaultTextFormat = new TextFormat(
            textFont, 
            16, 
            0x000000, 
            false, 
            false, 
            false
        );
        textLD.text = "A GAME MADE FOR LUDUM DARE #34 • THEME(S): 2 BUTTON CONTROLS + GROWING";
        textLD.autoSize = TextFieldAutoSize.CENTER;
        textLD.type = TextFieldType.DYNAMIC;
        textLD.multiline = false;
        textLD.selectable = false;
        textLD.x = ( Main.gameScreenW / 2 ) - ( textLD.width / 2 );
        textLD.y = 128;
        
        // Add to stage
        addChild( textLD );
        
        // ----------------------------------------------------------------- //
        
        // Instructions format
        var instructionsFormat = new TextFormat(
            textFont, 
            16, 
            0x000000, 
            false, 
            false, 
            false
        );
        #if flash
            instructionsFormat.align = TextFormatAlign.CENTER;
        #else
            cast( instructionsFormat, TextFormat ).align = TextFormatAlign.CENTER;
        #end
        
        // Instructions
        textInstructions = new TextField();
        textInstructions.defaultTextFormat = instructionsFormat;
        textInstructions.text = "You're a red dot attached to a collector.\nOrange dots makes you grow, Blue makes you shrink.\nRotate your collector left and right to gobble the orange dots, but don't let it touch the blue dots.\nGobble as much as orange dots needed to grow and fill the gray area.\nWhen you're big enough, press LEFT AND RIGHT to explode and advance to the next level.\nIf you shrink to less than half the initial size, it's game over.";
        textInstructions.autoSize = TextFieldAutoSize.CENTER;
        textInstructions.type = TextFieldType.DYNAMIC;
        textInstructions.multiline = true;
        textInstructions.selectable = false;
        textInstructions.x = ( Main.gameScreenW / 2 ) - ( textInstructions.width / 2 );
        textInstructions.y = 196;
        textInstructions.height = 256;
        
        // Add to stage
        addChild( textInstructions );
        
        // ----------------------------------------------------------------- //
        
        // Drawing press
        textInit = new TextField();
        textInit.defaultTextFormat = new TextFormat(
            textFont, 
            32, 
            0x888888, 
            false, 
            false, 
            false
        );
        textInit.text = "PRESS LEFT OR RIGHT TO START";
        textInit.autoSize = TextFieldAutoSize.CENTER;
        textInit.type = TextFieldType.DYNAMIC;
        textInit.multiline = false;
        textInit.selectable = false;
        textInit.x = ( Main.gameScreenW / 2 ) - ( textInit.width / 2 );
        textInit.y = 420;
        
        // Add to stage
        addChild( textInit );
        
        // Drawing dedication
        textDedication = new TextField();
        textDedication.defaultTextFormat = new TextFormat(
            textFont, 
            22, 
            0xa40000, 
            false, 
            false, 
            false
        );
        textDedication.text = "Dedicated to my beloved, Glauce";
        textDedication.autoSize = TextFieldAutoSize.CENTER;
        textDedication.type = TextFieldType.DYNAMIC;
        textDedication.multiline = false;
        textDedication.selectable = false;
        textDedication.x = ( Main.gameScreenW / 2 ) - ( textDedication.width / 2 );
        textDedication.y = Main.gameScreenH - 80;
        
        // Add to stage
        addChild( textDedication );
        
        // Drawing credits
        textCredit = new TextField();
        textCredit.defaultTextFormat = new TextFormat(
            textFont, 
            16, 
            0x000000, 
            false, 
            false, 
            false
        );
        textCredit.text = "®2015 SIXSIDED Developments / Fabio Y. Goto";
        textCredit.autoSize = TextFieldAutoSize.CENTER;
        textCredit.type = TextFieldType.DYNAMIC;
        textCredit.multiline = false;
        textCredit.selectable = false;
        textCredit.x = ( Main.gameScreenW / 2 ) - ( textCredit.width / 2 );
        textCredit.y = Main.gameScreenH - 48;
        
        // Add to stage
        addChild( textCredit );
        
        // Play title
        Main.soundTitle.play();
        
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
                cast( this, ScreenTitle ), 
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