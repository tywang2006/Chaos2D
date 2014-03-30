package chaos2D.util 
{
	import chaos2D.error.AbstractClassError;
	/**
	 * ...
	 * @author Chao
	 */
	public final class HAlign
    {
        /** @private */
        public function HAlign() { throw new AbstractClassError(); }
        
        /** Left alignment. */
        public static const LEFT:String   = "left";
        
        /** Centered alignement. */
        public static const CENTER:String = "center";
        
        /** Right alignment. */
        public static const RIGHT:String  = "right";
        
        /** Indicates whether the given alignment string is valid. */
        public static function isValid(hAlign:String):Boolean
        {
            return hAlign == LEFT || hAlign == CENTER || hAlign == RIGHT;
        }
    }

}