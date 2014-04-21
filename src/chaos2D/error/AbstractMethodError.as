package chaos2D.error 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class AbstractMethodError extends Error
	{
		
		public function AbstractMethodError(message:*="Methord instantiate abstract class", id:*=0)
        {
            super(message, id);
        }
		
	}

}