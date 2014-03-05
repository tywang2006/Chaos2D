package chaos2D.util.data 
{
	/**
	 * ...
	 * @author Chao
	 */
	public class SpriteSheetParser 
	{
		public static const XML_TYPE:String = "xml";
		public static const JSON_TYPE:String = "json";
		public static const PLIST_TYPE:String = "plist";
		
		public function SpriteSheetParser() 
		{
			
		}
		
		public static function parse(data:String, type:String = "XML"):void
		{
			switch(type) {
				case XML_TYPE: parseXML(data); break;
				case JSON_TYPE: parseJSON(data); break;
				case PLIST_TYPE: parsePLIST(data); break;
			}
		}
		
		static private function parsePLIST(data:String):void 
		{
			
		}
		
		static private function parseJSON(data:String):void 
		{
			
		}
		
		static private function parseXML(data:String):void 
		{
			
		}
		
	}

}