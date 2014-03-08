package chaos2D.util.data 
{
	import chaos2D.texture.TextureCenter;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Chao
	 */
	public class SwfParser 
	{
		private static var anims:Object = new Object();
		
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
				ClassReference = asset.loaderInfo.applicationDomain.getDefinition(linkages[i]);
				if (ClassReference is MovieClip) {
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
			if (!anims[linkage]) {
				throw "linkage has been added into animation, please change linkage in swf";
			}
			var numFrames:int = mc.totalFrames;
			anims[linkage] = new Vector.<FrameDataObject>(numFrames, true);
			var frameData:FrameDataObject;
			var bitmapData:BitmapData;
			var bound:Rectangle;
			var matrix:Matrix;
			var frameIndex:int;
			var i:int;
			
			for (i = 0; i < numFrames; i++) {
				mc.gotoAndStop(i);
				frameIndex = i + 1;
				frameData = new FrameDataObject();
				bitmapData = new BitmapData(mc.width, mc.height, true, 0x0);
				bound = mc.getBounds(mc);
				matrix = new Matrix();
				matrix.tx = -bound.x;
				matrix.ty = -bound.y;
				bitmapData.draw(mc, matrix);
				frameData.texture = TextureCenter.instance.addBitmapData(linkage + "_" + frameIndex, bitmapData);
				frameData.label = mc.currentLabel;
				frameData.frameIndex = frameIndex;
				anims[linkage][i] = frameData;
			}
		}	
		
	}

}