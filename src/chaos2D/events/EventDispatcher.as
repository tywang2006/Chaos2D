package chaos2D.events 
{
	import chaos2D.core.chaos2D_internal;
	import chaos2D.display.DisplayObject;
	import flash.utils.Dictionary;
	
	use namespace chaos2D_internal;
	/**
	 * ...
	 * @author Chao
	 */
	public class EventDispatcher 
	{
		private var _eventListeners:Dictionary;
		private static var _bubbleChains:Array = [];
		
		public function EventDispatcher() 
		{
			trace("event dispatcher has been created");
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			if (_eventListeners == null) _eventListeners = new Dictionary();
			var listeners:Vector.<Function> = _eventListeners[type] as Vector.<Function>;
			if (listeners == null) {
				_eventListeners[type] = Vector.<Function>([listener]);
			} else if (listeners.indexOf(listener) == -1) {
				listeners.push(listener);
			}
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			if (_eventListeners) {
				var listeners:Vector.<Function> = _eventListeners[type] as Vector.<Function>;
				var numListeners:int = listeners?listeners.length:0;
				if (numListeners > 0) {
					var i:int;
					var index:int = 0;
					var restListeners:Vector.<Function> = new Vector.<Function>(numListeners-1);
					for (i = 0; i < numListeners; i++) {
						var l:Function = listeners[i];
						if (l != listener) restListeners[int(index++)] = l;
					}
					_eventListeners[type] = restListeners;
				}
			}
		}
		
		public function removeEventListeners(type:String = null):void
		{
			if (type && _eventListeners[type]) {
				delete _eventListeners[type];
			} else {
				_eventListeners = null;
			}
		}
		
		public function dispatchEvent(event:Event):void
		{
			var bubbles:Boolean = event.bubbles;
			if (!bubbles && (_eventListeners == null || !(event.type in _eventListeners))) return;
			
			var previousTarget:EventDispatcher = event.target;
			event.setTarget(this);
			if (bubbles && this is DisplayObject) bubbleEvent(event);
			else invokeEvent(event);
			
			if (previousTarget) event.setTarget(previousTarget);
		}
		
		internal function invokeEvent(event:Event):Boolean 
		{
			var listeners:Vector.<Function> = _eventListeners?_eventListeners[event.type] as Vector.<Function>:null;
			var numListeners:int = listeners == null?0:listeners.length;
			if (numListeners > 0) {
				event.setCurrentTarget(this);
				var i:int;
				for (i = 0; i < numListeners; i++) {
					var listener:Function = listeners[i] as Function;
					var numArgs:int = listener.length
					if (numArgs == 0) listener();
					else if (numArgs == 1) listener(event);
					else listener(event, event.data);
					if (event.stopsImmediatePropagation)
						return true;
				}
				
				return event.stopsPropagation;
			}
			
			return false;
		}
		
		internal function bubbleEvent(event:Event):void 
		{
			var chain:Vector.<EventDispatcher>;
			var element:DisplayObject = this as DisplayObject;
			var len:int = 1;
			if (_bubbleChains.length > 0) { 
				chain = _bubbleChains.pop();
				chain[0] = element;
			} else {
				chain = Vector.<EventDispatcher>([element]);
			}
			while ((element = element.parent) != null)
                chain[int(len++)] = element;
			var i:int;
			for (i = 0; i < len; ++i) {
				var stopPropagation:Boolean = chain[i].invokeEvent(event);
				if (stopPropagation) break;
			}
			
			chain.length = 0;
			_bubbleChains.push(chain);
		}
		
		
		//private, no use at the moment due to set only in intenal name space
		public function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void
        {
            if (bubbles || hasEventListener(type)) 
            {
                var event:Event = Event.fromPool(type, bubbles, data);
                dispatchEvent(event);
                Event.toPool(event);
            }
        }
		
        public function hasEventListener(type:String):Boolean
        {
            var listeners:Vector.<Function> = _eventListeners ?
                _eventListeners[type] as Vector.<Function> : null;
            return listeners ? listeners.length != 0 : false;
        }
		
	}

}