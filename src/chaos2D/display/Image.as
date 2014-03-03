package chaos2D.display 
{
	import chaos2D.texture.Texture;
	/**
	 * ...
	 * @author Chao
	 */
	public class Image extends Quad 
	{
		
		public function Image(texture:Texture) 
		{
			if (texture) {
				super(texture.width, texture.height, 0xFFFF0000);
			} else {
				throw ArgumentError("Image: texture can't be NULL!");
			}
			
		}
		
		override public function render():void 
		{
			super.render();
		}
		
		override public function set color(value:uint):void 
		{
			throw ArgumentError("Image: texture can't be set to be a color!");
		}
		
	}

}