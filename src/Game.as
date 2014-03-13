package  
{
	import adobe.utils.CustomActions;
	import chaos2D.ChaosEngine;
	import chaos2D.display.ChaoStage;
	import chaos2D.display.DisplayObjectContainer;
	import chaos2D.display.Image;
	import chaos2D.display.Quad;
	import chaos2D.display.Sprite;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import flash.display.Bitmap;
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
		private var sprites:Vector.<Sprite> = new Vector.<Sprite>();
		
		[Embed(source="../texture/flower.png")]
		private var Flower2:Class;
		
		[Embed(source = "../texture/bird.jpg")]
		private var Bird:Class;
		
		
		public function Game() 
		{
			super();
			/*
			TextureCenter.instance.addBitmap("flower", new Flower2());
			TextureCenter.instance.addBitmap("bird", new Bird());

			var tex1:Texture = TextureCenter.instance.getTextureByID("flower");
			var tex2:Texture = TextureCenter.instance.getTextureByID("bird");
			for (var i:int = 0; i < 1000; i++)
			{
				if (Math.random() < 0.4) {
					image = new Image(tex1);
				} else {
					image = new Image(tex2);
				}
				
				addChild(image);
				image.x = Math.random() * 1200;
				image.y = Math.random() * 600;
				images.push(image);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
			}
			*/
			for (var i:int = 0; i < 300; i++)
			{
				var sprite:Sprite = new Sprite("Man");
				addChild(sprite);
				sprite.x = 1200 * Math.random();
				sprite.y = 600 * Math.random();
				sprite.registerPoint = new Point(0.5, 0.5);
				sprites.push(sprite);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
				sprite.scaleX = sprite.scaleY = 0.5;
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < sprites.length; i++) {
				direct = Math.random();
				if (direct > 0.4) {
					sprites[i].x += vs[i];
					sprites[i].rotation++;
				} else {
					sprites[i].y += vs[i];
					sprites[i].rotation--;
				}
				if (sprites[i].x > 1200 || sprites[i].x < 0 || sprites[i].y<0 || sprites[i].y>600) 
				{
					vs[i] = -vs[i];
				}
			}
			
			/*
			for (var i:int = 0; i < images.length; i++) {
				
				direct = Math.random();
				if (direct > 0.4) {
					images[i].x += vs[i];
					images[i].rotation++;
				} else {
					images[i].y += vs[i];
					images[i].rotation--;
				}
				if (images[i].x > 1200 || images[i].x < 0 || images[i].y<0 || images[i].y>600) 
				{
					vs[i] = -vs[i];
				}
			}
			*/

		}
		
	}

}