package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.render.ImageRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import chaos2D.util.data.FrameDataObject;
	import chaos2D.util.data.SwfParser;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Chao
	 */
	public class Sprite extends DisplayObjectContainer 
	{
		private var _render:RenderBase;
		private var _programName:String;
		private var _anim:Vector.<FrameDataObject>;
		private var _currentFrame:int;
		private var _currentFrameData:FrameDataObject;
		private var _stopped:Boolean;
		private var _totalFrames:int;
		private var _image:Image;
		private var _texture:Texture;
		
		public function Sprite(animName:String) 
		{
			super();
			_anim = SwfParser.getAnim(animName);
			if (!_anim) {
				throw ArgumentError("Image: anim can't be NULL!");
			}
			_width = _height = 1;
			_texture = TextureCenter.instance.getTextureByID(animName);
			_currentFrame = 1;
			_totalFrames = _anim.length;
			_stopped = false;
			_image = new Image(_texture);
			_isDirty = true;
			addChild(_image);
		}
		
		public function stop():void
		{
			_stopped = true;
		}
		
		public function gotoAndStop(frame:int):void
		{
			_stopped = true;
			if (frame < 1) frame = 1;
			_currentFrame = frame;
		}
		
		public function gotoAndPlay(value:*):void {
			if (value is String) {
				_currentFrame = getFrameBylabel(value);
			} else if (value is int) {
				_currentFrame = value;
			}
			if (_currentFrame < 1)_currentFrame = 1;
		}
		
		override public function render(valid:Boolean = false):void 
		{
			if (!_parent) return;
			_currentFrameData = _anim[_currentFrame-1];
			_image.width = _currentFrameData.width;
			_image.height = _currentFrameData.height;
			_image.x = _currentFrameData.offsetX;
			_image.y = _currentFrameData.offsetY;
			ChaosEngine.context.setMatrix3D(this.matrix3D);
			ChaosEngine.context.setCustomizeVertexBufferForTexture(_currentFrameData.uvBuffer, _texture.base);

			var i:int;
			for (i = 0; i < _numChildren; i++) {
				if (_image == _children[i]) {
					_image.render(true);
				} else {
					_children[i].render();
				}
			}
			
			if (!_stopped) {
				_currentFrame++;
				if (_currentFrame > _totalFrames) _currentFrame = 1;
			}
		}
		
		public function get currentFrame():int 
		{
			return _currentFrameData.frameIndex;
		}
		
		public function get currentLabel():String
		{
			return _currentFrameData.label;
		}
		
		public function get image():Image 
		{
			return _image;
		}
		
		private function getFrameBylabel(label:String):int
		{
			var i:int;
			for (i = 0; i < _totalFrames; i++) {
				if (label == _anim[i].label) {
					return _anim[i].frameIndex;
				}
			}
			return -1;
		}
		
	}

}