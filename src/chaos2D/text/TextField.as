package chaos2D.text 
{
	import chaos2D.display.DisplayObject;
	import chaos2D.display.DisplayObjectContainer;
	import chaos2D.display.Image;
	import chaos2D.texture.BitmapTexture;
	import chaos2D.texture.Texture;
	import chaos2D.texture.TextureCenter;
	import chaos2D.util.deg2rad;
	import chaos2D.util.getNextPowerOfTwo;
	import chaos2D.util.HAlign;
	import chaos2D.util.VAlign;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.display3D.VertexBuffer3D;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Chao
	 */
	public class TextField extends DisplayObjectContainer 
	{
		
		private var _fontSize:Number;
		private var _text:String;
		private var _hAlign:String;
		private var _vAlign:String;
		private var _bold:Boolean;
		private var _autoSize:String;
		private var _hitArea:Rectangle;
		private var _fontName:String;
		private var _italic:Boolean;
		private var _underline:Boolean;
		private var _kerning:Boolean;
		private var _nativeTextField:flash.text.TextField = new flash.text.TextField();
		private var _nativeFilters:Array;
		private var _resultTextBounds:Rectangle;
		private var _textBounds:Rectangle;
		private var _image:Image;
		private var _requresRedraw:Boolean = true;
		private var _autoScale:Boolean;
		
		public function TextField(width:int, height:int, text:String, fontName:String = "Verdana", fontSize:Number=12, color:uint=0x0,bold:Boolean=false) 
		{
			_text = text?text:"";
			_fontSize = fontSize;
			_color = color;
			_hAlign = HAlign.CENTER;
			_vAlign = VAlign.CENTER;
			_bold = bold;
			_autoSize = TextureFieldAutoSize.NONE;
			_hitArea = new Rectangle(0, 0, width, height);
			_fontName = fontName;
			
		}
		
		public function dispose():void
		{
			if (_image) BitmapTexture(_image.texture).dispose();
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			if (_requresRedraw) redraw();
			super.render(customizeTexture, uv);
		}
		
		public function redraw():void
		{
			if (_requresRedraw) {
				createRenderedContents();
				_requresRedraw = false;
			}
		}
		
		private function createRenderedContents():void
		{
			if (_textBounds == null) {
				_textBounds = new Rectangle();
			}
			var bitmapData:BitmapData = renderText(1, _textBounds);
			_hitArea.width = bitmapData.width;
			_hitArea.height = bitmapData.height;
			
			var texture:Texture = TextureCenter.instance.addBitmapData(getTimer().toString(), bitmapData);
			bitmapData.dispose();
			
			if (_image == null) {
				_image = new Image(texture);
				addChild(_image);
			} else {
				BitmapTexture(_image.texture).dispose();
				_image.texture = texture;
			}
		}
		
		public function renderText(scale:Number, resultTextBounds:Rectangle):BitmapData
		{
			var width:Number = _hitArea.width * scale;
			var height:Number = _hitArea.height * scale;
			var hAlign:String = _hAlign;
			var vAlign:String = _vAlign;
			
			if (this.isHorizontalAutoSize) {
				_width = int.MAX_VALUE;
				hAlign = HAlign.LEFT;
			}
			if (this.isVerticalAutoSize) {
				_height = int.MAX_VALUE;
				vAlign = VAlign.TOP;
			}
			
			var textFormat:TextFormat = new TextFormat(_fontName, _fontSize * scale, _color, _bold, _italic, _underline, null, null, _hAlign);
			textFormat.kerning = _kerning;
			_nativeTextField.defaultTextFormat = textFormat;
			_nativeTextField.width = width;
			_nativeTextField.height = height;
			_nativeTextField.antiAliasType = AntiAliasType.ADVANCED;
			_nativeTextField.selectable = false;
			_nativeTextField.multiline = true;
			_nativeTextField.wordWrap = true;
			_nativeTextField.text = _text;
			_nativeTextField.filters = _nativeFilters;
			
			if (_nativeTextField.textWidth == 0.0 || _nativeTextField.textHeight == 0.0) _nativeTextField.embedFonts = false;
			formatText(_nativeTextField, textFormat);
			
			if (_autoScale) autoScaleNativeTextField(_nativeTextField);
			
			var textWidth:Number = _nativeTextField.textWidth;
			var textHeight:Number = _nativeTextField.textHeight;
			
			if (isHorizontalAutoSize)_nativeTextField.width = width = Math.ceil(textWidth + 5);
			if (isVerticalAutoSize)_nativeTextField.height = height = Math.ceil(textHeight + 4);
			
			if (width < 1) width = 1.0;
			if (height < 1) height = 1.0;
			
			var textOffsetX:Number = 0.0;
			if (hAlign == HAlign.LEFT) textOffsetX = 2;
			else if (hAlign == HAlign.CENTER) textOffsetX = (width - textWidth) / 2.0;
			else if (hAlign == HAlign.RIGHT) textOffsetX = width - textWidth - 2;
			
			var textOffsetY:Number = 0.0;
			if (vAlign == VAlign.TOP) textOffsetY = 2;
			else if (vAlign == VAlign.CENTER) textOffsetY = (height - textHeight) / 2.0;
			else if (vAlign == VAlign.BOTTOM) textOffsetY = height - textHeight - 2;
			
			var filterOffset:Point = calculateFilterOffset(_nativeTextField, hAlign, vAlign);
			var bitmapData:BitmapData = new BitmapData(getNextPowerOfTwo(width), getNextPowerOfTwo(height), true, 0x0);
			var drawMatrix:Matrix = new Matrix(1, 0, 0, 1, filterOffset.x, filterOffset.y + int(textOffsetY) - 2);
			var drawWithQualityFunc:Function = "drawWithQuality" in bitmapData?bitmapData["drawWithQuality"]:null;
			
			if (drawWithQualityFunc is Function) {
				drawWithQualityFunc.call(bitmapData, _nativeTextField, drawMatrix, null, null, null, false, StageQuality.MEDIUM);
			} else {
				bitmapData.draw(_nativeTextField, drawMatrix);
			}
			_nativeTextField.text = "";
			resultTextBounds.setTo((textOffsetX + filterOffset.x) / scale, (textOffsetY + filterOffset.y) / scale, textWidth / scale, textHeight / scale);
			
			return bitmapData;
		}
		
		private function calculateFilterOffset(textField:flash.text.TextField,
                                               hAlign:String, vAlign:String):Point
        {
            var resultOffset:Point = new Point();
            var filters:Array = textField.filters;
            
            if (filters != null && filters.length > 0)
            {
                var textWidth:Number  = textField.textWidth;
                var textHeight:Number = textField.textHeight;
                var bounds:Rectangle  = new Rectangle();
                
                for each (var filter:BitmapFilter in filters)
                {
                    var blurX:Number    = "blurX"    in filter ? filter["blurX"]    : 0;
                    var blurY:Number    = "blurY"    in filter ? filter["blurY"]    : 0;
                    var angleDeg:Number = "angle"    in filter ? filter["angle"]    : 0;
                    var distance:Number = "distance" in filter ? filter["distance"] : 0;
                    var angle:Number = deg2rad(angleDeg);
                    var marginX:Number = blurX * 1.33; // that's an empirical value
                    var marginY:Number = blurY * 1.33;
                    var offsetX:Number  = Math.cos(angle) * distance - marginX / 2.0;
                    var offsetY:Number  = Math.sin(angle) * distance - marginY / 2.0;
                    var filterBounds:Rectangle = new Rectangle(
                        offsetX, offsetY, textWidth + marginX, textHeight + marginY);
                    
                    bounds = bounds.union(filterBounds);
                }
                
                if (hAlign == HAlign.LEFT && bounds.x < 0)
                    resultOffset.x = -bounds.x;
                else if (hAlign == HAlign.RIGHT && bounds.y > 0)
                    resultOffset.x = -(bounds.right - textWidth);
                
                if (vAlign == VAlign.TOP && bounds.y < 0)
                    resultOffset.y = -bounds.y;
                else if (vAlign == VAlign.BOTTOM && bounds.y > 0)
                    resultOffset.y = -(bounds.bottom - textHeight);
            }
            
            return resultOffset;
        }
		
		private function autoScaleNativeTextField(textField:flash.text.TextField):void
		{
			var size:Number = Number(textField.defaultTextFormat.size);
			var maxHeight:int = textField.height - 4;
			var maxWidth:int = textField.width - 4;
			while (textField.textWidth > maxWidth || textField.textHeight > maxHeight) {
				if (size <= 4) break;
				var format:TextFormat = textField.defaultTextFormat;
				format.size == size--;
				textField.setTextFormat(format);
			}
		}
		
		protected function formatText(textField:flash.text.TextField, textFormat:TextFormat):void { }
		
		override public function get width():Number { return _hitArea.width; }
		override public function set width(value:Number):void 
		{
			_hitArea.width = value;
			_requresRedraw = true;
		}
		
		override public function get height():Number { return _hitArea.height; }
		override public function set height(value:Number):void 
		{
			_hitArea.height = value;
			_requresRedraw = true;
		}
		
		public function get text():String { return _text; }
        public function set text(value:String):void
        {
            if (value == null) value = "";
            if (_text != value) {
                _text = value;
                _requresRedraw = true;
            }
        }
		
		public function get fontName():String { return _fontName; }
        public function set fontName(value:String):void
        {
            if (_fontName != value) {
                _fontName = value;
                _requresRedraw = true;
            }
        }
		
		public function get fontSize():Number { return _fontSize; }
        public function set fontSize(value:Number):void
        {
            if (_fontSize != value) {
                _fontSize = value;
                _requresRedraw = true;
            }
        }
		
		public function get hAlign():String { return _hAlign; }
        public function set hAlign(value:String):void
        {
            if (!HAlign.isValid(value))
                throw new ArgumentError("Invalid horizontal align: " + value);
            
            if (_hAlign != value)
            {
                _hAlign = value;
                _requresRedraw = true;
            }
        }
        
        /** The vertical alignment of the text. @default center @see starling.utils.VAlign */
        public function get vAlign():String { return _vAlign; }
        public function set vAlign(value:String):void
        {
            if (!VAlign.isValid(value))
                throw new ArgumentError("Invalid vertical align: " + value);
            
            if (_vAlign != value)
            {
                _vAlign = value;
                _requresRedraw = true;
            }
        }
		
		public function get bold():Boolean { return _bold; }
        public function set bold(value:Boolean):void 
        {
            if (_bold != value)
            {
                _bold = value;
                _requresRedraw = true;
            }
        }
		
		public function get italic():Boolean { return _italic; }
        public function set italic(value:Boolean):void
        {
            if (_italic != value)
            {
                _italic = value;
                _requresRedraw = true;
            }
        }
		
		public function get underline():Boolean { return _underline; }
        public function set underline(value:Boolean):void
        {
            if (_underline != value)
            {
                _underline = value;
                _requresRedraw = true;
            }
        }
        

        public function get kerning():Boolean { return _kerning; }
        public function set kerning(value:Boolean):void
        {
            if (_kerning != value)
            {
                _kerning = value;
                _requresRedraw = true;
            }
        }
        

        public function get autoScale():Boolean { return _autoScale; }
        public function set autoScale(value:Boolean):void
        {
            if (_autoScale != value)
            {
                _autoScale = value;
                _requresRedraw = true;
            }
        }
		
		public function get autoSize():String { return _autoSize; }
        public function set autoSize(value:String):void
        {
            if (_autoSize != value)
            {
                _autoSize = value;
                _requresRedraw = true;
            }
        }
		
		public function get nativeFilters():Array { return _nativeFilters; }
        public function set nativeFilters(value:Array) : void
        {
            _nativeFilters = value.concat();
            _requresRedraw = true;
        }
		
		public function get isHorizontalAutoSize():Boolean
		{
			return _autoSize == TextureFieldAutoSize.VERTICAL || TextureFieldAutoSize.BOTH_DIRECTIONS;
		}
		
		public function get isVerticalAutoSize():Boolean
		{
			return _autoSize == TextureFieldAutoSize.HORIZONTAL || TextureFieldAutoSize.BOTH_DIRECTIONS
		}
		
	}

}