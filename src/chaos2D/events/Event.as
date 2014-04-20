package chaos2D.events 
{
	import chaos2D.core.chaos2D_internal;
	import chaos2D.util.formatString;
	import chaos2D.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Chao
	 */
	public class Event 
	{
		 /** Event type for a display object that is added to a parent. */
        public static const ADDED:String = "added";
        /** Event type for a display object that is added to the stage */
        public static const ADDED_TO_STAGE:String = "addedToStage";
        /** Event type for a display object that is entering a new frame. */
        public static const ENTER_FRAME:String = "enterFrame";
        /** Event type for a display object that is removed from its parent. */
        public static const REMOVED:String = "removed";
        /** Event type for a display object that is removed from the stage. */
        public static const REMOVED_FROM_STAGE:String = "removedFromStage";
        /** Event type for a triggered button. */
        public static const TRIGGERED:String = "triggered";
        /** Event type for a display object that is being flattened. */
        public static const FLATTEN:String = "flatten";
        /** Event type for a resized Flash Player. */
        public static const RESIZE:String = "resize";
        /** Event type that may be used whenever something finishes. */
        public static const COMPLETE:String = "complete";
        /** Event type for a (re)created stage3D rendering context. */
        public static const CONTEXT3D_CREATE:String = "context3DCreate";
        /** Event type that indicates that the root DisplayObject has been created. */
        public static const ROOT_CREATED:String = "rootCreated";
        /** Event type for an animated object that requests to be removed from the juggler. */
        public static const REMOVE_FROM_JUGGLER:String = "removeFromJuggler";
        /** Event type that is dispatched by the AssetManager after a context loss. */
        public static const TEXTURES_RESTORED:String = "texturesRestored";
        
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const CHANGE:String = "change";
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const CANCEL:String = "cancel";
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const SCROLL:String = "scroll";
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const OPEN:String = "open";
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const CLOSE:String = "close";
        /** An event type to be utilized in custom events. Not used by Starling right now. */
        public static const SELECT:String = "select";
		
		private static var _eventPool:Vector.<Event> = new Vector.<Event>();
		
		private var _target:EventDispatcher;
		private var _currentTarget:EventDispatcher;
		private var _type:String;
		private var _bubbles:Boolean;
		private var _stopsPropagation:Boolean;
		private var _stopsImmediatePropagation:Boolean;
		private var _data:Object;
		
		public function Event(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			_type = type;
			_bubbles = bubbles;
			_data = data;
		}
		
		public function stopPropagation():void
		{
			_stopsPropagation = true;
		}
		
		public function stopImmediatePropagation():void
		{
			_stopsImmediatePropagation = _stopsPropagation = true;
		}
		
		public function toString():String
		{
			return formatString("[{0} type=\"{1}\" bubbles={2}]", 
                getQualifiedClassName(this).split("::").pop(), _type, _bubbles);
		}
		
		public function get target():EventDispatcher 
		{
			return _target;
		}
		
		public function get currentTarget():EventDispatcher 
		{
			return _currentTarget;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get bubbles():Boolean 
		{
			return _bubbles;
		}
		
		public function get stopsPropagation():Boolean 
		{
			return _stopsPropagation;
		}
		
		public function get stopsImmediatePropagation():Boolean 
		{
			return _stopsImmediatePropagation;
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		internal function setTarget(value:EventDispatcher):void { _target = value; }
        

        internal function setCurrentTarget(value:EventDispatcher):void { _currentTarget = value; } 
        

        internal function setData(value:Object):void { _data = value; }
		
		
		/** @private */
		chaos2D_internal static function fromPool(type:String, bubbles:Boolean=false, data:Object=null):Event
        {
            if (_eventPool.length) return _eventPool.pop().reset(type, bubbles, data);
            else return new Event(type, bubbles, data);
		}
		
		chaos2D_internal static function toPool(event:Event):void
        {
            event._data = event._target = event._currentTarget = null;
            _eventPool[_eventPool.length] = event; // avoiding 'push'
        }
		
		chaos2D_internal function reset(type:String, bubbles:Boolean=false, data:Object=null):Event
        {
            _type = type;
            _bubbles = bubbles;
            _data = data;
            _target = _currentTarget = null;
            _stopsPropagation = _stopsImmediatePropagation = false;
            return this;
        }
	}

}