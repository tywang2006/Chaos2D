package chaos2D.events 
{
	import chaos2D.core.chaos2D_internal;
	import chaos2D.display.DisplayObject;
	
	use namespace chaos2D_internal;
	/**
	 * ...
	 * @author Chao
	 */
	public class TouchEvent extends Event 
	{
		public static const TOUCH:String = "touch";
		
		private var _shiftKey:Boolean;
        private var _ctrlKey:Boolean;
        private var _timestamp:Number;
        private var _visitedObjects:Vector.<EventDispatcher>;
        
        /** Helper object. */
        private static var _touches:Vector.<Touch> = new <Touch>[];
		
		public function TouchEvent(type:String, touches:Vector.<Touch>, shiftKey:Boolean=false, 
                                   ctrlKey:Boolean=false, bubbles:Boolean=true) 
		{
			super(type, bubbles, touches);
			
			_shiftKey = shiftKey;
            _ctrlKey = ctrlKey;
            _timestamp = -1.0;
            _visitedObjects = new Vector.<EventDispatcher>();
            
			var i:int;
            var numTouches:int = touches.length;
            for (i = 0; i < numTouches; i++) {
                if (touches[i].timestamp > _timestamp) {
                    _timestamp = touches[i].timestamp;
				}
			}
			
		}
		
		public function getTouches(target:DisplayObject, phase:String=null,
                                   result:Vector.<Touch>=null):Vector.<Touch>
        {
            if (result == null) result = new <Touch>[];
            var allTouches:Vector.<Touch> = data as Vector.<Touch>;
            var numTouches:int = allTouches.length;
            var i:int;
            for (i = 0; i < numTouches; i++) {
                var touch:Touch = allTouches[i];
                var correctTarget:Boolean = touch.isTouching(target);
                var correctPhase:Boolean = (phase == null || phase == touch.phase);
                    
                if (correctTarget && correctPhase)
                    result[result.length] = touch; // avoiding 'push'
            }
            return result;
        }
		
		public function getTouch(target:DisplayObject, phase:String=null, id:int=-1):Touch
        {
            getTouches(target, phase, _touches);
            var numTouches:int = _touches.length;
            if (numTouches > 0) {
                var touch:Touch = null;
                if (id < 0) touch = sTouches[0];
                else {
					var i:int;
                    for (i = 0; i < numTouches; ++i) {
                        if (sTouches[i].id == id) { touch = sTouches[i]; break; }
					}
                }
                
                _touches.length = 0;
                return touch;
            }
            else return null;
        }
		
		internal function dispatch(chain:Vector.<EventDispatcher>):void
        {
            if (chain && chain.length)
            {
                var chainLength:int = bubbles ? chain.length : 1;
                var previousTarget:EventDispatcher = target;
                setTarget(chain[0] as EventDispatcher);
                var i:int;
                for (i = 0; i < chainLength; i++) {
                    var chainElement:EventDispatcher = chain[i] as EventDispatcher;
                    if (_visitedObjects.indexOf(chainElement) == -1) {
                        var stopPropagation:Boolean = chainElement.invokeEvent(this);
                        _visitedObjects[_visitedObjects.length] = chainElement;
                        if (stopPropagation) break;
                    }
                }
                
                setTarget(previousTarget);
            }
        }
		
		public function get timestamp():Number 
		{
			return _timestamp;
		}
		
		static public function get touches():Vector.<Touch> 
		{
			return _touches;
		}
		
		public function get shiftKey():Boolean 
		{
			return _shiftKey;
		}
		
		public function get ctrlKey():Boolean 
		{
			return _ctrlKey;
		}
		
	}

}