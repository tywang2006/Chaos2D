package chaos2D.util.data 
{
	import chaos2D.texture.TextureCenter;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
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