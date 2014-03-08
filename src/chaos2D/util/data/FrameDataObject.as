package chaos2D.util.data 
{
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	/**
	 * ...
	 * @author Chao
	 */
	public class FrameDataObject 
	{
		public var frameIndex:int;
		public var label:String;
		public var texture:BitmapTexture;
		
		public function FrameDataObject() 
		{
			frameIndex = -1;
			label = null;
			texture = null;
		}
		
	}

}