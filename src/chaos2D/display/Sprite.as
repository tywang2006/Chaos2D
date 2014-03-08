package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.render.ImageRender;
	import chaos2D.render.RenderBase;
	import chaos2D.texture.FrameObject;
	import chaos2D.texture.Texture;
	import chaos2D.util.data.FrameDataObject;
	import chaos2D.util.data.SwfParser;
	/**
	 * ...
	 * @author Chao
	 */
	public class Sprite extends DisplayObjectContainer 
	{
		private var _render:RenderBase;
		private var _programName:String;
		private var _texture:Texture;
		private var _anim:Vector.<FrameObject>;
		private var _currentFrame:int;
		private var _currentFrameData:FrameDataObject;
		private var _stopped:Boolean;
		private var _totalFrames:int;
		
		public function Sprite(animName:String) 
		{
			_anim = SwfParser.getAnim(animName);
			if (!_anim) {
				throw ArgumentError("Image: anim can't be NULL!");
			}
			super();
			_currentFrame = 1;
			_totalFrames = _anim.length;
			_stopped = false;
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
		
		override public function render():void 
		{
			if (_render == null) {
				_render = new ImageRender();
				_programName = ImageRender(_render).generateProgramName(false, false);
			}
			_currentFrameData = _anim[_currentFrame-1];
			_texture = _currentFrameData.texture;
			_width = _texture.width;
			_height = _texture.height;
			
			ChaosEngine.context.setProgram(_programName);
			ChaosEngine.context.setAlphaBlend();
			ChaosEngine.context.setVertexBufferForTexture(_texture.base);
			super.render();
			
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