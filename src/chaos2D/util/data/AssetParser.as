package chaos2D.util.data 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import chaos2D.util.data.layout.SpriteSheetPacker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedSuperclassName;
	/**
	 * ...
	 * @author Chao
	 */
	public class AssetParser 
	{
		private static var anims:Object = new Object();
		
		
		public static function addAsset(asset:*, texture:BitmapTexture = null):void
		{
			if (!asset) {
				throw "asset can't be NULL";
			}
			var anim:Dictionary;
			if(asset is MovieClip) {
				var linkages:Vector.<String> = asset.loaderInfo.applicationDomain.getQualifiedDefinitionNames();
				var i:int;
				var ClassReference:Class;
				var mc:MovieClip;
				for (i = 0; i < linkages.length; i++) {
					
					ClassReference = asset.loaderInfo.applicationDomain.getDefinition(linkages[i]) as Class;
					if (getQualifiedSuperclassName(ClassReference)=="flash.display::MovieClip") {
						mc = new ClassReference() as MovieClip;
						buildSpriteSheet(mc, linkages[i]);
					}
				}
			} else if (asset is XML) {
				anim = SpriteSheetParser.parse(asset, texture, SpriteSheetParser.XML_TYPE);
			}
			
			var linkageName:String
			if (anim) {
				for (linkageName in anim) {
					if (AssetParser.anims[linkageName]) {
						trace(linkageName + "  has been overwriten");
					}
					AssetParser.anims[linkageName] = anim[linkageName];
				}
			}
			
		}
		
		public static function getAnim(linkage:String):Vector.<FrameDataObject>
		{
			return anims[linkage];
		}
		
		private static function buildSpriteSheet(mc:MovieClip, linkage:String):void
		{
			if (anims[linkage]) {
				throw "linkage has been added into animation, please change linkage in swf";
			}

			var frameData:FrameDataObject;
			
			var numFrames:int = mc.totalFrames;
			anims[linkage] = new Vector.<FrameDataObject>();
			var baseBitmapData:BitmapData;
			
			var i:int;
			var j:int;
			var frameIndex:int;
			var matrix:Matrix = new Matrix();
			var bound:Rectangle;
			var texWidth:Number = 0;
			var texHeight:Number = 0;
			var spritePacker:SpriteSheetPacker;
			
			for (i = 0; i < numFrames; i++) {
				mc.gotoAndStop(i+1);
				bound = mc.getRect(mc);
				baseBitmapData = new BitmapData(bound.width, bound.height, true, 0x0)
				matrix = new Matrix()
				matrix.tx = -bound.x;
				matrix.ty = -bound.y;
				baseBitmapData.draw(mc, matrix, null, null, null, true);
				
				frameData = new FrameDataObject();
				frameData.label = mc.currentLabel;
				frameData.offsetX = matrix.tx;
				frameData.offsetY = matrix.ty;
				frameData.width = bound.width;
				frameData.height = bound.height;
				frameData.rawWidth = frameData.width;
				frameData.rawHeight = frameData.height;
				frameData.linkage = linkage;
				frameData.bitmapData = baseBitmapData;
				anims[linkage][i] = frameData;
			}
			
			spritePacker = new SpriteSheetPacker();
			spritePacker.fit(anims[linkage]);
			var maxValue:Number = Math.pow(2, Math.ceil(Math.log(Math.max(spritePacker.maxHeight, spritePacker.maxHeight)) / Math.LN2));
			baseBitmapData = new BitmapData(maxValue, maxValue, true, 0x0);
			
			
			for (i = 0; i < anims[linkage].length; i++) {
				frameData = anims[linkage][i];
				frameData.uv = Vector.<Number>([
													frameData.fit.x/maxValue, frameData.fit.y/maxValue,
													(frameData.fit.x + frameData.width)/maxValue, frameData.fit.y/maxValue,
													(frameData.fit.x + frameData.width)/maxValue, (frameData.fit.y + frameData.height)/maxValue,
													frameData.fit.x/maxValue, (frameData.fit.y + frameData.height)/maxValue
											  ]);
				baseBitmapData.copyPixels(frameData.bitmapData, frameData.bitmapData.rect, new Point(frameData.fit.x, frameData.fit.y));
				anims[linkage][i].bitmapData.dispose();
			}
			
			var texture:Texture = TextureCenter.instance.addBitmapData(linkage, baseBitmapData);
			
			for (i = 0; i < anims[linkage].length; i++) {
				anims[linkage][i].uvBuffer = ChaosEngine.context.getVertexBufferByUV(anims[linkage][i].uv, texture.base);
			}
			
			//show 2 power sprite sheet
			//ChaosEngine.instance.stage.addChild(new Bitmap(baseBitmapData));

		}
		
		private static function cacheAnim(mc:MovieClip, linkage:String):void
		{
			if (anims[linkage]) {
				throw "linkage has been added into animation, please change linkage in swf";
			}
			var numFrames:int = mc.totalFrames;
			anims[linkage] = new Vector.<FrameDataObject>(numFrames, true);
			var frameData:FrameDataObject;
			var bitmapData:BitmapData;
			var bitmapData2:BitmapData;
			var bound:Rectangle;
			var matrix:Matrix;
			var frameIndex:int;
			var i:int;
			var maxValue:Number;
			for (i = 0; i < numFrames; i++) {
				mc.gotoAndStop(i);
				maxValue = Math.pow(2, Math.ceil(Math.log(Math.max(mc.width, mc.height)) / Math.log(2)));
				frameIndex = i + 1;
				frameData = new FrameDataObject();
				bitmapData = new BitmapData(maxValue, maxValue, true, 0xFFFFFF);
				bound = mc.getBounds(mc);
				matrix = new Matrix();
				matrix.tx = -bound.x;
				matrix.ty = -bound.y;
				bitmapData.draw(mc, matrix, null,null,null,true);
				frameData.offsetX = matrix.tx;
				frameData.offsetY = matrix.ty;
				frameData.bitmapData = bitmapData;
				frameData.texture = TextureCenter.instance.addBitmapData(linkage + "_" + frameIndex, bitmapData);
				frameData.label = mc.currentLabel;
				frameData.frameIndex = frameIndex;
				frameData.width = mc.width;
				frameData.height = mc.height;
				frameData.rawWidth = frameData.width;
				frameData.rawHeight = frameData.height;
				anims[linkage][i] = frameData;
			
			}
		}	
		
	}

}