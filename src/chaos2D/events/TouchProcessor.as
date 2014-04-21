package chaos2D.events 
{
	import chaos2D.display.ChaoStage;
	import chaos2D.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Chao
	 */
	public class TouchProcessor 
	{
		private var _stage:ChaoStage;
        private var _root:DisplayObject;
        private var _elapsedTime:Number;
        private var _lastTaps:Vector.<Touch>;
        private var _shiftDown:Boolean = false;
        private var _ctrlDown:Boolean  = false;
        private var _multitapTime:Number = 0.3;
        private var _multitapDistance:Number = 25;
        
        /** A vector of arrays with the arguments that were passed to the "enqueue"
         *  method (the oldest being at the end of the vector). */
        protected var _queue:Vector.<Array>;
        
        /** The list of all currently active touches. */
        protected var _currentTouches:Vector.<Touch>;
        
        /** Helper objects. */
        private static var _updatedTouches:Vector.<Touch> = new <Touch>[];
        private static var _hoveringTouchData:Vector.<Object> = new <Object>[];
        private static var _helperPoint:Point = new Point();
		
		public function TouchProcessor(stage:ChaoStage) 
		{
			//I am working on this.
			_root = _stage = stage;
			_elapsedTime = 0.0;
			_currentTouches = new Vector.<Touch>();
			_queue = new Vector.<Array>();
			_lastTaps = new Vector.<Touch>();
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			monitorInterruptions(true);
			
		}
		
		public function dispose():void
		{
			monitorInterruptions(false);
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		
		private function monitorInterruptions(enabled:Boolean):void
		{
			try {
				var nativeAppClass:Object = getDefinitionByName("flash.desktop::NativeApplication");
                var nativeApp:Object = nativeAppClass["nativeApplication"];
				if (enabled) {
					nativeApp.addEventListener("deactivate", onInterruption, false, 0, true);
				} else {
					nativeApp.removeEventListener("deactivate", onInterruption);
				}
			} catch (e:Error) { };
		}
		
		private function onInterruption(event:Object):void 
		{
			if (_currentTouches.length > 0) {
				for each(var t:Touch in _currentTouches) {
					if (t.phase == TouchPhase.BEGAN || t.phase == TouchPhase.MOVED || t.phase == TouchPhase.STATIONARY) {
						t.phase = TouchPhase.ENDED;
					}
				}
				
				processTouches(_currentTouches, _shiftDown, _ctrlDown);
			}
			
			_currentTouches.length = 0;
			_queue.length = 0;
		}
		
		protected function processTouches(touches:Vector.<Touch>, shiftDown:Boolean, ctrlDown:Boolean):void 
		{
			_hoveringTouchData.length = 0;
			var touchEvent:TouchEvent = new TouchEvent(TouchEvent.TOUCH, _currentTouches, shiftDown, ctrlDown);
			var t:Touch;
			for (t in touches) {
				if (t.phase == TouchPhase.HOVER && t.target) {
					_hoveringTouchData[_hoveringTouchData.length] = { touch:t, target:t.target, bubbleChain:t.bubbleChain };
				}
				if (t.phase == TouchPhase.HOVER || t.phase == TouchPhase.BEGAN) {
					_helperPoint.setTo(t.globalX, t.globalY);
					t.target = _root.hitTest(_helperPoint, true);
				}
			}
			
			for each(var data:Object in _hoveringTouchData) {
				if (data.touch.target != data.target) {
					touchEvent.dispatch(data.bubbleChain);
				}
			}
			
			for each(t in touches) {
				t.dispatchEvent(touchEvent);
			}
		}
		
	}

}