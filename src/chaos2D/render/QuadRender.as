package chaos2D.render 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chao
	 */
	public class QuadRender extends RenderBase 
	{
		public static const QUAD_PROGRAM_NAME:String = "QR";
		
		public function QuadRender() 
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
			
			var vertexSrc:String = "m44 op,va0,vc0";
			var fragmentSrc:String = "mov ft0,fc0\n" + 
								     "mul ft0,ft0,fc0\n" +
									 "mov oc, ft0";
			
			
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(Context3DProgramType.VERTEX,vertexSrc);
			fragmentAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentSrc);
			
			ChaosEngine.context.registerProgram(QUAD_PROGRAM_NAME, vertexAssembler.agalcode, fragmentAssembler.agalcode);
		}
		
	}

}