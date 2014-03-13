package chaos2D.util.data 
{
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Chao
	 */
	public class FrameDataObject 
	{
		public var frameIndex:int;
		public var label:String;
		public var texture:BitmapTexture;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var width:Number;
		public var height:Number;
		public var linkage:String;
		public var bitmapData:BitmapData;
		
		public function FrameDataObject() 
		{
			frameIndex = -1;
			label = null;
			texture = null;
		}
		
	}

}