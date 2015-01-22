package  
{
	import enem.DifferentEnemy;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class HelperMethods
	{
		public static function getDistance(loc1:Point, loc2:Point):Number {
			var xDiff:Number = loc1.x - loc2.x;
			var yDiff:Number = loc1.y - loc2.y;
			var dist:Number = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
			return dist;
		}
		
		public static function getUnrotatedWidth(obj:Sprite):Number {
			var rot:Number;
			var wid:Number;
			rot = obj.rotation;
			obj.rotation = 0;
			wid = obj.width;
			obj.rotation = rot;
			return wid;
		}
		
		public static function getClass(obj:Object):Class {
			trace(Class(getDefinitionByName(getQualifiedClassName(obj))));
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}