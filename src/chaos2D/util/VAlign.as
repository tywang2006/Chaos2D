package chaos2D.util 
{
	import chaos2D.error.AbstractClassError;
	/**
	 * ...
	 * @author Chao
	 */
	public final class VAlign
    {
        /** @private */
        public function VAlign() { throw new AbstractClassError(); }
        
        /** Top alignment. */
        public static const TOP:String    = "top";
        
        /** Centered alignment. */
        public static const CENTER:String = "center";
        
        /** Bottom alignment. */
        public static const BOTTOM:String = "bottom";
        
        /** Indicates whether the given alignment string is valid. */
        public static function isValid(vAlign:String):Boolean
        {
            return vAlign == TOP || vAlign == CENTER || vAlign == BOTTOM;
        }
    }

}