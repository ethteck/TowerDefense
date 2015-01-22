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
	public /*abstract*/ class Enemy extends Sprite
	{	
		//{ Vars 
		protected var myGrid:Grid;
		
		public var gfx:MovieClip;
		public var healthBarGfx:MovieClip;
		public var healthMeterGfx:MovieClip;
		public var points:Vector.<Point>;
		public var currentPoint:int;
		public var oldDist:Number;
		public var dist:Number;
		public var isAlive:Boolean;
		
		public var xDiff:Number;
		public var yDiff:Number;
		
		public var speed:Number;
		public var hp:Number;
		public var maxHp:int;
		//}
		
		public function setup():void {
			isAlive = true;
			resetLocation(0);
			drawEnemy();
		}
		
		public function resetLocation(numPt:int):void {
			currentPoint = numPt;
			setLocation(points[numPt]);
			
			xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
			yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
			oldDist = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
		}
		
		public function setLocation(pt:Point):void {
			x = myGrid.gridSize * pt.x;
			y = myGrid.gridSize * pt.y;
		}
		
		public function move():void {
			if (points.length > currentPoint + 1) {
				xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
				yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
				var angle:Number = Math.atan2(yDiff, xDiff);
				var xSpeed:Number = speed * Math.cos(angle);
				var ySpeed:Number = speed * Math.sin(angle);
				
				dist = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff))
				gfx.rotation = getRotation(angle);
				
				x += xSpeed;
				y += ySpeed;
				
				if (dist <= speed / 2) {
					x = myGrid.gridSize * points[currentPoint + 1].x;
					y = myGrid.gridSize * points[currentPoint + 1].y;
					loadNextPoint();
					move();
				}
			}
		}
		
		public function drawEnemy():void {
			healthMeterGfx = new MovieClip();
			healthBarGfx = new MovieClip();
			
			gfx.rotation = getRotation();
			addChild(gfx);
			gfx.scaleX = myGrid.getScale();
			gfx.scaleY = myGrid.getScale();
			
			var g:Graphics;
			
			healthMeterGfx.x = -(width / 2);
			healthMeterGfx.y = -(width / 2) - 6;
			g = healthMeterGfx.graphics;
			g.beginFill(0xff0000, 0.6);
			g.drawRect(0, 0, width, 3);
			g.endFill();
			
			healthBarGfx.x = -(width / 2);
			healthBarGfx.y = -(width / 2) - 6;
			g = healthBarGfx.graphics;
			g.beginFill(0x00cc00, 0.8);
			g.drawRect(0, 0, width, 3);
			g.endFill();
			
			addChild(healthMeterGfx);
			addChild(healthBarGfx);
		}
		
		private function getRotation(angle:Number = NaN):Number {
			if (!isNaN(angle)) return angle * 180 / Math.PI + 90;
			
			else {
				xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
				yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
				var dist:Number = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
				var angle:Number = Math.atan2(yDiff, xDiff);
				return angle * 180 / Math.PI + 90;
			}
		}
		
		public function loadNextPoint():void {
			currentPoint ++;
			if (points.length > currentPoint + 1) {
				xDiff = myGrid.gridSize * points[currentPoint + 1].x - x;
				yDiff = myGrid.gridSize * points[currentPoint + 1].y - y;
				oldDist = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
			}
			else {
				isAlive = false;
			}
		}
		
		public function getProgress():Number {
			return (1 - (dist / oldDist)) + currentPoint;
		}
	}
}