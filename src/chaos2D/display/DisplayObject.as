package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.texture.Texture;
	import flash.display.Stage;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Chao
	 */
	public class DisplayObject 
	{
		protected var _x:Number;
		protected var _y:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _visible:Boolean;
		protected var _alpha:Number;
		protected var _matrix3D:Matrix3D;
		protected var _parent:DisplayObjectContainer;
		protected var _stage:Stage;
		protected var _rotation:Number = 0;
		protected var _isDirty:Boolean = false;
		protected var _registerPoint:Point;
		protected var _tinted:Boolean = false;
		protected var _color:Number = -1;
		protected var _blendMode:String = BlendMode.AUTO;
		
		public function DisplayObject() 
		{
			_y = _x = 0;
			_width = _height = 1;
			_scaleX = _scaleY = 1;
			_alpha = 1;
			_visible = true;
			//_matrix3D = new Matrix3D();
			_registerPoint = new Point(0, 0);// factor
		}
		
		public function getBound(targetCoordinateSpace:DisplayObject):Rectangle
		{
			var targetMatrix:Matrix = targetCoordinateSpace.matrix;
			if (targetCoordinateSpace.parent && targetMatrix) {
				var matrix:Matrix = this.matrix;
				var msx:Number = matrix.a * Math.pow(matrix.a * matrix.a + matrix.b * matrix.b, 0.5) / Math.abs(matrix.a);
				var msy:Number = matrix.d * Math.pow(matrix.c * matrix.c + matrix.d * matrix.d, 0.5) / Math.abs(matrix.d);
				var tmsx:Number = targetMatrix.a * Math.pow(targetMatrix.a * targetMatrix.a + targetMatrix.b * targetMatrix.b, 0.5) / Math.abs(matrix.a);
				var tmsy:Number = targetMatrix.d * Math.pow(targetMatrix.c * targetMatrix.c + targetMatrix.d * targetMatrix.d, 0.5) / Math.abs(targetMatrix.d);
				var left:Number = (matrix.tx - targetMatrix.tx - _registerPoint.x * msx) * tmsx;
				var right:Number = (matrix.ty - targetMatrix.ty - _registerPoint.y * msy) * tmsy;
				
				return new Rectangle(left, right, msx * tmsx, msy * tmsy);
			}
			return null;
		}
		
		public function setParent(parent:DisplayObjectContainer):void
		{
			_parent = parent;
		}
		
		public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void
		{
			if (_parent) {
				var context:Context2D = ChaosEngine.context;
				if (this.color>=0) context.setColorConstant(this.color);
				context.setAlphaBuffer(this.alpha * _parent.alpha);
				context.setMatrix3D(this.matrix3D);
				context.drawTriangle();
			}
		}
		
		private function updateMatrix3D():void
		{
			if (_parent) {
				if (_matrix3D == null) _matrix3D = new Matrix3D();
				_matrix3D.identity();
				_matrix3D.appendTranslation(-_registerPoint.x, -_registerPoint.y, 0);
				_matrix3D.appendScale(this.width, this.height, 1);
				_matrix3D.appendRotation(_rotation, Vector3D.Z_AXIS);
				_matrix3D.appendTranslation(_x, _y, 0);
				_matrix3D.appendTranslation(_registerPoint.x, _registerPoint.y, 0);
				_matrix3D.append(_parent.matrix3D);
				_isDirty = false;
			} else {
				_matrix3D = null;
			}
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			if (_x == value) return;
			_x = value;
			_isDirty = true;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			if (_y == value) return;
			_y = value;
			_isDirty = true;
		}
		
		public function get width():Number 
		{
			return _width * _scaleX;
		}
		
		public function set width(value:Number):void 
		{
			if (_width == value) return;
			_scaleX = value / _width;
			_isDirty = true;
		}
		
		public function get height():Number 
		{
			return _height * _scaleY;
		}
		
		public function set height(value:Number):void 
		{
			if (_height == value) return;
			_scaleY = value / _height;
			_isDirty = true;
		}
		
		public function get scaleX():Number 
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void 
		{
			if(_scaleX == value) return;
			_scaleX = value;
			_isDirty = true;
		}
		
		public function get scaleY():Number 
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void 
		{
			if(_scaleY == value) return;
			_scaleY = value;
			_isDirty = true;
		}
		
		public function get matrix3D():Matrix3D 
		{
			updateMatrix3D();
			return _matrix3D;
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			if (_alpha == value) return;
			_alpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value); 
		}
		
		public function get visible():Boolean 
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void 
		{
			_visible = value;
		}
		
		public function get parent():DisplayObjectContainer 
		{
			return _parent;
		}
		
		public function get stage():Stage 
		{
			return _stage;
		}
		
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void 
		{
			if (value == _rotation) return;
			_rotation = value;
			_isDirty = true;
		}
		
		public function set registerPoint(value:Point):void 
		{
			_registerPoint = value;
		}
		
		public function get color():Number 
		{
			if (_parent && _parent.tinted) {
				return _parent.color;
			}
			return _color;
		}
		
		public function set color(value:Number):void 
		{
			if (_color == value) return;
			if (value >= 0) _tinted = true;
			_color = value;
		}
		
		public function get tinted():Boolean
		{
			return _tinted;
		}
		
		public function get blendMode():String 
		{
			if (_parent && _parent.blendMode && _blendMode == BlendMode.AUTO) {
				return _parent.blendMode;
			}
			return _blendMode;
		}
		
		public function set blendMode(value:String):void 
		{
			if (_blendMode == value) return;
			_blendMode = value;
		}
		
		public function get matrix():Matrix
		{
			var m3d:Matrix3D = this.matrix3D;
			if(m3d) {
				var raw:Vector.<Number> = m3d.rawData;
				var a:Number = raw[0];
				var b:Number = raw[1];
				var c:Number = raw[4];
				var d:Number = raw[5];
				var tx:Number = raw[12];
				var ty:Number = raw[13];
				return new Matrix(a, b, c, d, tx, ty);
			}
			return null;
			
		}
		
		
	}

}