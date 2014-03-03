package chaos2D.render 
{
	import chaos2D.ChaosEngine;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chao
	 */
	public class RenderBase 
	{
		
		public function RenderBase() 
		{
			ChaosEngine.instance.addEventListener(Event.INIT, onContextCreated);
			if (ChaosEngine.instance.root) {
				onContextCreated();
			}
		}
		
		protected function onContextCreated(e:Event = null):void 
		{
			ChaosEngine.instance.removeEventListener(Event.INIT, onContextCreated);
		}
		
		public function render():void
		{
			
		}
		
		protected function registerPrograms():void
		{
			throw "RenderBase: the program is not existing";
		}
	}

}