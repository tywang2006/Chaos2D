package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.render.QuadRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Chao
	 */
	public class Quad extends DisplayObject 
	{
		private var _render:RenderBase;
		
		public function Quad(width:Number, height:Number, color:uint = 0xFFFFFFFF) 
		{
			super();
			_color = color;
			_width = width;
			_height = height
			_isDirty = true;
		}
		
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle 
		{
			
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			if (!_parent) return;
			if (_render == null)_render = new QuadRender();
			var context:Context2D = ChaosEngine.context;
			context.setProgram(QuadRender.QUAD_PROGRAM_NAME);
			context.setAlphaBlend(BlendMode.getBlendFactors(this.blendMode));
			
			if (this.color >= 0) ChaosEngine.context.setColorConstant(_color);
			else context.setColorConstant(_color);
			context.setAlphaBuffer(this.alpha * _parent.alpha);
			context.setMatrix3D(this.matrix3D);
			context.drawTriangle();
		}
		
	}

}