package chaos2D.pass
{
	/**
	 * ...
	 * @author Chao
	 */
	import flash.display3D.Context3D;
	
	public class PassSinWave extends Pass
	{
		public function PassSinWave(context:Context3D, isRenderToTexture:Boolean, width:Number=1, height:Number=1)
		{
			super(context, isRenderToTexture, width, height);
			
			_shaderVertex = "m44 op,va0,vc0\n" +
				"mov v0,va1";
			
			_shaderFragment="tex ft0,v0,fs1<2d,clamp,linear>\n" +
				"sub ft0.x,v0.x,fc0.w\n" +
				"mul ft0.x,ft0.x,ft0.x\n"+
				"sub ft0.y,v0.y,fc0.w\n"+
				"mul ft0.y,ft0.y,ft0.y\n"+
				"add ft0.z,ft0.x,ft0.y\n"+
				"sqt ft0.z,ft0.z\n"+
				"mul ft0.z,ft0.z,fc0.x\n"+
				"sub ft0.z,ft0.z,fc0.z\n"+
				"sin ft0.z,ft0.z\n"+
				"mul ft0.z,ft0.z,fc0.y\n"+
				"add ft0,v0,ft0.zzz\n"+
				"tex oc,ft0,fs0<2d,clamp,linear>\n";
		}
	}
}