package chaos2D.util.data 
{
	import chaos2D.texture.TextureCenter;
	import chaos2D.util.data.layout.SpriteSheetPacker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedSuperclassName;
	/**
	 * ...
	 * @author Chao
	 */
	public class SwfParser 
	{
		private static var anims:Object = new Object();
		public static var testData:BitmapData;
		
		public static var shape:Shape = new Shape();
		
		public static function addAsset(asset:MovieClip):void
		{
			if (!asset) {
				throw "asset can't be NULL";
			}
			var linkages:Vector.<String> = asset.loaderInfo.applicationDomain.getQualifiedDefinitionNames();
			var i:int;
			var ClassReference:Class;
			var mc:MovieClip;
			for (i = 0; i < linkages.length; i++) {
				
				ClassReference = asset.loaderInfo.applicationDomain.getDefinition(linkages[i]) as Class;
				if (getQualifiedSuperclassName(ClassReference)=="flash.display::MovieClip") {
					mc = new ClassReference() as MovieClip;
					//cacheAnim(mc, linkages[i]);
					buildSpriteSheet(mc, linkages[i]);
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
				frameData.linkage = linkage;
				frameData.bitmapData = baseBitmapData;
				anims[linkage][i] = frameData;
			}
			
			spritePacker = new SpriteSheetPacker();
			spritePacker.fit(anims[linkage]);
			
			for (i = 0; i < anims[linkage].length; i++) {
				var b:Bitmap = new Bitmap(anims[linkage][i].bitmapData, "auto", true);
				b.x = anims[linkage][i].fit.x;
				b.y = anims[linkage][i].fit.y;
				Main.SS.addChild(b);
			}
			
			
			//var textureSize:Number = Math.pow(2, Math.ceil(Math.log(Math.max(textureWidth, textureHeight)) / Math.LN2));
			//var bitmapData:BitmapData = new BitmapData(textureSize, textureHeight);
			//TextureCenter.instance.addBitmapData(linkage, bitmapData);
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
				anims[linkage][i] = frameData;
				testData = bitmapData;
			
			}
		}	
		
	}

}