package game.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.TextureCenter;
	import flash.display3D.VertexBuffer3D;
	import chaos2D.display.DisplayObject;
	import chaos2D.display.Sprite;
	import chaos2D.texture.Texture;
	
	/**
	 * ...
	 * @author Chao
	 */
	public class Scroller extends Sprite 
	{
		private var _uvBuffer:VertexBuffer3D;
		private var _spriteSheetDetails:Object;
		
		public function Scroller(animName:String, frames:int = 60) 
		{
			super(animName);
			_totalFrames = frames;
			_currentFrameData = _anim[0];
			_spriteSheetDetails = _currentFrameData.spriteSheetDetail;
			_currentFrame = _totalFrames;

		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			_image.nativeWidth = _currentFrameData.rawWidth*(_totalFrames-_currentFrame)/_totalFrames;
			_image.nativeHeight = _currentFrameData.rawHeight;
			_image.x = _currentFrameData.rawWidth*_currentFrame/_totalFrames
			ChaosEngine.context.setMatrix3D(this.matrix3D);
			
			var uvVec:Vector.<Number> = Vector.<Number>([_spriteSheetDetails.x/_texture.width, _spriteSheetDetails.y/_texture.height,
													  (_spriteSheetDetails.x+_spriteSheetDetails.width*(_totalFrames-_currentFrame)/_totalFrames)/_texture.width, _spriteSheetDetails.y/_texture.height,
													  (_spriteSheetDetails.x+_spriteSheetDetails.width*(_totalFrames-_currentFrame)/_totalFrames)/_texture.width, (_spriteSheetDetails.y+_spriteSheetDetails.height)/_texture.height,
													  _spriteSheetDetails.x/_texture.width, (_spriteSheetDetails.y+_spriteSheetDetails.height)/_texture.height]);
			_uvBuffer = ChaosEngine.context.getVertexBufferByUV(uvVec, _texture.base);
			_image.render(_texture, _uvBuffer);
			
			uvVec = Vector.<Number>([(_spriteSheetDetails.x+_spriteSheetDetails.width - _currentFrame * _spriteSheetDetails.width/_totalFrames)/_texture.width, _spriteSheetDetails.y/_texture.height,
							     (_spriteSheetDetails.x+_spriteSheetDetails.width)/_texture.width, _spriteSheetDetails.y/_texture.height,
							     (_spriteSheetDetails.x+_spriteSheetDetails.width)/_texture.width, (_spriteSheetDetails.y+_spriteSheetDetails.height)/_texture.height,
							     (_spriteSheetDetails.x+_spriteSheetDetails.width - _currentFrame * _spriteSheetDetails.width/_totalFrames)/_texture.width, (_spriteSheetDetails.y+_spriteSheetDetails.height)/_texture.height]);
			_uvBuffer = ChaosEngine.context.getVertexBufferByUV(uvVec, _texture.base);
			
			_image.x = 0;
			_image.nativeWidth = _currentFrameData.rawWidth*_currentFrame/_totalFrames;
			_image.render(_texture, _uvBuffer);
			
			if (!_stopped) {
				_currentFrame--;
				if (_currentFrame == 1) _currentFrame = _totalFrames;
			}
		}
		
	}

}