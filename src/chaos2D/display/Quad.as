package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.render.QuadRender;
	import chaos2D.render.RenderBase;
	/**
	 * ...
	 * @author Chao
	 */
	public class Quad extends DisplayObject 
	{
		private var _render:RenderBase;
		private var _color:uint;
		
		public function Quad(width:Number, height:Number, color:uint = 0xFFFFFFFF) 
		{
			super();
			_color = color;
			_width = width;
			_height = height
			_isDirty = true;
		}
		
		override public function render():void 
		{
			if (_render == null)_render = new QuadRender();;
			var context:Context2D = ChaosEngine.context;
			context.setProgram(QuadRender.QUAD_PROGRAM_NAME);
			context.setColorConstant(_color);
			super.render();
		}
		
		final public function set color(value:uint):void 
		{
			_color = value;
		}
		
	}

}