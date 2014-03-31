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
	
	/**
	 * ...
	 * @author Chao
	 */
	public class Game extends ChaoStage 
	{
		private var quads:Vector.<Quad> = new Vector.<Quad>();
		private var images:Vector.<Image> = new Vector.<Image>();
		private var vs:Vector.<Number> = new Vector.<Number>();
		private var ds:Vector.<Number> = new Vector.<Number>();
		private var acc:Number = 2;
		private var direct:Number;
		private var image:Image;
		private var sprites:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		[Embed(source="../texture/flower.png")]
		private var Flower2:Class;
		
		[Embed(source = "../texture/bird.jpg")]
		private var Bird:Class;
		
		private var tt:TextField;
		
		public function Game() 
		{
			super();
			//new Quad(100,100,0xFFFFFFFF*Math.random())
			//new Sprite("square")
			
			
			
			for (var i:int = 0; i < 1000; i++)
			{
				tt = new TextField(100, 20, String(Math.random() * 999999), "Verdana", 10 * Math.random()+10, 0xFFFFFFFF*Math.random());
				var sprite:DisplayObject = (Math.random() > 0.9)?new Quad(100, 100, 0xFFFFFFFF * Math.random()):(Math.random() > 0.8)?new Sprite("square"):new Image(tt.texture);
				sprite.blendMode = BlendMode.SCREEN;
				sprite.color = 0xFFFFFFFF*Math.random();
				addChild(sprite);
				sprite.x = 1200 * Math.random();
				sprite.y = 600 * Math.random();
				sprite.registerPoint = new Point(0.5, 0.5);
				sprite.scaleX = sprite.scaleY = 3*(Math.random() - 0.5);
				sprites.push(sprite);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
			}
			
	
			
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			
			for (var i:int = 0; i < sprites.length; i++) {
				direct = Math.random();
				if (direct > 0.4) {
					sprites[i].x += vs[i];
					if(sprites[i] is Quad)sprites[i].rotation++;
				} else {
					sprites[i].y += vs[i];
					if(sprites[i] is Quad)sprites[i].rotation--;
				}
				if (sprites[i].x > 1200 || sprites[i].x < 0 || sprites[i].y<0 || sprites[i].y>600) 
				{
					vs[i] = -vs[i];
				}
				//sprites[i].alpha = Math.random();
			}
			
			super.render();

		}
		
	}

}