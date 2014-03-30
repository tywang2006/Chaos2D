package 
{
	import chaos2D.ChaosEngine;
	import chaos2D.util.data.SwfParser;
	import chaos2D.util.Stats;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chao
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "../texture/movie.swf", mimeType = "application/octet-stream")]
		private var assetClass:Class;
		
		
		private var _engine:ChaosEngine;
		private var _loader:Loader;
		public static var SS:Stage
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//addChild(new Stats());
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false,0,true);
			_loader.loadBytes(new assetClass());
		}
		
		private function onLoadComplete(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			startGame();
		}
		
		private function startGame():void
		{
			// entry point
			_engine = new ChaosEngine(stage, stage.stage3Ds[0], Game);
			_engine.addEventListener(Event.INIT, onCompleteStage3D);
		}
		
		private function onCompleteStage3D(e:Event):void 
		{
			SwfParser.addAsset(MovieClip(_loader.contentLoaderInfo.content));
		}
		
	}
	
}