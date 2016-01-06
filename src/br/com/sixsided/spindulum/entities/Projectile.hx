package br.com.sixsided.spindulum.entities;

// Importing packages
import openfl.display.GradientType;
import openfl.display.SpreadMethod;
import openfl.display.Sprite;
import openfl.geom.Matrix;

/**
 * SIXSIDED :: [SX] Spindulum :: Projectile
 * ============================================================
 * 
 * Explosion object, serves as the transition between levels and game 
 * over too.
 * 
 * @author     Fabio Yuiti Goto
 * @link       http://sixsided.com.br
 * @version    1.2.0
 * @copy       ®2015 SIXSIDED Developments
 */
class Projectile extends Sprite 
{
    /**
     * Handle for the projectile's body.
     */
    public var bulletBody:Sprite;
    
    /**
     * Handle for the projectile's trail.
     */
    public var bulletTail:Sprite;
    
    /**
     * Handle for the projectile's speed.
     */
    public var bulletVelocity:Int;
    
    /**
     * Bullet color.
     */
    public var bulletColour:Int;
    
    /**
     * Defines if the bullet is an enemy.
     */
    public var bulletIsEnemy:Bool = false;
    
    /**
     * Defines if the bullet is an enemy.
     */
    public var bulletIsIn:Bool = false;
    
    /**
     * Main constructor.
     */
    public function new( colour:Int = 0x204a85 ) 
    {
        // Calling super constructor
        super();
        
        // Defining color
        bulletColour = colour;
        
        // Drawing an "invisible" bounding box
        graphics.beginFill( bulletColour, 0 );
        graphics.drawCircle( 0, 0, 64 );
        
        #if !debug
            // Drawing the gradient first
            bulletTail = new Sprite();
            
            // Matrix for drawing
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox( 64, 16, 0, -48, -6 );
            
            // Gradient fill
            bulletTail.graphics.beginGradientFill(
                // Gradient type
                GradientType.LINEAR, 
                // Colors array
                [ bulletColour, bulletColour ], 
                // Alphas array
                [ 0, 25 ], 
                // Ratios array
                [ 0, 225 ], 
                matrix, 
                SpreadMethod.PAD
            );
            bulletTail.graphics.drawRect(
                -64, 
                -8, 
                64, 
                16
            );
            bulletTail.graphics.endFill();
            bulletTail.alpha = .50;
            
            // Add tail to screen
            addChild( bulletTail );
        #end
        
        // Drawing the body
        bulletBody = new Sprite();
        bulletBody.graphics.beginFill( bulletColour, 1 );
        bulletBody.graphics.drawCircle( 0, 0, 8 );
        bulletBody.graphics.endFill();
        
        // Add body to screen
        addChild( bulletBody );
    }
}