package chaos2D.display 
{
	import chaos2D.ChaosEngine;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Chao
	 */
	public class ChaoStage extends DisplayObjectContainer 
	{
		
		public function ChaoStage() 
		{
			super();
		}
		
		override public function render():void 
		{
			super.render();
		}
		
		override public function get matrix3D():Matrix3D 
		{
			return ChaosEngine.context.projectMatrix;
		}
		
		override public function get x():Number 
		{
			return undefined;
		}
		
		override public function set x(value:Number):void 
		{
			throw "ChaoStage is not available for matrx"
		}
		
		override public function get y():Number 
		{
			return undefined;
		}
		
		override public function get scaleX():Number 
		{
			return undefined;
		}
		
		override public function set scaleX(value:Number):void 
		{
			throw "ChaoStage is not available for matrx"
		}
		
		override public function get scaleY():Number 
		{
			return undefined;
		}
		
		override public function set scaleY(value:Number):void 
		{
			throw "ChaoStage is not available for matrx"
		}
		
	}

}