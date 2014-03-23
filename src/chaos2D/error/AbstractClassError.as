package chaos2D.error 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class AbstractClassError extends Error
    {
        /** Creates a new AbstractClassError object. */
        public function AbstractClassError(message:*="Cannot instantiate abstract class", id:*=0)
        {
            super(message, id);
        }
    }

}