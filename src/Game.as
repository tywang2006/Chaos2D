package  
{
	import adobe.utils.CustomActions;
	import chaos2D.ChaosEngine;
	import chaos2D.display.ChaoStage;
	import chaos2D.display.DisplayObject;
	import chaos2D.display.DisplayObjectContainer;
	import chaos2D.display.Image;
	import chaos2D.display.Quad;
	import chaos2D.display.Sprite;
	import chaos2D.text.TextField;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import flash.display.Bitmap;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Point;
	
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
		
		
		public function Game() 
		{
			super();
			//new Quad(100,100,0xFFFFFFFF*Math.random())
			//new Sprite("square")
			
			var t:Texture = TextureCenter.instance.addBitmap("Bird", new Bird(), false);
			
			for (var i:int = 0; i < 1000; i++)
			{
				//var sprite:DisplayObject = (Math.random() > 0.7)?new Quad(100, 100, 0xFFFFFFFF * Math.random()):(Math.random() > 0.3)?new Sprite("square"):new Image(t);
				var sprite:DisplayObject = new Sprite("square");
				sprite.color = 0xFFFFFFFF*Math.random();
				addChild(sprite);
				sprite.x = 1200 * Math.random();
				sprite.y = 600 * Math.random();
				sprite.registerPoint = new Point(0.5, 0.5);
				sprite.scaleX = sprite.scaleY = 2*(Math.random() - 0.5);
				sprites.push(sprite);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
			}
			
			/*
			var tt:TextField = new TextField(100, 100, "superman", "Verdana",60,0xFFFFFFFF);
			addChild(tt)
			*/
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			super.render();
			return
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
				sprites[i].alpha = Math.random();
			}

		}
		
	}

}