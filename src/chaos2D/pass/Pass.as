package chaos2D.pass 
{
	/**
	 * a class to do customized shader
	 * @author Chao
	 */
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;

	public class Pass
	{
		protected static const agal:AGALMiniAssembler = new AGALMiniAssembler();
		protected var _shaderVertex:String;
		protected var _shaderFragment:String;
		protected var _program:Program3D;
		protected var _context:Context3D;
		protected var _isRenderToTexture:Boolean;
		protected var _texture:Texture;
		
		public function Pass(context:Context3D, isRenderToTexture:Boolean, width:Number=1, height:Number=1)
		{
			_context = context;
			_isRenderToTexture = isRenderToTexture;
			if(_isRenderToTexture) _texture = _context.createTexture(width, height, Context3DTextureFormat.BGRA, true);
		}
		
		public function assemble():void
		{
			var vertexShader:ByteArray = agal.assemble(Context3DProgramType.VERTEX, _shaderVertex);
			var fragmentShader:ByteArray = agal.assemble(Context3DProgramType.FRAGMENT, _shaderFragment);
			_program = _context.createProgram();
			_program.upload(vertexShader, fragmentShader);
		}
		
		public function render(iBuffer:IndexBuffer3D) : void {
			if(!_isRenderToTexture) _context.setRenderToBackBuffer();
			else    _context.setRenderToTexture(_texture, false, 1);
			
			_context.clear(0, 0, 0, 1);
			_context.setProgram(_program);
			_context.drawTriangles(iBuffer);
		}
		
		public function getTexture() : Texture {    return _texture;    }

}