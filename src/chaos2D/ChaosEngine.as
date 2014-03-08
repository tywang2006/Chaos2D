package chaos2D 
{
	import chaos2D.core.Context2D;
	import chaos2D.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Chao
	 */
	public class ChaosEngine extends EventDispatcher 
	{
		private var _stage:Stage;
		private var _stage3D:Stage3D;
		private var _context:Context2D;
		private var _root:DisplayObjectContainer;
		private var _rootClass:Class;
		private static var _instance:ChaosEngine;
		
		public function ChaosEngine(stage:Stage, stage3D:Stage3D, rootClass:Class) 
		{
			stage.quality = StageQuality.LOW;
			_stage = stage;
			_stage3D = stage3D;
			_instance = this;
			_rootClass = rootClass;
			requestContext2D();
		}
		
		private function requestContext2D():void 
		{
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			_stage3D.requestContext3D();
		}
		
		private function onContext3DCreated(e:Event):void 
		{
			_stage3D.context3D.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 0, false);
			
			_context = new Context2D(_stage3D.context3D);
			_context.setProjection(_stage.stageWidth, _stage.stageHeight);
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new Event(Event.INIT));
			
			_root = new _rootClass();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			render();
		}
		
		public function render():void
		{ 
			_context.clear();
			_root.render();
			_context.present();
		}
		
		public static function get context():Context2D
		{
			return instance._context;
		}
		
		public static function get instance():ChaosEngine
		{
			return _instance;
		}
		
		public function get root():DisplayObjectContainer 
		{
			return _root;
		}
		
		public function get stage():Stage 
		{
			return _stage;
		}
		
	}

}