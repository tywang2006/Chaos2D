package chaos2D.util 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Chao
	 */
	public class Stats extends Sprite 
	{
		
		protected const WIDTH:uint = 70;
		protected const HEIGHT:uint = 80;
		//
		protected var xml:XML;
		protected var text:TextField;
		protected var style:StyleSheet;
		//
		protected var timer:uint;
		protected var fps:uint;
		protected var ms:uint;
		protected var ms_prev:uint;
		protected var mem:Number;
		protected var mem_max:Number = 0;
		//
		public static var vram:uint = 0;
		public static var drw:uint = 0;
		public static var tri:uint = 0;
		//
		protected var theme:Object = {bg: 0x000033, fps: 0xffff00, ms: 0x00ff00, mem: 0x00ffff, memmax: 0xff0070, vram: 0xffffff, drw: 0xffffff, tri: 0xffffff};

		public function Stats(theme:Object = null):void {
			if (!theme)
				theme = this.theme;
			//
			xml = <xml><fps></fps><ms></ms><mem></mem><memMax></memMax><vram></vram><drw></drw><tri></tri></xml>;
			style = new StyleSheet();
			style.setStyle('xml', {fontSize: '9px', fontFamily: '_sans', leading: '-2px'});
			for (var name:String in theme){
				style.setStyle(name, {color: "#" + theme[name].toString(16)});
			}
			//
			text = new TextField();
			text.width = WIDTH;
			text.height = HEIGHT;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			//
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}

		protected function init(e:Event):void {
			graphics.beginFill(theme.bg);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			addChild(text);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected function destroy(e:Event):void {
			graphics.clear();
			removeChildren();
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ENTER_FRAME, update);
		}

		protected function update(e:Event):void {
			timer = getTimer();
			if (timer - 1000 > ms_prev){
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				//
				xml.fps = "FPS: " + fps + " / " + stage.frameRate;
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;
				xml.name = "  Chaos2D"
				//
				fps = 0;
			}
			fps++;
			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			text.htmlText = xml;
			drw = 0;
			tri = 0;
		}

		protected function onClick(e:MouseEvent):void {
			mouseY / height > .5 ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + stage.frameRate;
			text.htmlText = xml;
		}

		public static function setTRI(numTriangles:uint, drwCount:uint = 1):void {
			tri += numTriangles;
			drw += drwCount;
		}
	}

}