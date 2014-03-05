package  
{
	import chaos2D.ChaosEngine;
	import chaos2D.display.ChaoStage;
	import chaos2D.display.DisplayObjectContainer;
	import chaos2D.display.Image;
	import chaos2D.display.Quad;
	import chaos2D.texture.Texture;
	import flash.display.Bitmap;
	
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
		
		[Embed(source="../texture/flower.png")]
		private var Flower2:Class;
		
		public function Game() 
		{
			super();
			/*
			var q:Quad;
			var s:Number;
			for (var i:int = 0; i < 1000; i++)
			{
				s = 50 * Math.random();
				q = new Quad(s, s, 0xFFFFFFFF * Math.random());
				q.x = Math.random() * 800;
				q.y = Math.random() * 600;
				addChild(q);
				quads.push(q);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
			}
			*/
			
			for (var i:int = 0; i < 1000; i++)
			{
				var flower:Bitmap = new Flower2() as Bitmap;
				var tex:Texture = ChaosEngine.context.createTexture(flower, false) as Texture;
				image = new Image(tex);
				
				addChild(image);
				image.x = Math.random() * 800;
				image.y = Math.random() * 600;
				images.push(image);
				vs.push((Math.random() - 0.5) * 100);
				ds.push(Math.random())
			}
	
		}
		
		override public function render():void 
		{
			super.render();
			for (var i:int = 0; i < images.length; i++) {
				
				direct = Math.random();
				if (direct > 0.4) {
					images[i].x += vs[i]
				} else {
					images[i].y += vs[i];
				}
				if (images[i].x > 800 || images[i].x < 0 || images[i].y<0 || images[i].y>600) 
				{
					vs[i] = -vs[i];
				}
				//images[i].rotation+=direct;
			}
			/*
			for (var i:int = 0; i < quads.length; i++) {
				
				direct = Math.random();
				if (direct > 0.4) {
					quads[i].x += vs[i]
				} else {
					quads[i].y += vs[i];
				}
				if (quads[i].x > 800 || quads[i].x < 0 || quads[i].y<0 || quads[i].y>600) 
				{
					vs[i] = -vs[i];
				}
				
				quads[i].rotation+=direct;
				quads[i].color = 0xFFFFFFFF * Math.random();
			}
			*/
		}
		
	}

}