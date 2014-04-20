package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import chaos2D.texture.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Chao
	 */
	public class DisplayObjectContainer extends DisplayObject 
	{
		protected var _children:Vector.<DisplayObject>;
		protected var _numChildren:int;
		
		public function DisplayObjectContainer() 
		{
			super();
			_numChildren = 0;
			_children = new Vector.<DisplayObject>();	
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
				_matrix3D.append(_parent.matrix3D);
				_isDirty = false;
			} else {
				_matrix3D = null;
			}
		}
		
		override public function get height():Number 
		{
			if (_children.length == 0) return 0;
			var top:Number = 0;
			var bottom:Number = 0;
			var i:int;
			var len:int = this.numChildren;
			var tmV:Number;
			for (i = 0; i < len; i++) {
				tmV = _children[i].y + _children[i].height;
				top = (top < _children[i].y)?top:_children[i].y;
				bottom = (bottom > tmV)?bottom:tmV;
			}
			
			return (bottom - top) * scaleY;
		}
		
		override public function set height(value:Number):void 
		{
			var tmV:Number = this.height;
			if (tmV == value) return;
			_scaleY = value / (tmV / _scaleY);
		}
		
		override public function get width():Number 
		{
			if (_children.length == 0) return 0;
			var left:Number = 0;
			var right:Number = 0;
			var i:int;
			var len:int = this.numChildren;
			var tmV:Number;
			for (i = 0; i < len; i++) {
				tmV = _children[i].x + _children[i].width;
				left = (left < _children[i].x)?left:_children[i].x;
				right = (right > tmV)?right:tmV;
			}
			
			return (right - left) * scaleX;
		}
		
		override public function set width(value:Number):void 
		{
			var tmV:Number = this.width;
			if (tmV == value) return;
			_scaleX = value / (tmV / _scaleX);
		}
		
		public function get numChildren():int 
		{
			return _numChildren;
		}
		
	}

}