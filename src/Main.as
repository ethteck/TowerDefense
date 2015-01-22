package 
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * ...
	 * @author Ethan Roseman
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(frameRate = '30')]
	
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var cont:GameContainer = new GameContainer();
			addChild(cont);
		}
	}
}