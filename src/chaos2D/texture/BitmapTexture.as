package chaos2D.texture 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import chaos2D.texture.Texture;
	import flash.display3D.Context3DTextureFormat;
	//import flash.display3D.textures.Texture;
	/**
	 * ...
	 * @author Chao
	 */
	public class BitmapTexture extends Texture 
	{
		private var _data:BitmapData;
		private var _mipMapping:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _base:*;
		
		public function BitmapTexture(base:*, data:*, mipMapping:Boolean) 
		{
			if (data is Bitmap)
			{
				_data = Bitmap(data).bitmapData;
			} else if (data is BitmapData) {
				_data = data as BitmapData;
			} else {
				throw ArgumentError("BitmapTexture: invalid bitmap data formate, It is only avoid for bitmap/bitmapData");
			}
			
			_base = base;
			_mipMapping = mipMapping;
			_width = _data.width;
			_height = _data.height;
			
		}
		
		override public function uploadData():void 
		{
			_base.uploadFromBitmapData(_data,0);
		}
		
		public function dispose():void
		{
			_base.dispose();
		}
		
		override public function get base():* { return _base; }
        override public function get format():String { return Context3DTextureFormat.BGRA; }
        override public function get width():Number { return _width; }
        override public function get height():Number { return _height; }
        override public function get mipMapping():Boolean { return _mipMapping; }
		
	}

}