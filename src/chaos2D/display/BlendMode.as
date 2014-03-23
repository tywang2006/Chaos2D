package chaos2D.display 
{
	import chaos2D.error.AbstractClassError;
	import flash.display3D.Context3DBlendFactor;
	/**
	 * ...
	 * @author Chao
	 */
	public class BlendMode
	{
		private static var sBlendFactors:Array = [ 
            // no premultiplied alpha
            { 
                "none"     : [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
                "normal"   : [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "add"      : [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ],
                "multiply" : [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "screen"   : [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE ],
                "erase"    : [ Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "below"    : [ Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ]
            },
            // premultiplied alpha
            { 
                "none"     : [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
                "normal"   : [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "add"      : [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE ],
                "multiply" : [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "screen"   : [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR ],
                "erase"    : [ Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
                "below"    : [ Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ]
            }
        ];
        

        /** @private */
        public function BlendMode() { throw new AbstractClassError(); }
        
        /** Inherits the blend mode from this display object's parent. */
        public static const AUTO:String = "auto";

        /** Deactivates blending, i.e. disabling any transparency. */
        public static const NONE:String = "none";
        
        /** The display object appears in front of the background. */
        public static const NORMAL:String = "normal";
        
        /** Adds the values of the colors of the display object to the colors of its background. */
        public static const ADD:String = "add";
        
        /** Multiplies the values of the display object colors with the the background color. */
        public static const MULTIPLY:String = "multiply";
        
        /** Multiplies the complement (inverse) of the display object color with the complement of 
          * the background color, resulting in a bleaching effect. */
        public static const SCREEN:String = "screen";
        
        /** Erases the background when drawn on a RenderTexture. */
        public static const ERASE:String = "erase";
        
		/** Draws under/below existing objects; useful especially on RenderTextures. */
	    public static const BELOW:String = "below";

        // accessing modes
        public static function getBlendFactors(mode:String, premultipliedAlpha:Boolean=true):Array
        {
            var modes:Object = sBlendFactors[int(premultipliedAlpha)];
            if (mode in modes) return modes[mode];
            else throw new ArgumentError("Invalid blend mode");
        }
        
        public static function register(name:String, sourceFactor:String, destFactor:String,
                                        premultipliedAlpha:Boolean=true):void
        {
            var modes:Object = sBlendFactors[int(premultipliedAlpha)];
            modes[name] = [sourceFactor, destFactor];
            
            var otherModes:Object = sBlendFactors[int(!premultipliedAlpha)];
            if (!(name in otherModes)) otherModes[name] = [sourceFactor, destFactor];
        }
    
	}

}