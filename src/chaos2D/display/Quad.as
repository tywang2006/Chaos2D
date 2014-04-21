package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.render.QuadRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Point;
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
			if (resultRect == null) resultRect = new Rectangle();
			if (targetSpace == this) {
				resultRect.setTo(0, 0, _width*_scaleX, _height*_scaleY);
			} else {
				getTransformationMatrix(targetSpace, _helperMatrix);
				var topLeft:Point = _helperMatrix.transformPoint(new Point(0, 0));
				var topRight:Point = _helperMatrix.transformPoint(new Point(1, 0));
				var bottomLeft:Point = _helperMatrix.transformPoint(new Point(0, 1));
				var bottomRight:Point = _helperMatrix.transformPoint(new Point(1, 1));
				
				var points:Vector.<Point> = Vector.<Point>([topLeft,topRight,bottomLeft,bottomRight])
				
				var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
                var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;;
				var i:int;
				var len:int = 4;
				for (i = 0; i < len; i++) {
					if (minX > points[i].x) minX = points[i].x;
					if (maxX < points[i].x) maxX = points[i].x;
					if (minY > points[i].y) minY = points[i].y;
					if (maxY < points[i].y) maxY = points[i].y;
				}
				
				resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
			}
		
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