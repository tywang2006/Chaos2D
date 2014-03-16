package chaos2D.util.data.layout 
{
	import chaos2D.util.data.FrameDataObject;
	/**
	 * ...
	 * @author Chao
	 */
	public class SpriteSheetPacker 
	{
		public var root:Object;
		public var maxWidth:Number;
		public var maxHeight:Number;
		
		public function fit(blocks:Vector.<FrameDataObject>):void
		{
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(Math.random() - 0.5); } );
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.width - a.width); } );
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.height - a.height); } );
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(Math.max(b.width, b.height) - Math.max(a.width, a.height)); })
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(Math.min(b.width, b.height) - Math.min(a.width, a.height)); })
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.width*b.height - a.width*a.height); })
			
			//a,h,w
			//blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.width * b.height - a.width * a.height); } )
			blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(Math.max(b.width, b.height) - Math.max(a.width, a.height)); })
			blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(Math.min(b.width, b.height) - Math.min(a.width, a.height)); })
			blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.height - a.height); } );
			blocks.sort(function(a:FrameDataObject, b:FrameDataObject):Boolean { return Boolean(b.width - a.width); } );
			
			maxWidth = maxHeight = 0;
			
			var n:int, node:Object, block:FrameDataObject, len:int = blocks.length;
			var w:Number = len > 0 ? blocks[0].width : 0;
			var h:Number = len > 0 ? blocks[0].height : 0;
			this.root = { x: 0, y: 0, w: w, h: h };
			for (n = 0; n < len ; n++) {
				block = blocks[n];
				node = this.findNode(this.root, block.width, block.height)
				if (node != null)
					block.fit = this.splitNode(node, block.width, block.height);
				else
					block.fit = this.growNode(block.width, block.height);
				maxWidth = Math.max(block.fit.x + block.width, maxWidth);
				maxHeight = Math.max(block.fit.y + block.height, maxHeight);
			}
		}
		
		private function findNode(root:Object, w:Number, h:Number):Object 
		{
			if (root.used)
				return this.findNode(root.right, w, h) || this.findNode(root.down, w, h);
			else if ((w <= root.w) && (h <= root.h))
				return root;

			return null;
		}
  
		private function splitNode(node:Object, w:Number, h:Number):Object 
		{
			node.used = true;
			node.down  = { x: node.x,     y: node.y + h, w: node.w,     h: node.h - h };
			node.right = { x: node.x + w, y: node.y,     w: node.w - w, h: h          };
			return node;
		}
		
		private function growNode(w:Number, h:Number):Object
		{
			var canGrowDown:Boolean  = (w <= this.root.w);
			var canGrowRight:Boolean = (h <= this.root.h);

			var shouldGrowRight:Boolean = canGrowRight && (this.root.h >= (this.root.w + w)); // attempt to keep square-ish by growing right when height is much greater than width
			var shouldGrowDown:Boolean  = canGrowDown  && (this.root.w >= (this.root.h + h)); // attempt to keep square-ish by growing down  when width  is much greater than height

			if (shouldGrowRight)
				return this.growRight(w, h);
			else if (shouldGrowDown)
				return this.growDown(w, h);
			else if (canGrowRight)
				return this.growRight(w, h);
			else if (canGrowDown)
				return this.growDown(w, h);
			
			return null; // need to ensure sensible root starting size to avoid this happening
		}
		
		private function growRight(w:Number, h:Number):Object 
		{
			this.root = {
				used: true,
				x: 0,
				y: 0,
				w: this.root.w + w,
				h: this.root.h,
				down: this.root,
				right: { x: this.root.w, y: 0, w: w, h: this.root.h }
			};
			
			var node:Object = this.findNode(this.root, w, h);
			if (node != null)
				return this.splitNode(node, w, h);

			return null;
		}
  
		private function growDown(w:Number, h:Number):Object 
		{
			this.root = {
				used: true,
				x: 0,
				y: 0,
				w: this.root.w,
				h: this.root.h + h,
				down:  { x: 0, y: this.root.h, w: this.root.w, h: h },
				right: this.root
			};
			var node:Object = this.findNode(this.root, w, h);
			if (node != null)
				return this.splitNode(node, w, h);
				
			return null;
		}
	}

}