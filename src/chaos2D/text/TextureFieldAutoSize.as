package chaos2D.text 
{
	import chaos2D.error.AbstractClassError;
	/**
	 * ...
	 * @author Chao
	 */
	public class TextureFieldAutoSize 
	{
		
		public function TextureFieldAutoSize() 
		{
			throw new AbstractClassError();
		}
		
		public static const NONE:String = "none";
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		public static const BOTH_DIRECTIONS:String = "bothDirections";
		
	}

}