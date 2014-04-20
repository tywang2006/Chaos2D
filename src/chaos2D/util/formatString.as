package chaos2D.util 
{
	/**
	 * ...
	 * @author Chao
	 */
	public function formatString(format:String, ...args):String
	{
		var i:int;
		for (i = 0; i < args.length; ++i) {
			format = format.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
		}
		
		return format;
	}

}