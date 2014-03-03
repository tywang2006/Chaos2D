package chaos2D.render 
{
	import chaos2D.texture.Texture;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DTextureFormat;
	/**
	 * ...
	 * @author Chao
	 */
	public class ImageRender extends RenderBase 
	{
		
		public function ImageRender() 
		{
			super();
			
		}
		
		override protected function registerPrograms():void 
		{
			var vertexSrc:String = "m44 op,va0,vc0 \n" +
								   "mov v0,va1 \n" +
				                   "mov v1,va2";
			var fragmentSrc:String = "tex ft0,v1,fs0 <???> \n" +
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
		
		private static function generateProgramName(tinted:Boolean, mipMap:Boolean=true, 
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
			if(name==null)
			{
				name = "IR"+bitField.toString(16);
				_programNameCache[bitField] = name;
			}
			return name;
		}
		
	}

}