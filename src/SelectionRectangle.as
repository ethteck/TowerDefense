package {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public final class SelectionRectangle extends Sprite {
		public var rectGfx:Shape;
		public var startX:int;
		public var startY:int;
		public var active:Boolean;
		
		public var selectedTowers:Vector.<Tower>;
		public var selectedTowersOld:Vector.<Tower>;
		
		public function SelectionRectangle() {
			rectGfx = new Shape();
		}
		
		public function start(sx:int, sy:int):void{
			active = true;
			
			rectGfx = new Shape();
			rectGfx.graphics.lineStyle(1, 0xFFFFFF, 1);
			rectGfx.graphics.beginFill(0xFFFFFF, 0.4);
			rectGfx.graphics.drawRect(0,0,0,0);
			rectGfx.graphics.endFill();
			startX = sx;
			startY = sy;
			
			addChild(rectGfx);
		}
		
		public function update(newX:int, newY:int):void {
			removeChild(rectGfx);
			
			rectGfx = new Shape();
			rectGfx.x = startX;
			rectGfx.y = startY;
			rectGfx.graphics.lineStyle(1, 0xFFFFFF, 1);
			rectGfx.graphics.beginFill(0xFFFFFF, 0.4);
			rectGfx.graphics.drawRect(0, 0, newX - startX, newY - startY);
			rectGfx.graphics.endFill();
			
			addChild(rectGfx);
		}
		
		public function removeAllChildren():void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
	}
}
