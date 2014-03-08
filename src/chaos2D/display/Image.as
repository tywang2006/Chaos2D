package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.render.ImageRender;
	import chaos2D.render.QuadRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.Texture;
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
				//_texture.uploadData();
			} else {
				throw ArgumentError("Image: texture can't be NULL!");
			}
			
		}
		
		override public function render():void 
		{
			if (_render == null) {
				_render = new ImageRender();
				_programName = ImageRender(_render).generateProgramName(false, false);
			}
			ChaosEngine.context.setProgram(_programName);
			ChaosEngine.context.setAlphaBlend();
			ChaosEngine.context.setVertexBufferForTexture(_texture.base);
			super.render();
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