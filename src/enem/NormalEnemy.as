package enem
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class NormalEnemy extends Enemy
	{
		
		public function NormalEnemy(pts:Vector.<Point>, grid:Grid) {
			super();
			
			points = pts;
			myGrid = grid;
			speed = myGrid.getScale() * 1; //3
			hp = 100;
			maxHp = hp;
			gfx = new CreepMC();
			
			setup();
		}
		
	}

}