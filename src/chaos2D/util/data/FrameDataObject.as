package chaos2D.util.data 
{
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import flash.display.BitmapData;
	import flash.display3D.VertexBuffer3D;
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
		public var rawWidth:Number;
		public var rawHeight:Number;
		public var linkage:String;
		public var bitmapData:BitmapData;
		public var fit:Object;
		public var uv:Vector.<Number>;
		public var uvBuffer:VertexBuffer3D;
		public var spriteSheetDetail:Object;
		
		public function FrameDataObject() 
		{
			frameIndex = -1;
			label = null;
			texture = null;
			uv = new Vector.<Number>();
		}
		
	}

}