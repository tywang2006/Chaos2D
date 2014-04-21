package  
{
	import adobe.utils.CustomActions;
	import chaos2D.ChaosEngine;
	import chaos2D.display.BlendMode;
	import chaos2D.display.ChaoStage;
	import chaos2D.display.DisplayObject;
	import chaos2D.display.DisplayObjectContainer;
	import chaos2D.display.Image;
	import chaos2D.display.Quad;
	import chaos2D.display.Sprite;
	import chaos2D.text.TextField;
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import flash.display.Bitmap;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import game.display.Scroller;
	
	/**
	 * ...
	 * @author Chao
	 */
	public class Game extends ChaoStage 
	{
		
		private var _bkg:Image;
		private var _superman:Sprite;
		private var _grass:Sprite;
		private var _buildings:Sprite;
		private var _mountain:Sprite;
		private var _planes:Vector.<Sprite>;
		private var _speeds:Vector.<Number>;
		private var _fires:Vector.<Sprite>;
		
		public function Game() 
		{
			super();
			_bkg = new Image(TextureCenter.instance.getTextureByID("BlueBkg"), 0, 0, 1024, 768);
			addChild(_bkg);
			
			_superman = new Sprite("fly");
			_superman.x = 400, _superman.y = 350;
			
			_grass = new Scroller("bgLayer4",400);
			_grass.y = 650;
			
			_buildings = new Scroller("bgLayer3",200);
			_buildings.y = 500;
			
			_mountain = new Scroller("bgLayer2", 600);
			_mountain.y = 450;
			
			addChild(_mountain);
			addChild(_buildings);
			addChild(_grass);
			
			
			_planes = new Vector.<Sprite>();
			_speeds = new Vector.<Number>();
			_fires = new Vector.<Sprite>();
			var i:int;
			for (i= 0; i < 1; i++) {
				var p:Sprite = new Sprite("item" + int(int(Math.random() * 7) + 1));
				_planes.push(p);
				p.x = 1100 + 1024 * Math.random();
				p.y = 550 * Math.random();
				p.registerPoint = new Point(0.5, 0.5);
				_speeds[i] = 2 + 5 * Math.random();
				addChild(p);
			}
			
			for (i = 0; i < 50; i++) {
				var f:Sprite = new Sprite("Explosion");
				_fires.push(f);
				f.x = 1024 * Math.random();
				f.y = 550 * Math.random();
				f.scaleX = f.scaleY = Math.random();
				f.color = Math.random() * 0x00FFFFFF + 0xFF000000;
				f.stop();
				//addChild(f);
			}
			
			addChild(_superman);
			

		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			var i:int;
			var len:int = _planes.length;
			for (i = 0; i < len; i++) {
				_planes[i].x = _planes[i].x - _speeds[i];
				_planes[i].rotation += _speeds[i];
				if (_planes[i].x < -50) {
					_planes[i].x = 1100;
					_planes[i].y = 600 * Math.random();
				}
				if(_planes[i].matrix)trace(_planes[i].getBounds(this))
			}
			len = _fires.length;
			for (i = 0; i < len; i++) {
				if (_fires[i].currentFrame == _fires[i].totalFrames) {
					_fires[i].x = 1024 * Math.random();
					_fires[i].y = 550 * Math.random();
					_fires[i].color = Math.random() * 0x00FFFFFF + 0xFF000000;
					_fires[i].scaleX = _fires[i].scaleY = Math.random();
				}
				if (_fires[i].parent == null && Math.random() > 0.8) {
					_fires[i].play();
					addChild(_fires[i]);
				}
			}
			
			super.render();

		}
		
	}

}