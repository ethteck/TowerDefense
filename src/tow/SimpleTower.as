package tow
{
	import flash.geom.Point;
	import proj.SimpleProjectile;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class SimpleTower extends Tower
	{
		public static var m_gfxClass:Class = TowerMC;
		public static var m_area:Point = new Point(1, 1);
		public static var m_projectileType:Class = SimpleProjectile;
		public static var m_targetMethod:int = TargetMethod.PROGRESSMOST;
		public static var m_shootInterval:int = 15;
		public static var m_range:int = 5;
		public function SimpleTower(pt:Point, grid:Grid) {
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