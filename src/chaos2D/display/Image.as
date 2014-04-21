package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.render.ImageRender;
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
	public class Image extends DisplayObject 
	{
		private var _render:RenderBase;
		private var _programName:String;
		private var _texture:Texture;
		private var _uvBuffer:VertexBuffer3D;
		
		public function Image(texture:Texture, renderX:Number = NaN, renderY:Number = NaN, renderWidth:Number = -1, renderHeight:Number = -1) 
		{
			if (texture) {
				super();
				_texture = texture;
				_width = texture.width;
				_height = texture.height;
				_isDirty = true;
				
				if (renderWidth > 0 && renderHeight > 0 &&!isNaN(renderX) && !isNaN(renderY)) {
					var uv:Vector.<Number> = Vector.<Number>([
												renderX/_texture.width, renderY/_texture.height,
												(renderX + renderWidth)/_texture.width, renderY/_texture.height,
												(renderX + renderWidth)/_texture.width, (renderY + renderHeight)/_texture.height,
												renderX/_texture.width, (renderY + renderHeight)/_texture.height
										  ]);
					_uvBuffer = ChaosEngine.context.getVertexBufferByUV(uv, _texture.base);
					_width = renderWidth;
					_height = renderHeight;
				}
			} else {
				throw ArgumentError("Image: texture can't be NULL!");
			}
			
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
			
			return resultRect
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			if (!_parent) return;
			if (_render == null) {
				_render = new ImageRender();
			}
			_programName = ImageRender(_render).generateProgramName(this.color >= 0, false);
			ChaosEngine.context.setProgram(_programName);
			ChaosEngine.context.setAlphaBlend(BlendMode.getBlendFactors(this.blendMode));
			if(_uvBuffer) ChaosEngine.context.setCustomizeVertexBufferForTexture(_uvBuffer, _texture.base);
			else if (!customizeTexture && !uv) ChaosEngine.context.setVertexBufferForTexture(_texture.base); 
			else ChaosEngine.context.setCustomizeVertexBufferForTexture(uv, customizeTexture.base);
			super.render();
			ChaosEngine.context.clearBufferForImage();
		}
		
		public function set texture(value:Texture):void 
		{
			if (value == _texture) return;
			_texture = value;
		}
		
		public function get texture():Texture 
		{
			return _texture;
		}
		
	}

}