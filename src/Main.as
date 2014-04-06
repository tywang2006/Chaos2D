package 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.TextureCenter;
	import chaos2D.util.data.AssetParser;
	import chaos2D.util.Stats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		[Embed(source="../texture/bgLayer1.jpg")]
		private var Background:Class;
		
		[Embed(source = "../texture/mySpritesheet.png")]
		private var sheetBitmap:Class;
		
		[Embed(source = "../texture/fire.png")]
		private var fire:Class;
		
		[Embed(source = "../texture/fire.xml", mimeType = "application/octet-stream")]
		private var fireSheet:Class; 
		
		[Embed(source = "../texture/mySpritesheet.xml", mimeType = "application/octet-stream")]
		private var sheet:Class; 
		
		[Embed(source = "../texture/movie.swf", mimeType = "application/octet-stream")]
		private var assetClass:Class;
		
		private var _loader:Loader;
		
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
			
			//_loader = new Loader();
			//_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false,0,true);
			//_loader.loadBytes(new assetClass());
			startGame();
			
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
			TextureCenter.instance.addBitmap("BlueBkg", new Background());
			//AssetParser.addAsset(MovieClip(_loader.contentLoaderInfo.content));
			AssetParser.addAsset(new XML(new sheet()), TextureCenter.instance.addBitmap("SHEET", new sheetBitmap()));
			AssetParser.addAsset(new XML(new fireSheet()), TextureCenter.instance.addBitmap("FIRE", new fire()));
		}
		
	}
	
}