package tow
{
	import flash.geom.Point;
	import proj.SimpleProjectile;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class OtherTower extends Tower
	{
		public static var m_gfxClass:Class = TowerTwoMC;
		public static var m_area:Point = new Point(1, 1);
		public static var m_projectileType:Class = SimpleProjectile;
		public static var m_targetMethod:int = TargetMethod.DISTANCELEAST;
		public static var m_shootInterval:int = 1;
		public static var m_range:int = 10;
		
		public function OtherTower(pt:Point, grid:Grid) {
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