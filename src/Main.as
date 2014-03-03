package 
{
	import chaos2D.ChaosEngine;
	import chaos2D.util.Stats;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chao
	 */
	public class Main extends Sprite 
	{
		private var _engine:ChaosEngine;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			addChild(new Stats());
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_engine = new ChaosEngine(stage, stage.stage3Ds[0], Game);
			_engine.addEventListener(Event.INIT, onCompleteStage3D);
		}
		
		private function onCompleteStage3D(e:Event):void 
		{
			
		}
		
	}
	
}