package chaos2D.texture 
{
	import chaos2D.ChaosEngine;
	import chaos2D.util.getNextPowerOfTwo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
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
			data = updatePower2BitmapData(data);
			_assets[id] = ChaosEngine.context.createTexture(data, mipMapping);
			Texture(_assets[id]).uploadData();
			return _assets[id];
		}
		
		public function addBitmap(id:String, data:Bitmap, mipMapping:Boolean = false):BitmapTexture
		{
			if (_assets[id]) {
				throw "id has been taken for texture";
			}
			var bitmapData:BitmapData = updatePower2BitmapData(data.bitmapData);
			_assets[id] = ChaosEngine.context.createTexture(bitmapData, mipMapping);
			Texture(_assets[id]).uploadData();
			return _assets[id];
		}
		
		public function getTextureByID(id:String):Texture
		{
			return _assets[id];
		}
		
		public function setTextureByID(id:String, texture:Texture):void
		{
			if (_assets[id]) {
				trace(id + " has been overwriten");
			}
			_assets[id] = texture;
		}
		
		public static function get instance():TextureCenter
		{
			if (!_instance) {
				new TextureCenter();
			}
			return _instance;
		}
		
		public static function updatePower2BitmapData(data:BitmapData):BitmapData
		{
			var w:Number = getNextPowerOfTwo(data.width);
			var h:Number = getNextPowerOfTwo(data.height);
			var newData:BitmapData = new BitmapData(w, h, true, 0x0);
			var drawWithQualityFunc:Function = "drawWithQuality" in newData?newData["drawWithQuality"]:null;
			
			if (drawWithQualityFunc is Function) {
				drawWithQualityFunc.call(data, data, null, null, null, null, false, StageQuality.MEDIUM);
			} else {
				newData.draw(data, null);
			}
			
			return newData;
		}
		
	}

}