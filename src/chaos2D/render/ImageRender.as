package chaos2D.render 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.Texture;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Chao
	 */
	public class ImageRender extends RenderBase 
	{
		private static var _programNameCache:Dictionary;
		
		public function ImageRender() 
		{
			
			super();
		}
		
		override protected function onContextCreated(e:Event = null):void 
		{
			super.onContextCreated(e);
			registerPrograms();
		}
		
		override protected function registerPrograms():void 
		{
			if (_programNameCache) return;
			_programNameCache = new Dictionary();
			
			var vertexSrc:String = "m44 op,va0,vc0 \n" +
								   "mov v0,va2";
			var fragmentSrc:String = "tex ft0,v0,fs0 <???> \n" +
									 "mul ft0,ft0,fc1\n"+	
									 "mov oc,ft0";
			
			var tinted:Boolean = false;
			
			var smoothingTypes:Array = [
				Texture.SMOOTHING_NONE,
				Texture.SMOOTING_BILINEAR,
				Texture.SMOOTHING_TRILINEAR
			];
			
			var formats:Array = [
				Context3DTextureFormat.BGRA,
				Context3DTextureFormat.COMPRESSED,
				"compressedAlpha" // use explicit string for compatibility
			];
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			vertexAssembler.assemble(Context3DProgramType.VERTEX,vertexSrc);
			for each (var repeat:Boolean in [true, false])
			{
				for each (var mipmap:Boolean in [true, false])
				{
					for each (var smoothing:String in smoothingTypes)
					{
						for each (var format:String in formats)
						{
							var options:Array = ["2d", repeat ? "repeat" : "clamp"];
							
							if (format == Context3DTextureFormat.COMPRESSED) options.push("dxt1");
							else if (format == "compressedAlpha") options.push("dxt5");
							
							if (smoothing == Texture.SMOOTHING_NONE)
								options.push("nearest", mipmap ? "mipnearest" : "mipnone");
							else if (smoothing == Texture.SMOOTING_BILINEAR)
								options.push("linear", mipmap ? "mipnearest" : "mipnone");
							else
								options.push("linear", mipmap ? "miplinear" : "mipnone");
							
							fragmentAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentSrc.replace("???", options.join()));
							ChaosEngine.context.registerProgram(
								generateProgramName(tinted, mipmap, repeat, format, smoothing),
								vertexAssembler.agalcode, fragmentAssembler.agalcode);
						}
					}
				}
			}
		}
		
		public function generateProgramName(tinted:Boolean, mipMap:Boolean=true, 
													repeat:Boolean=false, format:String="bgra",
													smoothing:String="bilinear"):String
		{
			var bitField:uint = 0;
			
			if (tinted) bitField |= 1;
			if (mipMap) bitField |= 1 << 1;
			if (repeat) bitField |= 1 << 2;
			
			if (smoothing == Texture.SMOOTHING_NONE) bitField |= 1 << 3;
			else if (smoothing == Texture.SMOOTHING_TRILINEAR) bitField |= 1 << 4;
			
			if (format == Texture.FORMAT_COMPRESSED) bitField |= 1 << 5;
			else if (format == "compressedAlpha") bitField |= 1 << 6;
			
			var name:String = _programNameCache[bitField];
			if (name == null) {
				name = "IR"+bitField.toString(16);
				_programNameCache[bitField] = name;
			}
			return name;
		}
		
	}

}