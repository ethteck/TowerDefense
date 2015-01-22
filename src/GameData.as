package {
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class GameData {
		public var saveData:SharedObject = SharedObject.getLocal("bunnycopter");
		
		public var classicProgress:Vector.<int>;
		public var badges:Vector.<Boolean>;
		public var achievements:Vector.<Boolean>;
		public var money:int;
		
		public var heliUnlocked:Boolean;
		public var boardUnlocked:Boolean;
		public var shipUnlocked:Boolean;
		
		public function GameData() {
			money = saveData.data.money;
		}
		
		public function resetData():void {
			saveData.clear();
		}
		
		public function save():void {
			saveData.data.money = money;
			saveData.flush();
		}
	}
}