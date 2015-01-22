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
	public /*abstract*/ class Tower extends Sprite
	{
		//{ Vars
		public var myGrid:Grid;
		
		public var gfx:MovieClip;
		public var rangeGfx:MovieClip;
		
		public var area:Point;
		public var projectileType:Class;
		public var readyToShoot:Boolean;
		public var shootTime:int;
		public var shootInterval:int;
		public var target:Enemy;
		
		public var range:Number;
		
		public var targetMethod:int;
		public var targetLock:Boolean = false;
		//}
		
		public function setup(pt:Point, grid:Grid):void {
			myGrid = grid;
			rangeGfx = new MovieClip()
			shootTime = shootInterval;
			readyToShoot = false;
			range *= grid.gridSize;
			
			drawTower(pt);
			drawRange();
			
			rangeGfx.mouseEnabled = false;
			rangeGfx.mouseChildren = false;
			mouseEnabled = false;
		}
		
		protected function drawTower(pt:Point):void {
			x = myGrid.gridSize * pt.x + (2 * myGrid.getScale());
			y = myGrid.gridSize * pt.y + (2 * myGrid.getScale());
			gfx.width = area.x * myGrid.gridSize - (2 * myGrid.getScale());
			gfx.height = area.y * myGrid.gridSize - (2 * myGrid.getScale());
			gfx.name = "mcTower";
			addChild(gfx);
		}
		
		protected function drawRange():void {
			rangeGfx.graphics.lineStyle(1, 0xFFFFFF, 1);
			rangeGfx.graphics.beginFill(0xFFFFFF, 0.15);
			rangeGfx.graphics.drawCircle(0, 0, range);
			rangeGfx.graphics.endFill();
			rangeGfx.visible = false;
			rangeGfx.x = width / 2;
			rangeGfx.y = width / 2;
			addChild(rangeGfx);
		}
		
		public function shoot():Projectile {
			if (targetLock) {
				if (!targetIsValid()) {
					target = TargetManager.obtainTargetFromTower(this);
				}
			}
			else {
				target = TargetManager.obtainTargetFromTower(this);
			}
			
			if (target != null) {
				shootTime = shootInterval;
				readyToShoot = false;
				
				return new projectileType(this, target, myGrid);
			}
			return null;
		}
		
		protected function targetIsValid():Boolean {
			if (target == null || target.isAlive || !TargetManager.inTowerRange(this, target)) {
				return false;
			}
			return true;
		}
	}
}