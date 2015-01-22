package  
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class Grid extends Sprite {
		public var gameHeight:int;
		public var gameWidth:int;
		
		public var gridSize:int;
		public var gridReference:int;
		
		public var gfx:Sprite;
		
		public function Grid(gw:int, gh:int, size:int) {
			gfx = new Sprite();
			
			gameWidth = gw;
			gameHeight = gh;
			gridSize = size;
			gridReference = 25;
		}
		
		public function drawGrid():void {
			var gridGraphics:Graphics = gfx.graphics;
			gridGraphics.lineStyle(1, 0x333333);
            for (var i:int = 0; i < getGridWidth(); i++) {
                gridGraphics.moveTo(i * gridSize, 0);
                gridGraphics.lineTo(i * gridSize, gameHeight);
            }
            for (i = 0; i < getGridHeight(); i++) {
                gridGraphics.moveTo(0, i * gridSize);
                gridGraphics.lineTo(gameWidth, i * gridSize);
            }
			addChild(gfx);
		}
		
		public function getScale(num:Number = 1):Number {
			return num * (gridSize / gridReference);
		}
		
		public function getGridPoint(x:int, y:int):Point {
			//Takes a pixel coord and returns a grid point (4,3)
			var xLoc:int = getGridValue(x);
			var yLoc:int = getGridValue(y);
			return new Point(xLoc, yLoc);
		}
		
		public function getGridValue(val:int):int {
			//Takes a pixel value and returns its grid point.
			return Math.floor(val / gridSize);
		}
		
		public function getPixelPoint(x:int, y:int):Point {
			//Takes a pixel coord and returns its nearest grid location in pixels. (125,40)
			var xLoc:int = getPixelValue(x);
			var yLoc:int = getPixelValue(y);
			return new Point(xLoc, yLoc);
		}
		
		public function getPixelValue(val:int):int {
			//Takes a pixel value and returns its nearest grid location in pixels.
			return gridSize * Math.floor(val / gridSize);
		}
		
		public function getGridWidth():int {
			return Math.ceil(gameWidth / gridSize);
		}
		
		public function getGridHeight():int {
			return Math.ceil(gameHeight / gridSize);
		}
		
	}

}