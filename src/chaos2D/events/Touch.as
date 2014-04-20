package chaos2D.events 
{
	import chaos2D.core.chaos2D_internal;
	import chaos2D.display.DisplayObject;
	import chaos2D.util.formatString;
	import chaos2D.util.MatrixUtil;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	use namespace chaos2D_internal;
	/**
	 * ...
	 * @author Chao
	 */
	public class Touch 
	{
		private var _id:int;
		private var _tapCount:int;
		private var _phase:String;
		private var _pressure:Number;
		private var _width:Number;
		private var _height:Number;
		private var _bubbleChain:Vector.<EventDispatcher>;
		private var _timestamp:Number;
		private var _globalX:Number;
		private var _globalY:Number;
		private var _width:Number;
		private var _height:Number;
		private var _target:DisplayObject;
		private var _previousGlobalX:Number;
		private var _previousGlobalY:Number;
		
		private static var _helperMatrix:Matrix = new Matrix();
		
		
		public function Touch(id:int) 
		{
			_id = id;
			_tapCount = 0;
			_phase = TouchPhase.HOVER;
			_pressure = _width = _height = 1.0;
			_bubbleChain = new Vector.<EventDispatcher>();
		}
		
		public function getLocation(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            space.base.getTransformationMatrix(space, _helperMatrix);
            return MatrixUtil.transformCoords(_helperMatrix, _globalX, _globalY, resultPoint); 
        }
		
		public function getPreviousLocation(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            space.base.getTransformationMatrix(space, _helperMatrix);
            return MatrixUtil.transformCoords(_helperMatrix, _previousGlobalX, _previousGlobalY, resultPoint);
        }
		
		public function getMovement(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            getLocation(space, resultPoint);
            var x:Number = resultPoint.x;
            var y:Number = resultPoint.y;
            getPreviousLocation(space, resultPoint);
            resultPoint.setTo(x - resultPoint.x, y - resultPoint.y);
            return resultPoint;
        }
		
		public function isTouching(target:DisplayObject):Boolean
        {
            return _bubbleChain.indexOf(target) != -1;
        }
		
		public function toString():String
        {
            return formatString("Touch {0}: globalX={1}, globalY={2}, phase={3}",
                                _id, _globalX, _globalY, _phase);
        }
		
		public function clone():Touch
        {
            var clone:Touch = new Touch(_id);
            clone._globalX = _globalX;
            clone._globalY = _globalY;
            clone._previousGlobalX = _previousGlobalX;
            clone._previousGlobalY = _previousGlobalY;
            clone._phase = _phase;
            clone._tapCount = _tapCount;
            clone._timestamp = _timestamp;
            clone._pressure = _pressure;
            clone._width = _width;
            clone._height = _height;
            clone._target = _target;
            return clone;
        }
		
		private function updateBubbleChain():void
        {
            if (_target) {
                var len:int = 1;
                var element:DisplayObject = _target;
                
                _bubbleChain.length = 1;
                _bubbleChain[0] = element;
                
                while ((element = element.parent) != null)
                    _bubbleChain[int(len++)] = element;
            } else {
                _bubbleChain.length = 0;
            }
        }
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get previousGlobalX():Number 
		{
			return _previousGlobalX;
		}
		
		public function get previousGlobalY():Number 
		{
			return _previousGlobalY;
		}
		
		public function get globalX():Number 
		{
			return _globalX;
		}
		
		public function set globalX(value:Number):void 
		{
			_previousGlobalX = _globalX != _globalX ? value : _globalX; // isNaN check
            _globalX = value;
		}
		
		public function get globalY():Number 
		{
			return _globalY;
		}
		
		public function set globalY(value:Number):void 
		{
			_previousGlobalY = _globalY != _globalY ? value : _globalY; // isNaN check
            _globalY = value;
		}
		
		public function get tapCount():int 
		{
			return _tapCount;
		}
		
		public function set tapCount(value:int):void 
		{
			_tapCount = value;
		}
		
		public function get phase():String 
		{
			return _phase;
		}
		
		public function set phase(value:String):void 
		{
			_phase = value;
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void 
		{
			if (_target != value) {
				_target = value;
				updateBubbleChain();
			}
			
		}
		
		public function get timestamp():Number 
		{
			return _timestamp;
		}
		
		public function set timestamp(value:Number):void 
		{
			_timestamp = value;
		}
		
		public function get pressure():Number 
		{
			return _pressure;
		}
		
		public function set pressure(value:Number):void 
		{
			_pressure = value;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		//test private internal
		internal function dispatchEvent(event:TouchEvent):void
        {
            if (_target) event.dispatch(_bubbleChain);
        }
        
        /** @private */
        internal function get bubbleChain():Vector.<EventDispatcher>
        {
            return _bubbleChain.concat();
        }
		
	}

}