package chaos2D.core 
{
	import chaos2D.texture.BitmapTexture;
	import flash.accessibility.ISearchableText;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Chao
	 */
	public class Context2D 
	{
		private var _context3D:Context3D;
		private var _programs:Dictionary;
		private var _projectMatrix:Matrix3D;
		private var _rawData:ContextData;
		private var _vertexUVBuffer:VertexBuffer3D;
		private var _vertexPositionBuffer:VertexBuffer3D;
		private var _vertexColorBuffer:VertexBuffer3D;
		private var _alphaBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _currentProgram:Program3D;
		
		
		public function Context2D(context3D:Context3D) 
		{
			_context3D = context3D;
			_context3D.enableErrorChecking = false
			_programs = new Dictionary();
			_rawData = new ContextData();
			
			createVertexAndIndexBuffer();
			setVertexBufferForPosition();
		}
		public function setAlphaBlend():void
		{
			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		}
		
		public function setProjection(stageWidth:Number, stageHeight:Number):void
		{
			_projectMatrix = new Matrix3D(Vector.<Number>([2/stageWidth,0,0,0,0,-2/stageHeight,0,0,0,0,0,0,-1,1,0,1]));
		}
		
		public function setMatrix3D(m:Matrix3D):void 
		{
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
		}
		
		public function setAlphaBuffer(alpha:Number):void
		{
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([alpha,alpha,alpha,alpha]));
		}
		
		public function setColorConstant(color:Number):void
		{
			_rawData.setColor(0, color);
			_rawData.setColor(1, color);
			_rawData.setColor(2, color);
			_rawData.setColor(3, color);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _rawData.colorData);
		}
		
		public function setVertexBufferForPosition():void
		{
			_context3D.setVertexBufferAt(0, _vertexPositionBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		} 
		
		public function setVertexBufferForColor(color:uint, changed:Boolean):void
		{
			if (changed)
			{
				_rawData.setColor(0, color);
				_rawData.setColor(1, color);
				_rawData.setColor(2, color);
				_rawData.setColor(3, color);
				_vertexColorBuffer && _vertexColorBuffer.dispose();
				_vertexColorBuffer = _context3D.createVertexBuffer(4, 4);
				_vertexColorBuffer.uploadFromVector(_rawData.colorData, 0, 4);
				_context3D.setVertexBufferAt(1, _vertexColorBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			}
			
		}
		
		public function getVertexBufferByUV(uv:Vector.<Number>, texture:flash.display3D.textures.Texture):VertexBuffer3D
		{
			var vertexBuffer:VertexBuffer3D = _context3D.createVertexBuffer(4, 2);
			vertexBuffer.uploadFromVector(uv, 0, 4);
			return vertexBuffer;
		}
		
		public function setVertexBufferForTexture(texture:flash.display3D.textures.Texture):void
		{
			_context3D.setTextureAt(0, texture);
			_context3D.setVertexBufferAt(2, _vertexUVBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function setCustomizeVertexBufferForTexture(vertexBuffer:VertexBuffer3D, texture:flash.display3D.textures.Texture):void
		{
			_context3D.setTextureAt(0, texture);
			_context3D.setVertexBufferAt(2, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function drawTriangle():void
		{
			_context3D.drawTriangles(_indexBuffer, 0, 2);
		}
		
		public function clear():void
		{
			_context3D.clear(0, 0, 0, 1);
		}
		
		public function clearBufferForQuad():void
		{
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
		}
		
		public function clearBufferForImage():void
		{
			_context3D.setTextureAt(0, null);
			//_context3D.setVertexBufferAt(0,null);
			_context3D.setVertexBufferAt(1,null);
			_context3D.setVertexBufferAt(2,null);
		}
		
		public function clearBufferForSprite():void
		{
			_context3D.setTextureAt(0, null);
			_context3D.setVertexBufferAt(2,null);
		}
		
		public function present():void
		{
			_context3D.present();
		}
		
		public function setProgram(programName:String):void
		{
			var program:Program3D = getProgram(programName);
			if (_currentProgram != program)
			{
				_context3D.setProgram(program);
				_context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
				_context3D.setCulling(Context3DTriangleFace.BACK);
				_currentProgram = program;
			}
		}
		
		public function registerProgram(name:String, vertexProgram:ByteArray, fragmentProgram:ByteArray):void
		{
			if (_programs[name]) {
				trace("Context2D: the program with the same name is existing");
				return;
			}
			var program:Program3D = _context3D.createProgram();
			program.upload(vertexProgram, fragmentProgram);
			_programs[name] = program;
		}
		
		public function getProgram(name:String):Program3D
		{
			return _programs[name] as Program3D;
		}
		
		private function createVertexAndIndexBuffer():void
		{
			_vertexPositionBuffer = _context3D.createVertexBuffer(4, 2);
			_vertexColorBuffer = _context3D.createVertexBuffer(4, 4);
			_vertexUVBuffer = _context3D.createVertexBuffer(4, 2);
			_indexBuffer = _context3D.createIndexBuffer(_rawData.indexData.length);
			_vertexPositionBuffer.uploadFromVector(_rawData.positionData, 0, 4);
			_vertexColorBuffer.uploadFromVector(_rawData.colorData, 0, 4);
			_vertexUVBuffer.uploadFromVector(_rawData.uvData, 0, 4);
			_indexBuffer.uploadFromVector(_rawData.indexData, 0, _rawData.indexData.length);
		}
		
		public function get projectMatrix():Matrix3D 
		{
			return _projectMatrix;
		}
		
		public function createTexture(data:*,mipMapping:Boolean):chaos2D.texture.Texture
		{
			var base:Texture;
			var ret:chaos2D.texture.Texture;
			if(data is BitmapData || data is Bitmap)
			{
				base = _context3D.createTexture(data.width,data.height,Context3DTextureFormat.BGRA,false);
				ret = new BitmapTexture(base,data,mipMapping);
			}
			return ret;
		}
		
	}

}