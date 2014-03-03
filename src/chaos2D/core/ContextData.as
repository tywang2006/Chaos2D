package chaos2D.core 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class ContextData 
	{
		public static const ELEMENTS_PER_VERTEX:int = 8;
		public static const POSITION_OFFSET:int = 0;
		public static const COLOR_OFFSET:int = 2;
		public static const TEXTURE_COORDS_OFFSET:int = 6;
		
		public var positionData:Vector.<Number>;
		public var colorData:Vector.<Number>;
		public var uvData:Vector.<Number>;
		public var indexData:Vector.<uint>;
		
		public function ContextData() 
		{
			positionData = new Vector.<Number>(2 * 4, true);//x,y
			colorData = new Vector.<Number>(4 * 4, true);//r,g,b,a
			uvData = new Vector.<Number>(2 * 4, true);//uv
			indexData = Vector.<uint>([0, 1, 2, 2, 3, 0]);
			
			setPosition(0, 0, 0);
			setPosition(1, 1, 0);
			setPosition(2, 1, 1);
			setPosition(3, 0, 1);
			
			setUV(0, 0, 0);
			setUV(1, 1, 0);
			setUV(2, 1, 1);
			setUV(3, 0, 1);
		}
		
		private function setPosition(index:uint, xcoord:Number, ycoord:Number):void
		{
			var offset:int = 2 * index;
			positionData[offset] = xcoord;
			positionData[offset + 1] = ycoord;
		}
		
		private function setUV(index:uint, u:Number, v:Number):void
		{
			var offset:int = 2 * index;
			uvData[offset] = u;
			uvData[offset + 1] = v;
		}
		
		public function setColor(index:uint, color:uint):void
		{
			var offset:int = 4 * index;
			
			var alpha:Number = (color >> 24) & 0xFF;
            var r:Number = (color >> 16) & 0xFF
            var g:Number = (color >> 8) & 0xFF;
            var b:Number = (color & 0xFF);
            
            r/=0xFF;
            g/=0xFF;
            b/=0xFF;
            alpha /= 0xFF;
			
			colorData[offset] = r;
			colorData[offset + 1] = g;
			colorData[offset + 2] = b;
			colorData[offset + 3] = alpha;

		}
		
	}

}