package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public /*abstract*/ class Projectile extends Sprite
	{
		//{ Vars
		public var myGrid:Grid;
		
		public var gfx:MovieClip;
		public var moveType:int;
		public var xSpeed:Number;
		public var ySpeed:Number;
		public var target:Enemy;
		public var targetMethod:int;
		public var speed:Number;
		public var power:Number;
		public var range:Number;
		public var critChance:Number;
		public var critMultiplier:Number;
		public var isActive:Boolean;
		private var scale:Number;
		//}
		
		public function Projectile(twr:Tower, tgt:Enemy, grid:Grid) {
			myGrid = grid;
			range = twr.range;
			targetMethod = twr.targetMethod;
			target = tgt;
		}
		
		public function setup(tower:Tower):void {
			mouseEnabled = false;
			mouseChildren = false;
			
			drawBullet(tower);
			isActive = true;
		}
		
		private function drawBullet(tower:Tower):void {
			x = tower.x + tower.gfx.width / 2;
			y = tower.y + tower.gfx.height / 2;
			addChild(gfx);
			gfx.scaleX = myGrid.getScale();
			gfx.scaleY = myGrid.getScale();
		}
		
		public function move():void {
			switch (moveType) {
				case ProjectileMoveType.NORMAL:
					moveNormalProjectile();
					break;
				case ProjectileMoveType.HOMING:
					moveHomingProjectile();
					break;
				case ProjectileMoveType.SUPERHOMING:
					moveSuperhomingProjectile();
					break;
				default:
					moveNormalProjectile();
			}
			
			x += xSpeed;
			y += ySpeed;
			
			if (outofBounds() && isActive) {
				isActive = false;
			}
		}
		
		private function moveNormalProjectile():void {
			if (isNaN(xSpeed) || isNaN(ySpeed)){
				calculateSpeed();
			}
		}
		
		private function moveHomingProjectile():void {
			if (target.isAlive || isNaN(xSpeed) || isNaN(ySpeed)){
				calculateSpeed();
			}
		}
		
		private function moveSuperhomingProjectile():void {
			if (target == null || !target.isAlive) {
				if (target != null) {
					var tmpTarg:Enemy = target;
				}
				target = TargetManager.obtainTargetFromProjectile(this);
				if (target == null) {
					target = tmpTarg;
				}
			}
			if (target.isAlive || isNaN(xSpeed) || isNaN(ySpeed)) {
				calculateSpeed();
			}
		}
		
		private function calculateSpeed():void {
			var xDist:Number = target.x - x;
			var yDist:Number = target.y - y;
			var angle:Number = Math.atan2(yDist, xDist);
			xSpeed = speed * Math.cos(angle);
			ySpeed = speed * Math.sin(angle);
		}
		
		private function outofBounds():Boolean {
			if (x < -width || x > TowerDefense(parent).gameWidth + width || y < -height || y > TowerDefense(parent).gameHeight + height) {
				return true;
			}
			return false;
		}
	}
}