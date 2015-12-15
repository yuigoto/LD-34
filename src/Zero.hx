package;

// Importing packages
import openfl.geom.Point;

/**
 * SIXSIDED :: Zero
 * ============================================================
 * 
 * A collection of helper functions/methods for calculations, colors, 
 * pseudo-random numbers and stuff.
 * 
 * Not really a library, but just a bunch of code that I tend to use 
 * a LOT on my projects.
 * 
 * Part of this has been ported from my PHP::Zero helper class.
 * 
 * @author Fabio Yuiti Goto
 * @link http://www.sixsided.com.br
 * @version 1.0.0.0
 * @copy ®2015 SIXSIDED Developments
 */
class Zero
{
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Silence is golden
    }
    
    
    
    /* STRING AND NUMBER OPERATIONS
     * ============================================================ */
    
    /**
     * Converts a number, between 0 and 255, into its hexadecimal value.
     * 
     * @param number Unsigned integer, between 0 and 255
     */
    public static function dechex( number:UInt ):String 
    {
        // Verifying that number isn't bigger than 255
        if ( number > 255 ) number = 255;
        
        // Returning
        return StringTools.hex( number, 2 );
    }
    
    
    
    /* OPERATIONS WITH ARRAYS
     * ============================================================ */
    
    /**
     * Returns the index number of an item inside a two dimensional array, 
     * given its position and the width of the array.
     * 
     * Also helps find an index of a pixel, for its X and Y position, inside 
     * a pixel one dimensional array.
     * 
     * @param posX X position of the item in the array/cartesian plane (column)
     * @param posY Y position of the item in the array/cartesian plane (row)
     * @param width The width of the array/object (total columns)
     * @return
     */
    public static function arrayIndex2D( 
        posX:Int, 
        posY:Int, 
        width:Int 
    ):Int {
        return ( posY * width ) + posX;
    }
    
    /**
     * Returns the index number of an item inside a three dimensional array, 
     * given its position in the x, y and z axis, the total width and the total 
     * height of the array. The depth isn't necessary, as we have the z value.
     * 
     * @param posX
     * @param posY
     * @param posZ
     * @param width
     * @param height
     * @return
     */
    public static function arrayIndex3D(
        posX:Int, 
        posY:Int, 
        posZ:Int, 
        width:Int, 
        height:Int
    ):Int {
        // Returning index value.
        return ( posY * width * height ) + ( posX * width ) + posZ;
    }
    
    /**
     * Rotates an array by 90° clockwise, or counter-clockwise, if declared.
     * 
     * This is mostly an experimental and referential array, to be looked when 
     * building methods that require array rotation.
     * 
     * IMPORTANT: The array MUST have the same number of rows and columns.
     * 
     * @param arrs Two dimensional array
     * @param counterclockwise If TRUE, indicates counter-clockwise rotation
     * @return
     */
    public static function arrayRotate2D<T>(
        vars:Array<Array<T>>, 
        counterclockwise:Bool = false
    ):Array<Array<T>> {
        // Defines temporary return array
        var temp:Array<Array<T>> = new Array();
        
        // Checking direction value
        counterclockwise = ( true == counterclockwise ) ? true : false;
        
        // Rotating
        for ( y in 0...vars.length ) {
            // Turning row
            for ( x in 0...vars[y].length ) {
                // Temporary values
                var oldX:Int = x;
                var oldY:Int = y;
                var newX:Int;
                var newY:Int;
                
                // Defining values, according to direction
                if ( counterclockwise ) {
                    newX = oldY;
                    newY = ( x - ( vars[y].length - 1 ) ) * -1;
                } else {
                    newX = ( y - ( vars.length - 1 ) ) * -1;
                    newY = oldX;
                }
                
                // Creating new array for row, if it doesn't exist
                if ( null == temp[newY] ) {
                    temp[newY] = new Array();
                }
                
                // Define item in the return array
                temp[newY][newX] = vars[y][x];
            }
        }
        
        return temp;
    }
    
    /**
     * Flips a two dimensional array horizontally (default) or vertically.
     * 
     * This is mostly an experimental and referential array, to be looked when 
     * building methods that require array flipping.
     * 
     * @param vars Array to be flipped
     * @param vertical If TRUE, flipping is vertical, instead of horizontal
     * @return
     */
    public static function arrayFlip2D<T>(
        vars:Array<Array<T>>, 
        vertical:Bool = false
    ):Array<Array<T>> {
        // Defines temporary return array
        var temp:Array<Array<T>> = new Array();
        
        // Checking direction value
        vertical = ( true == vertical ) ? true : false;
        
        // Rotating
        for ( y in 0...vars.length ) {
            // Turning row
            for ( x in 0...vars[y].length ) {
                // Temporary values
                var oldX:Int = x;
                var oldY:Int = y;
                var newX:Int;
                var newY:Int;
                
                // Defining values, according to direction
                if ( vertical ) {
                    newX = oldX;
                    newY = ( y - ( vars.length - 1 ) ) * -1;
                } else {
                    newX = ( x - ( vars[y].length - 1 ) ) * -1;
                    newY = oldY;
                }
                
                // Creating new array for row, if it doesn't exist
                if ( null == temp[newY] ) {
                    temp[newY] = new Array();
                }
                
                // Define item in the return array
                temp[newY][newX] = vars[y][x];
            }
        }
        
        // Returning
        return temp;
    }
    
    
    
    /* MATHS
     * ============================================================ */
    
    /**
     * Callibrates an angle so that it stays within the -180° ~ 180° margin used 
     * by Haxe/AS3 rotation.
     * 
     * @param angle
     * @return
     */
    public static function callibrateRotation( angle:Float ):Float 
    {
        // Checks whether the angle is bigger or lower than the limit
        if ( angle > 180 ) {
            angle = -1 * ( 180 - ( angle - 180 ) );
        } else if ( angle < -180 ) {
            angle = 180 - ( angle + 180 );
        }
        
        // Returns angle
        return angle;
    }
    
    /**
     * Finds the second coordinate from a line, given the angle, distance and 
     * the coordinates of the first point.
     * 
     * @param angle Angle/rotation value
     * @param distance Length of the line
     * @param posX X position of the first point
     * @param posY Y position of the first point
     * @return
     */
    public static function vertexFinder(
        angle:Float, 
        distance:Float, 
        posX:Float, 
        posY:Float
    ):Point {
        // Radian
        var radian:Float = Math.PI / 180;
        
        // Returning point
        return new Point(
            posX + ( distance * Math.cos( angle * radian ) ), 
            posY + ( distance * Math.sin( angle * radian ) ) 
        );
    }
    
    /**
     * Defines the third vertex of a triangle, given the position of the first 
     * two vertex and the angle of the line between this third vertex and the 
     * first one.
     * 
     * The method was tailored, specifically, to target equilateral triangles, 
     * so use it with care and keep an eye on the output.
     * 
     * Also, remember that the angle variable is relative to the angle between 
     * point1/point2 and point1/point3 (the angle is in the first vertex).
     * 
     * IMPORTANT: Sometimes you may need to calibrate the angle for this method 
     * to work properly.
     * 
     * @param angle Angle/rotation value, relative to the first vertex
     * @param posX1 X position of the first vertex
     * @param posY1 Y position of the first vertex
     * @param posX2 X position of the second vertex
     * @param posY2 Y position of the second vertex
     * @return
     */
    public static function vertexDefine(
        angle:Float, 
        posX1:Float, 
        posY1:Float, 
        posX2:Float, 
        posY2:Float
    ):Point {
        // Calculates distance between points
        var distance:Float = Math.sqrt(
            Math.pow( posX2 - posX1, 2 ) + Math.pow( posY2 - posY1, 2 )
        );
        
        // Returning third vertex of the triangle, relative to the FIRST vertex
        return vertexFinder( angle, distance, posX1, posY1 );
    }
    
    
    
    /* COLOR CONVERSION
     * ============================================================ */
    
    /**
     * Converts a color, in HSV format to a RGB integer, ready for use.
     * 
     * @param h Hue, float number between 0 and 360
     * @param s Saturation, float number between 0 and 1
     * @param v Value/Brightness, float number between 0 and 1
     * @return
     */
    public static function HSVRGB( h:Float, s:Float, v:Float ):Int 
    {
        // Pre-declaring variables
        var r, g, b, i, f, p, q, t;
        
        // When saturation is equal to 0, returns grayscale
        if ( 0 == s ) {
            // Defining shade
            var gray = StringTools.hex( Math.floor( v * 255 ) );
            
            // Returning
            return Std.parseInt( "0x" + gray + gray + gray );
        }
        
        // Defining colour variables
        i = Math.floor( h * 6 );
        f = h * 6 - i;
        p = v * ( 1 - s );
        q = v * ( 1 - f * s );
        t = v * ( 1 * ( 1 - f ) * s );
        
        // Defining final rgb values, according to a module
        switch ( i % 6 ) {
            case 1: 
                r = q;
                g = v;
                b = p;
            case 2: 
                r = p;
                g = v;
                b = t;
            case 3: 
                r = p;
                g = q;
                b = v;
            case 4: 
                r = t;
                g = p;
                b = v;
            case 5: 
                r = v;
                g = p;
                b = q;
            default: 
                r = v;
                g = t;
                b = p;
        }
        
        // Returning final value
        return Std.parseInt(
            "0x" 
            + StringTools.hex( Math.floor( r * 255 ) ) 
            + StringTools.hex( Math.floor( g * 255 ) ) 
            + StringTools.hex( Math.floor( b * 255 ) ) 
        );
    }
    
    
    
    /* DYNAMIC LAYER SWAPPING
     * ============================================================ */
    
    /**
     * Swaps children's index value for a display object, be it stage or another 
     * container, according to the y values of each object, useful for top-down 
     * 2.5d sprites.
     * 
     * Accepts a function/method that receives the display objects being compared, 
     * while changing depth, and does something to the display objects (tests 
     * for collision, push/pull, obstacles, jumping, etc.).
     * 
     * @param c Must be a display object that accepts children
     * @param callback Method/function that compares object types.
     */
    public static function layersSwapping<T> (
        c:Dynamic, 
        callback:Dynamic->Dynamic->Void = null 
    ):Void {
        // Executes, only, if numChildren is bigger than 1
        if ( c.numChildren > 1 ) {
            // First iteration
            for ( i in 0...c.numChildren ) {
                // Second iteration
                for ( j in 0...c.numChildren ) {
                    // Temporary children handlers
                    var a:Dynamic = c.getChildAt( i );
                    var b:Dynamic = c.getChildAt( j );
                    
                    // Declaring values for comparison
                    var pos:Bool = ( a.y > b.y );
                    var idx:Bool = ( c.getChildIndex( a ) > c.getChildIndex( b ) );
                    
                    // Comparing y position
                    if ( pos != idx ) {
                        // Swapping indexes
                        c.swapChildren( a, b );
                    }
                    
                    // Applying callback
                    if ( null != callback ) {
                        callback( a, b );
                    }
                }
            }
        } else {
            // Debug
            trace( 'No children to test for collision.' );
        }
    }
    
    
    
    /* RANDOMIZERS
     * ============================================================ */
    
    /**
     * Returns a random color value.
     * 
     * @return
     */
    public static function randomColour():Int 
    {
        // Base RGB values
        var r:Int = randomNumber( 0, 255 );
        var g:Int = randomNumber( 0, 255 );
        var b:Int = randomNumber( 0, 255 );
        
        // Building webcolor
        var v:String = "0x" 
                     + StringTools.hex( r, 2 ) 
                     + StringTools.hex( g, 2 ) 
                     + StringTools.hex( b, 2 );
        
        // Returning value
        return Std.parseInt( v );
    }
    
    /**
     * Returns a random color, the simple way.
     * 
     * @return
     */
    public static function randomColourSimple():Int 
    {
        // Using "ceil", to try to avoid black
        return Math.ceil( Math.random() * 0xffffff );
    }
    
    /**
     * Returns a pseudo-random number between min and max.
     * 
     * @param min Default value: 0
     * @param max Default value: 2147483647
     * @return
     */
    public static function randomNumber( min:Int = 0, max:Int = 2147483647 ):Int 
    {
        return Math.floor( Math.random() * ( max - min + 1 ) ) + min;
    }
    
    /**
     * Generates a pseuda-random seed number, to be used on bitwise operations.
     * 
     * Used, mostly, by PxShip's sprite generator.
     */
    public static function randomSeed():Int 
    {
        // Generates a large random seed
        return Math.floor( Math.random() * 4 * 1024 * 1024 * 1024 );
    }
}