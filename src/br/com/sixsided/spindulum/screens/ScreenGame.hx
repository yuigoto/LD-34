package br.com.sixsided.spindulum.screens;

// Importing packages
import br.com.sixsided.spindulum.entities.Explosion;
import br.com.sixsided.spindulum.entities.InitCounter;
import br.com.sixsided.spindulum.entities.Player;
import br.com.sixsided.spindulum.entities.Projectile;
import br.com.sixsided.spindulum.Main;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * SIXSIDED :: [SX] Spindulum :: Screen :: Game
 * ============================================================
 * 
 * This is the main game screen.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.0.0
 * @copy       ®2015 SIXSIDED Developments
 */
class ScreenGame extends Sprite 
{
    /**
     * Font name to be used in the fields.
     */
    public var textFont:String;
    
    /**
     * Input buttons array.
     */
    public var inputs:Array<Bool>;
    
    /**
     * Init counter handle.
     */
    public var gameInit:InitCounter;
    
    /**
     * Player object handle.
     */
    public var gamePlayer:Player;
    
    /**
     * Explosion object handler.
     */
    public var gameExplosion:Explosion;
    
    /**
     * Time in this round.
     */
    public var time:Int;
    
    /**
     * Time handler.
     */
    public var timeText:TextField;
    
    /**
     * Handles the "level" text.
     */
    public var textLevelA:TextField;
    
    /**
     * Handles the "level number" text.
     */
    public var textLevelB:TextField;
    
    /**
     * Indicates that the game is over.
     */
    public var gameIsOver:Bool = false;
    
    /**
     * If the player is dead or not.
     */
    public var playerIsDead:Bool = false;
    
    /**
     * Defines that the round has ended.
     */
    public var roundHasEnded:Bool = false;
    
    /**
     * Is finished trigger, for roundHasEnded and gameIsOver.
     */
    public var isFinished:Bool = false;
    
    /**
     * Projectile array.
     */
    public var projectileList:Array<Projectile>;
    
    /**
     * Projectile count.
     */
    public var projectileCounter:Int = 0;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Initialize inputs array
        inputs = new Array();
        
        // Initialize projectile array
        projectileList = new Array();
        
        // Determines font name
        textFont = ( null != Main.gameFont && null != Main.gameFont.fontName ) 
                 ? Main.gameFont.fontName 
                 : "_sans";
        
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
        trace( 'Game Started!' );
        
        // Initializes the counter
        gameInit = new InitCounter();
        
        // Centers gameInit
        gameInit.x = Main.gameScreenW / 2;
        gameInit.y = Main.gameScreenH / 2;
        
        // Adds to stage
        addChild( gameInit );
        
        // Adds event listener for the gameInit
        addEventListener( Event.ENTER_FRAME, gameInitEvents );
    }
    
    /**
     * Handles the events before the match starts.
     * 
     * @param e 
     *      Event handler
     */
    public function gameInitEvents( e:Event ):Void 
    {
        // If the gameInit object covers the screen
        if ( gameInit.isCovering ) {
            trace( 'Covering' );
            
            // Redefines gameInit covering
            gameInit.isCovering = false;
            
            // Initializes game objects
            initializeGameObjects();
        }
        
        // If the gameInit object is finished
        if ( gameInit.isFinished ) {
            // Remove this event listener
            removeEventListener( Event.ENTER_FRAME, gameInitEvents );
            
            // Initializes ended
            trace( 'Ended' );
            
            // Adds the game running events
            addEventListener( Event.ENTER_FRAME, gamePlayEvents );
            
            // Also adds the key up/down events
            stage.addEventListener( KeyboardEvent.KEY_DOWN, keysDn );
            stage.addEventListener( KeyboardEvent.KEY_UP, keysUp );
        }
    }
    
    /**
     * Handles the main game loop.
     * 
     * @param e
     */
    public function gamePlayEvents( e:Event ):Void 
    {
        // Checks if player size is good to explode
        if ( gamePlayer.playerBody.width >= gamePlayer.playerMark.width ) {
            // Defines that the round is over
            roundHasEnded = true;
        } else if ( gamePlayer.playerBody.width < gamePlayer.playerMins.width / 2 ) {
            // Defines that the round is over AND the player is dead
            gameIsOver = true;
            playerIsDead = true;
            roundHasEnded = true;
        }
        
        // Rotates
        if ( inputs[37] && !inputs[39] ) {
            // Rotates left
            if ( gamePlayer.velocity > 0 ) {
                gamePlayer.velocity -= 1;
            } else if ( gamePlayer.velocity > -10 ) {
                gamePlayer.velocity -= 1;
            }
        } else if ( inputs[39] && !inputs[37] ) {
            // Rotates right
            if ( gamePlayer.velocity < 0 ) {
                gamePlayer.velocity += 1;
            } else if ( gamePlayer.velocity < 10 ) {
                gamePlayer.velocity += 1;
            }
        } else if ( !inputs[37] && !inputs[39] ) {
            // Deaccelerates player
            if ( gamePlayer.velocity > 0 ) {
                gamePlayer.velocity -= 1;
            } else if ( gamePlayer.velocity < 0 ) {
                gamePlayer.velocity += 1;
            }
        }
        
        // Rotating
        if ( gamePlayer.velocity != 0 ) {
            gamePlayer.rotation += gamePlayer.velocity;
        }
        
        // Generating mobs
        if ( projectileCounter < 16 ) { 
            // Check for random number
            var rand:Int = Main.randomNumber( 0, 512 );
            
            // Generate
            var generate:Bool = false;
            
            // Color handle
            var colour:Int = 0x000000;
            
            // Boolean handle
            var isEnemy:Bool = false;
            
            if ( ( rand % 16 ) == 0 ) {
                // Define color
                colour = 0x204a85;
                // Defines if is enemy or not
                isEnemy = true;
            } else if ( ( rand % 12 ) == 0 ) {
                colour = 0xce5c00;
                // Defines if is enemy or not
                isEnemy = false;
            }
            
            if ( colour > 0 ) {
                // Generate mob
                var projectile:Projectile = new Projectile( colour );
                
                // Defines if it's a mob
                projectile.bulletIsEnemy = isEnemy;
                
                // Top, right, bottom or left
                var posX:Int = Main.randomNumber( 0, 3 );
                
                // Positioning
                switch ( posX ) {
                    case 1:
                        // Right
                        projectile.x = Main.gameScreenW + 64;
                        projectile.y = Main.randomNumber( -64, Main.gameScreenH + 64 );
                    case 2:
                        // Bottom
                        projectile.x = Main.randomNumber( -64, Main.gameScreenW + 64 );
                        projectile.y = Main.gameScreenH + 64;
                    case 3: 
                        // Left
                        projectile.x = - 64;
                        projectile.y = Main.randomNumber( -64, Main.gameScreenH + 64 );
                    default:
                        // Top
                        projectile.x = Main.randomNumber( -64, Main.gameScreenW + 64 );
                        projectile.y = - 64;
                }
                
                // Defining rotation, according to center of the stage
                var angles:Float = Main.pointsToAngles(
                    projectile.x, 
                    projectile.y, 
                    Main.gameScreenW / 2, 
                    Main.gameScreenH / 2
                );
                projectile.rotation = angles;
                
                // Define projectile speed
                projectile.bulletVelocity = 3 + ( Main.levelCurrent * 1 );
                
                // Pushing into array
                projectileList.push( projectile );
                
                // Increasing counter
                projectileCounter += 1;
                
                // Add to stage
                addChild( projectile );
            }
        }
        
        // Moving projectiles
        for ( i in 0...projectileList.length ) {
            if ( projectileList[i] != null ) {
                // Descobrindo novo ponto para movimentação
                var move:Point;
                
                // Rotação
                var bulrot:Float;
                
                // Velocidade
                var bulspd:Int;
                
                // Posição
                var xPos:Float = projectileList[i].x;
                var yPos:Float = projectileList[i].y;
                
                #if flash
                    bulrot = projectileList[i].rotation;
                    bulspd = projectileList[i].bulletVelocity;
                #else
                    bulrot = cast( projectileList[i], Projectile ).rotation;
                    bulspd = cast( projectileList[i], Projectile ).bulletVelocity;
                #end
                
                // Define ponto
                move = Main.vertexFinder(
                    bulrot, 
                    bulspd, 
                    xPos, 
                    yPos
                );
                
                // Moves
                projectileList[i].x = move.x;
                projectileList[i].y = move.y;
                
                if ( projectileList[i].bulletIsIn ) {
                    if (
                        projectileList[i].x > Main.gameScreenW + 64 
                        || projectileList[i].y > Main.gameScreenH + 64 
                        || projectileList[i].x < -64 
                        || projectileList[i].y < -64
                    ) {
                        // Remove this child from stage
                        removeChild( projectileList[i] );
                        
                        // Define as null 
                        projectileList[i] = null;
                    } else {
                        // Checking collision
                        if ( 
                            projectileList[i].bulletBody.hitTestObject(
                                gamePlayer.pickerHitbox
                            )
                        ) {
                            // If it hits
                            if ( projectileList[i].bulletIsEnemy ) {
                                // Plays SFX
                                Main.sfxBlue.play( 0, 0, new SoundTransform( 0.50 ) );
                                
                                // Check round has ended
                                if ( roundHasEnded ) roundHasEnded = false;
                                
                                // Animates
                                #if flash
                                    Actuate.tween(
                                        gamePlayer.playerBody, 
                                        .25, 
                                        {
                                            width: gamePlayer.playerBody.width * 0.75, 
                                            height: gamePlayer.playerBody.height * 0.75
                                        }
                                    );
                                #else
                                    Actuate.tween(
                                        cast( gamePlayer, Player ).playerBody , 
                                        .25, 
                                        {
                                            width: cast( gamePlayer, Player ).playerBody.width * 0.75, 
                                            height: cast( gamePlayer, Player ).playerBody.height * 0.75
                                        }
                                    );
                                #end
                            } else {
                                // Plays SFX
                                Main.sfxOrange.play( 0, 0, new SoundTransform( 0.50 ) );
                                
                                // Animates
                                #if flash
                                    Actuate.tween(
                                        gamePlayer.playerBody, 
                                        .25, 
                                        {
                                            width: gamePlayer.playerBody.width * 1.25, 
                                            height: gamePlayer.playerBody.height * 1.25
                                        }
                                    );
                                #else
                                    Actuate.tween(
                                        cast( gamePlayer, Player ).playerBody , 
                                        .25, 
                                        {
                                            width: cast( gamePlayer, Player ).playerBody.width * 1.25, 
                                            height: cast( gamePlayer, Player ).playerBody.height * 1.25
                                        }
                                    );
                                #end
                            }
                            
                            removeChild( projectileList[i] );
                            projectileList[i] = null;
                        }
                    }
                } else {
                    if ( projectileList[i].bulletIsIn == false ) {
                        if (
                            projectileList[i].x < Main.gameScreenW - 32 
                            || projectileList[i].y < Main.gameScreenH -32 
                            || projectileList[i].x > 32 
                            || projectileList[i].y > 32
                        ) {
                            projectileList[i].bulletIsIn = true;
                        }
                    }
                }
            } else {
                // Generate new projectile
                var rand:Int = Main.randomNumber( 0, 512 );
                
                // Generate
                var generate:Bool = false;
                
                // Color handle
                var colour:Int = 0x000000;
                
                // Boolean handle
                var isEnemy:Bool = false;
                
                if ( ( rand % 16 ) == 0 ) {
                    // Define color
                    colour = 0x204a85;
                    // Defines if is enemy or not
                    isEnemy = true;
                } else if ( ( rand % 12 ) == 0 ) {
                    colour = 0xce5c00;
                    // Defines if is enemy or not
                    isEnemy = false;
                }
                
                if ( colour > 0 ) {
                    // Generate mob
                    var projectile:Projectile = new Projectile( colour );
                    
                    // Defines if it's a mob
                    projectile.bulletIsEnemy = isEnemy;
                    
                    // Top, right, bottom or left
                    var posX:Int = Main.randomNumber( 0, 3 );
                    
                    // Positioning
                    switch ( posX ) {
                        case 1:
                            // Right
                            projectile.x = Main.gameScreenW + 64;
                            projectile.y = Main.randomNumber( -64, Main.gameScreenH + 64 );
                        case 2:
                            // Bottom
                            projectile.x = Main.randomNumber( -64, Main.gameScreenW + 64 );
                            projectile.y = Main.gameScreenH + 64;
                        case 3: 
                            // Left
                            projectile.x = - 64;
                            projectile.y = Main.randomNumber( -64, Main.gameScreenH + 64 );
                        default:
                            // Top
                            projectile.x = Main.randomNumber( -64, Main.gameScreenW + 64 );
                            projectile.y = - 64;
                    }
                    
                    // Defining rotation, according to center of the stage
                    var angles:Float = Main.pointsToAngles(
                        projectile.x, 
                        projectile.y, 
                        Main.gameScreenW / 2, 
                        Main.gameScreenH / 2
                    );
                    projectile.rotation = angles;
                    
                    // Define projectile speed
                    projectile.bulletVelocity = 3 + ( Main.levelCurrent * 1 );
                    
                    // Pushing into array
                    projectileList[i] = projectile;
                    
                    // Add to stage
                    addChild( projectile );
                }
            }
        }
        
        // Checks player rotation
        if ( !gameIsOver && !roundHasEnded ) {
            // Just some debug size increase
            #if debug
                if ( inputs[32] ) {
                    Actuate.tween(
                        gamePlayer.playerBody, 
                        .5, 
                        {
                            width: gamePlayer.playerBody.width * 1.15, 
                            height: gamePlayer.playerBody.height * 1.15
                        }
                    );
                }
                
                if ( inputs[16] ) {
                    Actuate.tween(
                        gamePlayer.playerBody, 
                        .5, 
                        {
                            width: gamePlayer.playerBody.width * 0.85, 
                            height: gamePlayer.playerBody.height * 0.85
                        }
                    );
                }
            #end
        } else {
            // Check if round has ended
            if ( gameIsOver && playerIsDead ) {
                // Initializes game explosion
                gameExplosion = new Explosion( 32 );
                
                // Adds to stage
                addChild( gameExplosion );
                
                // Centers explosion
                gameExplosion.x = Main.gameScreenW / 2;
                gameExplosion.y = Main.gameScreenH / 2;
        
                // Play title
                Main.soundGameOver.play();
                    
                // Removes this event listener
                removeEventListener( Event.ENTER_FRAME, gamePlayEvents );
                
                // Removes all keyboard events
                stage.removeEventListener( KeyboardEvent.KEY_DOWN, keysDn );
                stage.removeEventListener( KeyboardEvent.KEY_UP, keysUp );
                
                // Adds the event finisher
                addEventListener( Event.ENTER_FRAME, gameFinishEvents );
            } else {
                if ( inputs[37] && inputs[39] && roundHasEnded ) {
                    // Initializes game explosion
                    gameExplosion = new Explosion( 128 );
                    
                    // Adds explosion to the stage
                    addChild( gameExplosion );
                        
                    // Centers explosion
                    gameExplosion.x = Main.gameScreenW / 2;
                    gameExplosion.y = Main.gameScreenH / 2;
        
                    if ( Main.levelCurrent >= 9 ) {        
                        // Play title
                        Main.soundGameOver.play();
                    } else {
                        // Play title
                        Main.soundNext.play();
                    }
                    
                    // Removes this event listener
                    removeEventListener( Event.ENTER_FRAME, gamePlayEvents );
                    
                    // Removes all keyboard events
                    stage.removeEventListener( KeyboardEvent.KEY_DOWN, keysDn );
                    stage.removeEventListener( KeyboardEvent.KEY_UP, keysUp );
                    
                    // Adds the event finisher
                    addEventListener( Event.ENTER_FRAME, gameFinishEvents );
                }
            }
        }
    }
    
    /**
     * Moves a mob.
     * 
     * @param e
     *      Event target handle
     */
    public function mobsMove( e:Event ):Void 
    {
        // Check if the mob already entered the arena
        if ( e.currentTarget.bulletIsIn ) {
            if ( 
                e.currentTarget.x > Main.gameScreenW + 32 
                || e.currentTarget.x < -32 
                || e.currentTarget.y > Main.gameScreenH + 32
                || e.currentTarget.y < -32 
            ) {
                // Removes this event listener
                e.currentTarget.removeEventListener( Event.ENTER_FRAME, mobsMove );
                
                // Remove this item from stage
                removeChild( e.currentTarget );
            }
        } else {
            // Descobrindo novo ponto para movimentação
            var move:Point;
            
            // Rotação
            var bulrot:Float;
            
            // Velocidade
            var bulspd:Int;
            
            // Posição
            var xPos:Float = e.currentTarget.x;
            var yPos:Float = e.currentTarget.y;
            
            #if flash
                bulrot = e.currentTarget.rotation;
                bulspd = e.currentTarget.bulletVelocity;
            #else
                bulrot = cast( e.currentTarget, Projectile ).rotation;
                bulspd = cast( e.currentTarget, Projectile ).bulletVelocity;
            #end
            
            trace( bulrot );
            trace( bulspd );
            
            // Define ponto
            move = Main.vertexFinder(
                bulrot, 
                bulspd, 
                xPos, 
                yPos
            );
            
            // Movimenta
            e.currentTarget.x = move.x;
            e.currentTarget.y = move.y;
        }
    }
    
    /**
     * Game/round finish event.
     * 
     * @param e
     *      Event handle
     */
    public function gameFinishEvents( e:Event ):Void 
    {
        // Checking for the right time to delete everything
        if ( gameExplosion.isCovering ) {
            // Removes Player
            removeChild( gamePlayer );
            
            // Removes counters
            removeChild( textLevelA );
            removeChild( textLevelB );
            
            // Removes all projectiles
            for ( i in 0...projectileList.length ) {
                if ( projectileList[i] != null ) {
                    // Removes
                    removeChild( projectileList[i] );
                    
                    // Set as null
                    projectileList[i] = null;
                }
            }
            
            // Resets isCovering
            gameExplosion.isCovering = false;
        }
        
        // If is finished
        if ( gameExplosion.isFinished ) {
            // Removes gameExplosion
            removeChild( gameExplosion );
            
            // Sets this as finished
            isFinished = true;
            
            // Remove this event listener
            removeEventListener( Event.ENTER_FRAME, gameFinishEvents );
        }
    }
    
    /**
     * Key pressed event.
     * 
     * @param e
     *      KeyboardEvent handle
     */
    public function keysDn( e:KeyboardEvent ):Void 
    {
        // If this key isn't pressed
        if ( !inputs[e.keyCode] ) {
            // Define as pressed
            inputs[e.keyCode] = true;
        }
    }
    
    /**
     * Key lifted event.
     * 
     * @param e
     *      KeyboardEvent handle
     */
    public function keysUp( e:KeyboardEvent ):Void 
    {
        // If this key is pressed
        if ( inputs[e.keyCode] ) {
            // Define as unpressed
            inputs[e.keyCode] = false;
        }
    }
    
    /**
     * Initializes all game objects.
     */
    public function initializeGameObjects():Void 
    {
        // Defines the level's radius
        var currentRadius:Int = Math.floor(
            128 * ( 1 + ( Main.levelCurrent * 0.15 ) )
        );
        
        // Initializes the player object
        gamePlayer = new Player( currentRadius );
        
        // Placing player
        gamePlayer.x = Main.gameScreenW / 2;
        gamePlayer.y = Main.gameScreenH / 2;
        
        // Adds child to the stage and, quickly, switches the layer
        addChild( gamePlayer );
        swapChildren( gamePlayer, gameInit );
        
        // Add the game's counters
        textLevelA = new TextField();
        textLevelA.defaultTextFormat = new TextFormat(
            textFont, 
            24, 
            0x000000, 
            false, 
            false, 
            false
        );
        textLevelA.text = "LEVEL";
        textLevelA.autoSize = TextFieldAutoSize.CENTER;
        textLevelA.antiAliasType = AntiAliasType.ADVANCED;
        textLevelA.type = TextFieldType.DYNAMIC;
        textLevelA.multiline = false;
        textLevelA.selectable = false;
        textLevelA.x = 64 - ( textLevelA.width / 2 );
        textLevelA.y = Main.gameScreenH - 116;
        textLevelA.alpha = .5;
        
        // Adds child to the stage and, quickly, switches the layer
        addChild( textLevelA );
        swapChildren( textLevelA, gameInit );
        
        textLevelB = new TextField();
        textLevelB.defaultTextFormat = new TextFormat(
            textFont, 
            56, 
            0x000000, 
            false, 
            false, 
            false
        );
        textLevelB.text = ( Main.levelCurrent < 9 ) 
                        ? "0" + ( Main.levelCurrent + 1 )
                        : Std.string( Main.levelCurrent + 1 );
        textLevelB.autoSize = TextFieldAutoSize.CENTER;
        textLevelB.antiAliasType = AntiAliasType.ADVANCED;
        textLevelB.type = TextFieldType.DYNAMIC;
        textLevelB.multiline = false;
        textLevelB.selectable = false;
        textLevelB.x = 64 - ( textLevelB.width / 2 );
        #if flash 
            textLevelB.y = Main.gameScreenH - 96;
        #else 
            textLevelB.y = Main.gameScreenH - 80;
        #end
        textLevelB.alpha = .5;
        
        // Adds child to the stage and, quickly, switches the layer
        addChild( textLevelB );
        swapChildren( textLevelB, gameInit );
    }
}