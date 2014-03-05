package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
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
		
		public function DisplayObject() 
		{
			_y = _x = 0;
			_width = _height = 0;
			_scaleX = _scaleY = 1;
			_alpha = 1;
			_visible = true;
			_matrix3D = new Matrix3D();
			_registerPoint = new Point(0.5, 0.5);// factor
		}
		
		public function setParent(parent:DisplayObjectContainer):void
		{
			_parent = parent;
		}
		
		public function render():void
		{
			if (_parent) {
				var context:Context2D = ChaosEngine.context;
				context.setMatrix3D(this.matrix3D);
				context.drawTriangle();
			}
		}
		
		private function updateMatrix3D():void
		{
			if (_parent) {
				_matrix3D.identity();
				_matrix3D.appendTranslation(-_registerPoint.x, -_registerPoint.y, 0);
				_matrix3D.appendScale(this.width, this.height, 1);
				_matrix3D.appendRotation(_rotation, Vector3D.Z_AXIS);
				_matrix3D.appendTranslation(_x, _y, 0);
				_matrix3D.appendTranslation(_registerPoint.x, _registerPoint.y, 0);
				_matrix3D.append(_parent.matrix3D);
				_isDirty = false;
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
			if (_isDirty) {
				updateMatrix3D();
			}
			return _matrix3D;
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
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
		
	}

}