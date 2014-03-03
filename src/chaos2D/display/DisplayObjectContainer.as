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
		
		public function get numChildren():int 
		{
			return _numChildren;
		}
		
	}

}