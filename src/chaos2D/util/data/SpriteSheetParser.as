package chaos2D.util.data 
{
	import adobe.utils.CustomActions;
	import chaos2D.ChaosEngine;
	import chaos2D.error.AbstractClassError;
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Chao
	 */
	public class SpriteSheetParser 
	{
		public static const XML_TYPE:String = "xml";
		public static const JSON_TYPE:String = "json";
		public static const PLIST_TYPE:String = "plist";
		
		private static var _anim:Dictionary = new Dictionary();
		private static var _texture:BitmapTexture;
		
		public function SpriteSheetParser() 
		{
			throw new AbstractClassError();
		}
		
		public static function parse(data:*, texture:BitmapTexture, type:String = XML_TYPE):Dictionary
		{
			_texture = texture;
			switch(type) {
				case XML_TYPE: parseXML(data); break;
				case JSON_TYPE: parseJSON(data); break;
				case PLIST_TYPE: parsePLIST(data); break;
			}
			
			return _anim;
		}
		
		private static function parsePLIST(data:String):void 
		{
			
		}
		
		private static function parseJSON(data:String):void 
		{
			
		}
		
		private static function parseXML(data:XML):void 
		{
			var i:int;
			var len:int = data.SubTexture.length();
			var textureName:String;
			var animName:String;
			var tempData:Array;
			var frames:Vector.<FrameDataObject>;
			var frameID:int;
			var frame:FrameDataObject
			for (i = 0; i < len; i++) {
				textureName = data.SubTexture[i].@name;
				tempData = textureName.split("_");
				frameID = int(tempData[1]);
				animName = tempData[0];
				frame = new FrameDataObject();
				frame.texture = _texture;
				frame.linkage = animName;
				frame.width = Number(data.SubTexture[i].@frameWidth);
				frame.height = Number(data.SubTexture[i].@frameHeight);
				frame.rawWidth = Number(data.SubTexture[i].@width);
				frame.rawHeight = Number(data.SubTexture[i].@height);
				frame.offsetX = -Number(data.SubTexture[i].@frameX);
				frame.offsetY = -Number(data.SubTexture[i].@frameY);
				if (frame.width == 0) frame.width = frame.rawWidth;
				if (frame.height == 0) frame.height = frame.rawWidth;

				frame.uv = Vector.<Number>([
												Number(data.SubTexture[i].@x)/_texture.width, Number(data.SubTexture[i].@y)/_texture.height,
												(Number(data.SubTexture[i].@x) + Number(data.SubTexture[i].@width))/_texture.width, Number(data.SubTexture[i].@y)/_texture.height,
												(Number(data.SubTexture[i].@x) + Number(data.SubTexture[i].@width))/_texture.width, (Number(data.SubTexture[i].@y) + Number(data.SubTexture[i].@height))/_texture.height,
												Number(data.SubTexture[i].@x)/_texture.width, (Number(data.SubTexture[i].@y) + Number(data.SubTexture[i].@height))/_texture.height
										  ]);
				
				frame.uvBuffer = ChaosEngine.context.getVertexBufferByUV(frame.uv, _texture.base);
				if (_anim[animName]) {
					frames = _anim[animName];
				} else {
					frames = _anim[animName] = new Vector.<FrameDataObject>();
					TextureCenter.instance.setTextureByID(animName, _texture);
				}
				if (frameID > 0) {
					
					var index:int = frameID - 1;
					frames[index] = frame;
					
				} else if (frameID == 0) {
					frames.push(frame);
				}
				
			}
		}
		
	}

}