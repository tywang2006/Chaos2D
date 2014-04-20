package chaos2D.events 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Chao
	 */
	public class ResizeEvent extends Event 
	{
		
		public function ResizeEvent(type:String, width:int, height:int, bubbles:Boolean=false)
        {
        	super(type, bubbles, new Point(width, height));
        }
		
		/** The updated width of the player. */
        public function get width():int { return (data as Point).x; }
        
        /** The updated height of the player. */
        public function get height():int { return (data as Point).y; }
		
	}

}