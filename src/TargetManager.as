package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class TargetManager 
	{	
		public static function obtainTargetFromProjectile(proj:Projectile):Enemy {
			var possibleTargets:Vector.<Enemy> = new Vector.<Enemy>();
			for (var i:int = 0; i < TowerDefense(proj.parent).enemies.length; i++) {
				//maybe set TowerDefense(proj.parent).enemies[i] to a variable
				if (inProjectileRange(proj, TowerDefense(proj.parent).enemies[i]) && TowerDefense(proj.parent).enemies[i].isAlive) { 
					possibleTargets.push(TowerDefense(proj.parent).enemies[i]);
				}                      
			}
			if (possibleTargets.length == 0) {
				return null;
			}
			return findBestTarget(possibleTargets, proj.range, proj.targetMethod, new Point(proj.x, proj.y));
		}
		
		public static function obtainTargetFromTower(tow:Tower):Enemy {
			var possibleTargets:Vector.<Enemy> = new Vector.<Enemy>();
			for (var i:int = 0; i < TowerDefense(tow.parent).enemies.length; i++) {
				//maybe set TowerDefense(tow.parent).enemies[i] to a variable
				if (inTowerRange(tow, TowerDefense(tow.parent).enemies[i]) && TowerDefense(tow.parent).enemies[i].isAlive) {
					possibleTargets.push(TowerDefense(tow.parent).enemies[i]);
				}                      
			}
			if (possibleTargets.length == 0) {
				return null;
			}
			if (possibleTargets.length == 1) {
				return possibleTargets[0];
			}
			return findBestTarget(possibleTargets, tow.range, tow.targetMethod, new Point(tow.x, tow.y)); 
		}
		
		public static function findBestTarget(targets:Vector.<Enemy>, range:Number, targetMethod:int, loc:Point):Enemy {
			var ret:Enemy;
			switch (targetMethod) {
				case TargetMethod.PROGRESSMOST:
					ret = getTargetByMostProgress(targets);
					break;
				case TargetMethod.PROGRESSLEAST:
					ret = getTargetByLeastProgress(targets);
					break;
				case TargetMethod.HEALTHMOST:
					ret = getTargetByMostHealth(targets);
					break;
				case TargetMethod.HEALTHLEAST:
					ret = getTargetByLeastHealth(targets);
					break;
				case TargetMethod.DISTANCELEAST:
					ret = getTargetByDistanceLeast(targets, loc);
					break;
				case TargetMethod.DISTANCEMOST:
					ret = getTargetByDistanceMost(targets, loc);
					break;
				case TargetMethod.SPEEDMOST:
					ret = getTargetByMostSpeed(targets);
					break;
				case TargetMethod.SPEEDLEAST:
					ret = getTargetByLeastSpeed(targets);
					break;
				case TargetMethod.AGEMOST:
					ret = targets[0];
					break;
				case TargetMethod.AGELEAST:
					ret = targets[targets.length - 1];
					break;
				case TargetMethod.LEVELMOST:
					ret = null; //ADD THIS LATER
					break;
				case TargetMethod.LEVELLEAST:
					ret = null; //ADD THIS LATER
					break;
				default:
					ret = null;
					break;
			}
			return ret;
		}
		
		private static function getTargetByMostProgress(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {	
				if (targets[i].getProgress() > ret.getProgress()) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByLeastProgress(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {	
				if (targets[i].getProgress() < ret.getProgress()) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByMostHealth(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {	
				if (targets[i].hp > ret.hp) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByLeastHealth(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {	
				if (targets[i].hp < ret.hp) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByDistanceLeast(targets:Vector.<Enemy>, loc:Point):Enemy { 
			var ret:Enemy = targets[0];
			var currentDist:Number = HelperMethods.getDistance(loc, new Point(ret.x, ret.y));
			var tmpDist:Number;
			for (var i:int = 0; i < targets.length; i++) {
				tmpDist = HelperMethods.getDistance(loc, new Point(targets[i].x, targets[i].y));
				if (tmpDist < currentDist) {
					currentDist = tmpDist;
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByDistanceMost(targets:Vector.<Enemy>, loc:Point):Enemy { 
			var ret:Enemy = targets[0];
			var currentDist:Number = HelperMethods.getDistance(loc, new Point(ret.x, ret.y));
			var tmpDist:Number;
			for (var i:int = 0; i < targets.length; i++) {
				tmpDist = HelperMethods.getDistance(loc, new Point(targets[i].x, targets[i].y));
				if (tmpDist > currentDist) {
					currentDist = tmpDist;
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByMostSpeed(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {
				if (targets[i].speed > ret.speed) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		private static function getTargetByLeastSpeed(targets:Vector.<Enemy>):Enemy { 
			var ret:Enemy = targets[0];
			for (var i:int = 0; i < targets.length; i++) {	
				if (targets[i].speed < ret.speed) {
					ret = targets[i];
				}
			}
			return ret;
		}
		
		public static function inProjectileRange(proj:Projectile, target:Enemy):Boolean {
			if (HelperMethods.getDistance(new Point(proj.x, proj.y), new Point(target.x, target.y)) <= proj.range) {
				return true;
			}
			return false;
		}
		
		public static function inTowerRange(tow:Tower, target:Enemy):Boolean {
			if (HelperMethods.getDistance(new Point(tow.x, tow.y), new Point(target.x, target.y)) <= tow.range) {
				return true;
			}
			return false;
		}
	}

}