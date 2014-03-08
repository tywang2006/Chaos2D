package chaos2D.display 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class DisplayObjectContainer extends DisplayObject 
	{
		private var _children:Vector.<DisplayObject>;
		private var _numChildren:int;
		
		public function DisplayObjectContainer() 
		{
			super();
			_numChildren = 0;
			_children = new Vector.<DisplayObject>();	
		}
		
		override public function render():void 
		{
			super.render();
			var i:int;
			for (i = 0; i < _numChildren; i++) {
				_children[i].render();
			}
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			super.width = value;
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
			updateWidthHeight();
			return child;
		}
		
		public function removeChild(child:DisplayObject):DisplayObject
		{
			var index:int = _children.indexOf(child);
			if (index > -1) {
				child.setParent(null);
				updateWidthHeight();
				return _children.splice(index, 1)[0];
			}
			return null;
		}
		
		public function get numChildren():int 
		{
			return _numChildren;
		}
		
		public function updateWidthHeight():void
		{
			var i:int;
			var child1:DisplayObject;
			var child2:DisplayObject;
			if (_numChildren == 1) {
				child1 = getChildAt(0);
				_width = child1.width * (1 - _registerPoint.x) + child1.x;
				_height = child1.height * (1 - _registerPoint.y) + child1.y;
				return;
			}
			for (i = 0; i < _numChildren - 1; i++) {
				child1 = getChildAt(i);
				child2 = getChildAt(i+1);
				_width = Math.max(child1.width * (1-_registerPoint.x) + child1.x, child2.width * (1-_registerPoint.x) + child2.x);
				_height = Math.max(child1.height * (1-_registerPoint.y) + child1.y, child2.height * (1-_registerPoint.y) + child2.y);
			}
		}
		
	}

}