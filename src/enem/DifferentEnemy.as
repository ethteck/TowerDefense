package enem
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class DifferentEnemy extends Enemy
	{
		
		public function DifferentEnemy(pts:Vector.<Point>, grid:Grid) {
			super();
			
			points = pts;
			myGrid = grid;
			speed = myGrid.getScale() * 3;
			hp = 200;
			maxHp = hp;
			gfx = new BossMC();
			
			setup();
		}
		
	}

}