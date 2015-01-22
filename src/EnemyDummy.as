package  
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class EnemyDummy extends Sprite
	{	
		//{ Vars 
		protected var myGrid:Grid;
		
		public var gfx:MovieClip;
		public var points:Vector.<Point>;
		public var currentPoint:int;
		public var dist:Number;
		public var isActive:Boolean;
		
		public var xDiff:Number;
		public var yDiff:Number;
		public var angle:Number;
		public var xSpeed:Number;
		public var ySpeed:Number;
		public var speed:Number;
		
		public var markedPath:Vector.<Point> = new Vector.<Point>();
		//}
		
		public function EnemyDummy(pts:Vector.<Point>, grid:Grid) {
			gfx = new CreepMC();
			points = pts;
			myGrid = grid;
			speed = myGrid.gridSize / 2;
			isActive = true;
			resetLocation(0);
			drawEnemy();
		}
		
		public function resetLocation(numPt:int):void {
			currentPoint = numPt;
			setLocation(points[numPt]);
			
			xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
			yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
		}
		
		public function setLocation(pt:Point):void {
			x = myGrid.gridSize * pt.x;
			y = myGrid.gridSize * pt.y;
		}
		
		public function move():void {
			markedPath.push(myGrid.getGridPoint(x, y));
			
			if (points[currentPoint + 1]){
				xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
				yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
				angle = Math.atan2(yDiff, xDiff);
				var xSpeed:Number = speed * Math.cos(angle);
				var ySpeed:Number = speed * Math.sin(angle);
				dist = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff))
				x += xSpeed;
				y += ySpeed;
				
				if (dist <= speed * 1.5) {
					x = myGrid.gridSize * points[currentPoint + 1].x;
					y = myGrid.gridSize * points[currentPoint + 1].y;
					
					if (points.length > currentPoint + 2) {
						loadNextPoint();
					}
					else {
						isActive = false;
					}
				}
				
				if (isActive) {
					checkSurroundingSquares()
				}
			}
		}
		
		private function checkSurroundingSquares():void {
			var halfWid:Number = width / 2;
			if (x - halfWid < myGrid.getPixelValue(x)) {
				markedPath.push(new Point(myGrid.getGridValue(x - myGrid.gridSize), myGrid.getGridValue(y)));;
			}
			if (x + halfWid > myGrid.getPixelValue(x) + myGrid.gridSize) {
				markedPath.push(new Point(myGrid.getGridValue(x + myGrid.gridSize), myGrid.getGridValue(y)));
			}
			if (y - halfWid < myGrid.getPixelValue(y)) {
				markedPath.push(new Point(myGrid.getGridValue(x), myGrid.getGridValue(y - myGrid.gridSize)));
			}
			if (y + halfWid > myGrid.getPixelValue(y) + myGrid.gridSize) {
				markedPath.push(new Point(myGrid.getGridValue(x), myGrid.getGridValue(y + myGrid.gridSize)));
			}
			if (x + halfWid > myGrid.getPixelValue(x) + myGrid.gridSize && y - halfWid < myGrid.getPixelValue(y)) {
				markedPath.push(new Point(myGrid.getGridValue(x + myGrid.gridSize), myGrid.getGridValue(y - myGrid.gridSize)));
			}
			if (x - halfWid < myGrid.getPixelValue(x) && y - halfWid < myGrid.getPixelValue(y)) {
				markedPath.push(new Point(myGrid.getGridValue(x - myGrid.gridSize), myGrid.getGridValue(y - myGrid.gridSize)));
			}
			if (x + halfWid > myGrid.getPixelValue(x) + myGrid.gridSize && y + halfWid > myGrid.getPixelValue(y) + myGrid.gridSize) {
				markedPath.push(new Point(myGrid.getGridValue(x + myGrid.gridSize), myGrid.getGridValue(y + myGrid.gridSize)));
			}
			if (x - halfWid < myGrid.getPixelValue(x) && y + halfWid > myGrid.getPixelValue(y) + myGrid.gridSize) {
				markedPath.push(new Point(myGrid.getGridValue(x - myGrid.gridSize), myGrid.getGridValue(y + myGrid.gridSize)));
			}
		}
		
		private function drawEnemy():void {
			addChild(gfx);
			gfx.scaleX = myGrid.getScale();
			gfx.scaleY = myGrid.getScale();
		}
		
		public function loadNextPoint():void {
			currentPoint ++;
			xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
			yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
		}
	}
}