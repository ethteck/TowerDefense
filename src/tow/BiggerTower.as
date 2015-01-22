package tow
{
	import flash.geom.Point;
	import proj.BigProjectile;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	
	public final class BiggerTower extends Tower
	{
		public static var m_gfxClass:Class = TowerThreeMC;
		public static var m_area:Point = new Point(2, 1);
		public static var m_projectileType:Class = BigProjectile;
		public static var m_targetMethod:int = TargetMethod.PROGRESSMOST;
		public static var m_shootInterval:int = 40;
		public static var m_range:int = 10;
		
		public function BiggerTower(pt:Point, grid:Grid) {
			super();
			
			gfx = new m_gfxClass;
			area = m_area;
			projectileType = m_projectileType;
			targetMethod = m_targetMethod;
			shootInterval = m_shootInterval;
			range = m_range;
			
			setup(pt, grid);
		}
	}
}