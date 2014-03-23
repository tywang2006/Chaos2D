package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.render.ImageRender;
	import chaos2D.render.QuadRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.Texture;
	import flash.display3D.VertexBuffer3D;
	/**
	 * ...
	 * @author Chao
	 */
	public class Image extends DisplayObject 
	{
		private var _render:RenderBase;
		private var _programName:String;
		private var _texture:Texture;
		
		public function Image(texture:Texture) 
		{
			if (texture) {
				super();
				_texture = texture;
				_width = texture.width;
				_height = texture.height;
				_isDirty = true;
			} else {
				throw ArgumentError("Image: texture can't be NULL!");
			}
			
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			if (!_parent) return;
			if (_render == null) {
				_render = new ImageRender();
			}
			
			_programName = ImageRender(_render).generateProgramName(this.color >= 0, false);
			ChaosEngine.context.setProgram(_programName);
			ChaosEngine.context.setAlphaBlend();
			if (!customizeTexture && !uv) ChaosEngine.context.setVertexBufferForTexture(_texture.base);
			else ChaosEngine.context.setCustomizeVertexBufferForTexture(uv, customizeTexture.base);
			super.render();
			ChaosEngine.context.clearBufferForImage();
		}
		
		public function set texture(value:Texture):void 
		{
			_texture = value;
		}
		
		public function get texture():Texture 
		{
			return _texture;
		}
		
	}

}