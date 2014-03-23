package chaos2D.pass
{
	/**
	 * ...
	 * @author Chao
	 */
	import flash.display3D.Context3D;
	
	public class PassGrayscale extends Pass
	{
		public function PassGrayscale(context:Context3D, isRenderToTexture:Boolean, width:Number=1, height:Number=1)
		{
			super(context, isRenderToTexture, width, height);
			
			_shaderVertex = "" +
				"m44 op, va0,vc0\n" +
				"mov v0, va1\n";
			
			_shaderFragment = "" +
				"tex ft0, v0, fs0 <2d,linear,clamp>\n" +
				"add ft1.x, ft0.x, ft0.y\n" +
				"add ft1.x, ft1.x, ft0.z\n" +
				"div ft1.x, ft1.x, fc1.w\n" +
				"mov ft0.xyz, ft1.xxx\n" +
				"mov oc ft0\n";        
//			_shaderFragment = "" +
//				"tex ft0, v0, fs0 <2d,linear,clamp>\n" +
//				"dp3 ft0.w,ft0.xyz,fc1.xyz\n"+
//				"mov ft0.xyz,ft.www\n"+
//				"mov oc, ft0\n";
		}
	}
}