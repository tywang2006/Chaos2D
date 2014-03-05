package chaos2D.texture 
{
	import chaos2D.ChaosEngine;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Chao
	 */
	public class TextureCenter 
	{
		private var _assets:Dictionary;

		private static var _instance:TextureCenter;
		
		public function TextureCenter() 
		{
			_instance = this;
			_assets = new Dictionary();
		}
		
		public function addSpriteSheet(data:BitmapData, config:XML, mipMapping:Boolean = false):void
		{
			
		}
		
		public function addBitmapData(id:String, data:BitmapData, mipMapping:Boolean = false):BitmapTexture
		{
			if (_assets[id]) {
				throw "id has been taken for texture";
			}
			_assets[id] = ChaosEngine.context.createTexture(data, mipMapping);
			Texture(_assets[id]).uploadData();
			return _assets[id];
		}
		
		public function addBitmap(id:String, data:Bitmap, mipMapping:Boolean = false):BitmapTexture
		{
			if (_assets[id]) {
				throw "id has been taken for texture";
			}
			_assets[id] = ChaosEngine.context.createTexture(data, mipMapping);
			Texture(_assets[id]).uploadData();
			return _assets[id];
		}
		
		public function getTextureByID(id:String):Texture
		{
			return _assets[id];
		}
		
		public static function get instance():TextureCenter
		{
			if (!_instance) {
				new TextureCenter();
			}
			return _instance;
		}
		
	}

}