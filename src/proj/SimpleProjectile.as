package proj
{
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class SimpleProjectile extends Projectile
	{
		
		public function SimpleProjectile(twr:Tower, tgt:Enemy, grid:Grid) {
			super(twr, tgt, grid);
			
			moveType = ProjectileMoveType.SUPERHOMING;
			
			speed = myGrid.getScale() * 5;
			power = 0.1;
			critChance = 0.2;
			critMultiplier = 1.5;
			
			gfx = new BulletMC();
			
			setup(twr);
		}
		
	}

}