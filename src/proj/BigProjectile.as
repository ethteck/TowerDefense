package proj
{
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class BigProjectile extends Projectile
	{
		
		public function BigProjectile(twr:Tower, tgt:Enemy, grid:Grid) {
			super(twr, tgt, grid);
			
			moveType = ProjectileMoveType.HOMING;
			
			speed = myGrid.getScale() * 4;
			power = 100;
			critChance = 0.2;
			critMultiplier = 10;
			
			gfx = new BigBulletMC();
			
			setup(twr);
		}
		
	}

}