package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.core.Context2D;
	import chaos2D.error.AbstractMethodError;
	import chaos2D.events.EventDispatcher;
	import chaos2D.texture.Texture;
	import chaos2D.util.MatrixUtil;
	import com.adobe.utils.PerspectiveMatrix3D;
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
	public class DisplayObject extends EventDispatcher
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
		protected var _localMatrix:Matrix3D;
		protected var _realWidth:Number = 0;
		protected var _realHeight:Number = 0;
		
		private static var _ancestors:Vector.<DisplayObject> = new <DisplayObject>[];
        private static var _helperRect:Rectangle = new Rectangle();
        private static var _helperMatrix:Matrix  = new Matrix();
		
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
		
		
		public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle
		{
			throw new AbstractMethodError();
		}
		
		public function getTransformationMatrix(targetSpace:DisplayObject, resultMatrix:Matrix = null):Matrix
		{
			var commonParent:DisplayObject;
			var currentObject:DisplayObject;
			if (resultMatrix) resultMatrix.identity();
			else resultMatrix = new Matrix();
			
			if (targetSpace == this) return resultMatrix;
			else if (targetSpace == _parent || (targetSpace == null && _parent == null)) {
				resultMatrix = currentObject.matrix;
				return resultMatrix;
			} else if (targetSpace == null || targetSpace == base) {
				currentObject = this;
				while (currentObject != targetSpace) {
					resultMatrix.concat(currentObject.matrix);
					currentObject = currentObject.parent;
				}
				
				return resultMatrix;
			} else if (currentObject.parent == this) {
				targetSpace.getTransformationMatrix(this, resultMatrix);
				resultMatrix.invert();
				return resultMatrix;
			}
			
			commonParent = null;
			currentObject = this;
			while (currentObject) {
				_ancestors[_ancestors.length] = currentObject;
				currentObject = currentObject.parent;
			}
			
			currentObject = targetSpace;
			while (currentObject && _ancestors.indexOf(currentObject) == -1) {
				currentObject = currentObject.parent;
			}
			_ancestors.length = 0;
			if (currentObject) commonParent = currentObject;
			else throw new ArgumentError("Object not connected to target");
			
			currentObject = this;
			while (currentObject != commonParent) {
				resultMatrix.concat(currentObject.matrix);
				currentObject = currentObject.parent;
			}
			
			_helperMatrix.invert();
			resultMatrix.concat(_helperMatrix);
			
			return resultMatrix;
		}
		
		public function setParent(parent:DisplayObjectContainer):void
		{
			_parent = parent;
		}
		
		public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void
		{
			if (_parent && _width * _scaleX > 0 && _height * _scaleY > 0) {
				var context:Context2D = ChaosEngine.context;
				if (this.color>=0) context.setColorConstant(this.color);
				context.setAlphaBuffer(this.alpha * _parent.alpha);
				context.setMatrix3D(this.matrix3D);
				context.drawTriangle();
			}
		}
		
		protected function updateMatrix3D():void
		{
			if (_parent && _width > 0 && _scaleX > 0 && _height > 0 && _scaleY > 0) {
				if (_matrix3D == null) _matrix3D = new Matrix3D();
				_matrix3D.identity();
				_matrix3D.appendTranslation(-_registerPoint.x, -_registerPoint.y, 0);
				_matrix3D.appendScale(_width * _scaleX, _height * _scaleY, 1);
				_matrix3D.appendRotation(_rotation, Vector3D.Z_AXIS);
				_matrix3D.appendTranslation(_x, _y, 0);
				_matrix3D.appendTranslation(_registerPoint.x, _registerPoint.y, 0);
				_localMatrix = _matrix3D.clone();
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
			updateMatrix3D();
			//_isDirty = true;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			if (_y == value) return;
			updateMatrix3D();
			_y = value;
			//_isDirty = true;
		}
		
		public function get width():Number 
		{
			var points:Vector.<Point> = getCornerPoints();
			var i:int;
			var len:int = points.length;
			var left:Number = 0;
			var right:Number = 0;
			for (i = 0; i < len; i++) {
				left = left < points[i].x?left:points[i].x;
				right = right > points[i].x?right:points[i].x;
			}
			_realWidth = right - left;
			return _realWidth;
		}
		
		public function getCornerPoints(m3d:Matrix3D = null):Vector.<Point> 
		{
			var m:Matrix = m3d==null?this.matrix:MatrixUtil.convertTo2D(m3d);
			if (m) {
				var topLeft:Point = matrix.transformPoint(new Point(0, 0));
				var topRight:Point = matrix.transformPoint(new Point(1, 0));
				var bottomLeft:Point = matrix.transformPoint(new Point(0, 1));
				var bottomRight:Point = matrix.transformPoint(new Point(1, 1));
				return Vector.<Point>([topLeft, topRight, bottomRight, bottomLeft]);
			} else {
				var p:Point = new Point();
				return Vector.<Point>([p,p,p,p]);
			}
		}
		
		public function set width(value:Number):void 
		{
			if (_width == value) return;
			_scaleX = value / _width;
			_isDirty = true;
		}
		
		public function get height():Number 
		{
			var points:Vector.<Point> = getCornerPoints();
			var i:int;
			var len:int = points.length;
			var top:Number = 0;
			var bottom:Number = 0;
			for (i = 0; i < len; i++) {
				top = top < points[i].y?top:points[i].y;
				bottom = bottom > points[i].y?bottom:points[i].y;
			}
			_realHeight = bottom - top;
			return _realHeight;
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
			var m3d:Matrix3D = _localMatrix;
			if(m3d) {
				return MatrixUtil.convertTo2D(m3d);
			}
			return null;
			
		}
		
		public function get base():DisplayObject
        {
            var currentObject:DisplayObject = this;
            while (currentObject.parent) currentObject = currentObject.parent;
            return currentObject;
        }
		
		
	}

}