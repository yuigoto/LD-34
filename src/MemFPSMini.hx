package;

// Importando pacotes
import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.system.System;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * SIXSIDED :: MemFPS 
 * ============================================================
 * 
 * A simple FPS and memory use monitor, based on the "FPS_Mem" class, written 
 * by Kirill Poletaev in the article "Displaying FPS and Memory usage using 
 * OpenFL".
 * 
 * More info: http://haxecoder.com/post.php?id=24
 * 
 * @author Fabio Yuiti Goto
 * @link http://www.sixsided.com.br
 * @version 0.1.0.0
 * @copy ®2015 SIXSIDED Developments
 */
class MemFPSMini extends Sprite 
{
    /**
     * Fonte para ser utilizada no monitor.
     */
    private var FONT:Font = null;
    
    /**
     * Textfield para exibição de dados.
     */
    private var FIELDS:TextField;
    
    /**
     * Formatação para o campo.
     */
    private var FORMAT:TextFormat;
    
    /**
     * Conta quantas vezes o frame foi exibido no último segundo.
     */
    private var FRAMES:Array<Float>;
    
    /**
     * Indica o pico de memória utilizada na sessão.
     */
    private var MEMORY:Float = 0;
    
    /**
     * Construtor principal.
     */
	public function new(
        font:Font = null
    ) {
        // Chamando super construtor
		super();
        
        // Definindo fonte
        if ( null != font ) {
            FONT = font;
        }
        
        // Inicializando frames
        FRAMES = [];
        
        // Certificando-se que stage foi inicializado
        if ( null != stage ) {
            // Se stage tiver sido inicializado, executa método principal
            init( null );
        } else {
            // Adiciona init como event listener, para inicializar stage
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
	}
    
    /**
     * Método principal.
     * 
     * @param e Event
     */
    private function init( e:Event ):Void 
    {
        // Remove este event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Desenha fundo
        drawBack();
        
        // Define fonte
        #if html5
            var usedFont = "_sans";
        #else
            var usedFont = ( null != FONT ) ? FONT.fontName : "_sans";
        #end
        
        // Inicializa textfield
        FIELDS = new TextField();
        
        // Inicializando textformat
        FORMAT = new TextFormat(
            usedFont, 
            10, 
            0xffffff
        );
        
        // Define texto e outros ítens
        FIELDS.defaultTextFormat = FORMAT;
        FIELDS.selectable = false;
        FIELDS.multiline = true;
        FIELDS.text = "FPS: ";
        FIELDS.x = 10;
        FIELDS.y = 10;
        
        // Adiciona ao stage
        addChild( FIELDS );
        
        // Adiciona event listener
        addEventListener( Event.ENTER_FRAME, frames );
    }
    
    /**
     * Monitora o FPS e uso de memória utilizando cálculos matemáticos.
     */
    private function frames( e:Event ):Void 
    {
        // Adiciona timestamp atual
        var time = Timer.stamp();
        
        // Adiciona ao array
        FRAMES.push( time );
        
        // Removendo primeiro elemento do array
        while ( FRAMES[0] < time - 1 ) {
            FRAMES.shift();
        }
        
        // Contando uso de memória, em megabytes
        var mems:Float = Math.round( System.totalMemory / 1024 / 1024 * 100 ) / 100;
        
        // Comparando ao pico
        if ( mems > MEMORY ) {
            MEMORY = mems;
        }
        
        // Atualizando dados
        FIELDS.text = "FPS: " + FRAMES.length + "\nMEM: " + mems + "\nPEAK: " + MEMORY;
    }
    
    /**
     * Desenha o fundo para o monitor.
     */
    private function drawBack():Void 
    {
        // Fundo com alpha
        graphics.beginFill( 0x2c2825, .75 );
        graphics.drawRect( 0, 0, 100, 60 );
        graphics.endFill();
    }
}
