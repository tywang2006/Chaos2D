package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.Texture;
	import chaos2D.util.MatrixUtil;
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
	public class DisplayObjectContainer extends DisplayObject 
	{
		protected var _children:Vector.<DisplayObject>;
		protected var _numChildren:int;
		
		private static var _helperMatrix:Matrix = new Matrix();
		private static var _helperPoint:Point = new Point();
		
		public function DisplayObjectContainer() 
		{
			super();
			_numChildren = 0;
			_children = new Vector.<DisplayObject>();	
		}
		
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle 
		{
			if (resultRect == null) resultRect = new Rectangle();
			if (_numChildren == 0) {
				getTransformationMatrix(targetSpace, _helperMatrix);
				MatrixUtil.transformCoords(_helperMatrix, 0, 0, _helperPoint);
				resultRect.setTo(_helperPoint.x, _helperPoint.y, 0, 0);
			} else if (_numChildren == 1) {
				resultRect = _children[0].getBounds(targetSpace, resultRect);
			} else {
				var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
                var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
				var i:int;
				for (i = 0; i < _numChildren; i++) {
					_children[i].getBounds(targetSpace, resultRect);
					minX = minX < resultRect.x ? minX : resultRect.x;
                    maxX = maxX > resultRect.right ? maxX : resultRect.right;
                    minY = minY < resultRect.y ? minY : resultRect.y;
                    maxY = maxY > resultRect.bottom ? maxY : resultRect.bottom;
				}
				resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
			}
			return resultRect;
		}
		
		override public function render(customizeTexture:Texture = null, uv:VertexBuffer3D = null):void 
		{
			super.render();
			var i:int;
			for (i = 0; i < _numChildren; i++) {
				_children[i].render();
			}
		}
		
		public function getChildAt(index:int):DisplayObject 
		{
			if (index > _numChildren) throw "index is out of number of children";
			return _children[index]
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			_children.push(child);
			_numChildren++;
			child.setParent(this);
			return child;
		}
		
		public function removeChild(child:DisplayObject):DisplayObject
		{
			var index:int = _children.indexOf(child);
			if (index > -1) {
				child.setParent(null);
				return _children.splice(index, 1)[0];
			}
			return null;
		}
		
		override protected function updateMatrix3D():void 
		{
			if (_parent) {
				if (_matrix3D == null) _matrix3D = new Matrix3D();
				_matrix3D.identity();
				_matrix3D.appendTranslation(-_registerPoint.x, -_registerPoint.y, 0);
				_matrix3D.appendScale(this.scaleX, this.scaleY, 1);
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
		
		override public function get height():Number 
		{
			if (_children.length == 0) return 0;
			var corners:Vector.<Point> = this.getCornerPoints();
			var i:int, top:Number = 0, bottom:Number = 0;
			for (i = 0; i < corners.length; i++) {
				top = (top < corners[i].y)?top:corners[i].y;
				bottom = (bottom > corners[i].y)?bottom:corners[i].y;
			}

			return bottom - top;
		}
		
		override public function set height(value:Number):void 
		{
			var tmV:Number = this.height;
			if (tmV == value) return;
			_scaleY = value / (tmV / _scaleY);
			_isDirty = true;
		}
		
		override public function getCornerPoints(m3d:Matrix3D = null):Vector.<Point> 
		{
			var helpMatrix3D:Matrix3D = m3d == null?_matrix3D:m3d;
			var points:Vector.<Point> = new Vector.<Point>();
			if(helpMatrix3D) {
				var i:int;
				for (i = 0; i < _numChildren; i++) {
					points = points.concat(_children[i].getCornerPoints(_children[i].matrix3D));
				}
			}
			return points;
		}
		
		override public function get width():Number 
		{
			if (_children.length == 0) return 0;
			var corners:Vector.<Point> = this.getCornerPoints();
			var i:int, left:Number, right:Number;
			for (i = 0; i < corners.length; i++) {
				left = (left < corners[i].x)?left:corners[i].x;
				right = (right > corners[i].x)?right:corners[i].x;
			}

			return right - left;
		}
		
		override public function set width(value:Number):void 
		{
			var tmV:Number = this.width;
			if (tmV == value) return;
			_scaleX = value / (tmV / _scaleX);
			_isDirty = true;
		}
		
		public function get numChildren():int 
		{
			return _numChildren;
		}
		
	}

}