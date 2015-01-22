package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class DataLoader {
		public var loader:URLLoader;
		private var callbackFunction:Function;
		public var levelData:Vector.<Object>;
		
		public function DataLoader(source:String, callback:Function) {
			callbackFunction = callback;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, parseLevels);
			loader.load(new URLRequest(source));
		}
		
		private function parseLevels(e:Event):void {
			loader.removeEventListener(Event.COMPLETE, parseLevels);
			
			levelData = new Vector.<Object>;
			
			var xmlData:XML = new XML(e.target.data);
			var levelList:XMLList = xmlData.children();
			
			for each (var levelInfo:XML in levelList) {
				var tmpLevel:Object = new Object();
				for each (var levelProperty:XML in levelInfo.children()) {
					tmpLevel[levelProperty.name()] = String(levelProperty.text());
				}
				
				//Set correct datatypes
				tmpLevel.id = int(tmpLevel.id);
				tmpLevel.seed = int(tmpLevel.seed);
				tmpLevel.scrollSpeed = int(tmpLevel.scrollSpeed);
				tmpLevel.scrollSpeedChangeRate = Number(tmpLevel.scrollSpeedChangeRate);
				tmpLevel.boulderRate = int(tmpLevel.boulderRate);
				tmpLevel.heightStart = int(tmpLevel.heightStart);
				tmpLevel.heightMin = int(tmpLevel.heightMin);
				tmpLevel.buffer = int(tmpLevel.buffer);
				tmpLevel.maxMove = int(tmpLevel.maxMove);
				tmpLevel.widthStart = int(tmpLevel.widthStart);
				tmpLevel.widthChange = int(tmpLevel.widthChange);
				tmpLevel.levelDistance = int(tmpLevel.levelDistance);
				tmpLevel.playerRotation = int(tmpLevel.playerRotation);
				tmpLevel.backgroundID = int(tmpLevel.backgroundID);
				tmpLevel.foregroundID = int(tmpLevel.foregroundID);
				tmpLevel.maxButtonPresses = int(tmpLevel.maxButtonPresses);
				
				levelData.push(tmpLevel);
			}
			callbackFunction(levelData);
		}
		
	}
}