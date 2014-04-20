package chaos2D.events 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class EnterFrameEvent extends Event 
	{
		public static const ENTER_FRAME:String = "enterFrame";
		
		public function EnterFrameEvent(type:String, passedTime:Number, bubbles:Boolean=false) 
		{
			super(type, bubbles, passedTime);
		}
		
		public function get passedTime():Number { return data as Number; }
		
	}

}