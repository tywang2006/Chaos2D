package chaos2D.util.data 
{
	import chaos2D.texture.TextureCenter;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
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
		
		public function SwfParser() 
		{
			
		}
		
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
					cacheAnim(mc, linkages[i]);
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
			anims[linkage] = new Vector.<FrameDataObject>(numFrames, true);
			var frameData:FrameDataObject;
			
			var numFrames:int = mc.totalFrames;
			var numUnits:int = 1;
			var unitWidth:Number = mc.rect.width;
			var unitHeight:Number = mc.rect.height;
			while (numUnits * numUnits < numFrames) numUnits++;
			var textureWidth:Number = numUnits * unitWidth;
			var textureHeight:Number = numUnits * unitHeight;
			var textureSize:Number = Math.pow(2, Math.ceil(Math.log(Math.max(textureWidth, textureHeight)) / Math.LN2));
			var bitmapData:BitmapData = new BitmapData(textureSize, textureHeight);
			var signalBitmapData:BitmapData;
			var i:int;
			var j:int;
			var frameIndex:int;
			var matrix:Matrix = new Matrix();
			var bound:Rectangle;
			for (i = 0; i < numUnits; i++) {
				for (j = 0; j < numUnits; j++) {
					frameIndex = i * numUnits + j;
					if (frameIndex >= numFrames) break;
					mc.gotoAndStop(frameIndex);
					bound = mc.rect.getBounds(mc);
					signalBitmapData = new BitmapData(unitWidth, unitHeight)
					matrix.identity();
					matrix.translate( -bound.x, -bound.y);
					signalBitmapData.draw(mc, matrix, null, null, null, true);
					bitmapData.copyPixels(signalBitmapData, new Rectangle(0, 0, unitWidth, unitHeight), new Point(i * unitWidth, j * unitHeight));
					
					frameData = new FrameDataObject();
					frameData.label = mc.currentLabel;
					frameData.width = unitWidth;
					frameData.height = unitHeight;
					frameData.linkage = linkage;
					anims[linkage][i] = frameData;
				}
			}
			TextureCenter.instance.addBitmapData(linkage, bitmapData);
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