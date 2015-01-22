package  
{
	import ethteck.FPSCounter;
	import ethteck.GameScreen;
	import ethteck.InputKey;
	import ethteck.InputManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class GameContainer extends Sprite {
		public static var gameClass:Class = TowerDefense;
		
		public var FPSCount:FPSCounter;
		public var dataLoader:DataLoader;
		public var cursor:CursorMC;
				
		public var data:GameData;
		public var inputManager:InputManager;
		
		public var currentScreen:GameScreen;
		
		public var lastFrame:Number;
		public var leftoverTicks:Number;
		
		public var tickCounter:Number = 0;
		public var lastTPS:Number = 0;
		public var TPS:Number = 30;
		
		public var debug:Boolean = true;
		
		public function GameContainer() {	
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setEventListeners();
			initializeCursor();
			
			data = new GameData();
			
			if (debug) {
				FPSCount = new FPSCounter(0, 0, 0xffffff);
				addChild(FPSCount);
			}
			
			lastFrame = (new Date()).getTime();
			lastTPS = lastFrame;
			leftoverTicks = 0;
		
			inputManager = new InputManager();
			startGame();
		}
		
		public function initializeCursor():void {
			Mouse.hide();
			cursor = new CursorMC();
			cursor.mouseEnabled = false;
			updateCursor();
			addChild(cursor);
		}
		
		private function setEventListeners():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			setChildIndex(FPSCount, numChildren - 1);
			setChildIndex(cursor, numChildren - 1);
			
			runTicks();
			//runTick();
		}
		
		private function runTicks():void {
			var now:Number = (new Date()).getTime();
			var diff:Number = now - lastFrame;
			var ticks:Number = diff / (1000 / TPS);
			leftoverTicks += ticks;
			
			while (leftoverTicks >= 1) {
				leftoverTicks--;
				tickCounter ++;
				runTick();
			}
			
			lastFrame = now;
			
			if (now - lastTPS > 1000) {
				//runTPSTimer(now);
			}
		}
		
		private function runTPSTimer(time:Number):void {
			var overflow:Number = (time - lastTPS) - 1000;
			trace(tickCounter + " " + overflow);
			lastTPS = time;
			var res:String = "Ticks: " + tickCounter;
			if (overflow > 0) {
				res += ", Overflow: " + overflow + ":, EffectiveTPS: " + (tickCounter / overflow);
			}
			tickCounter = 0;
			trace(res);
		}
		
		private function runTick():void {
			if (currentScreen != null){
				currentScreen.onTick(inputManager);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (currentScreen != null) {
				currentScreen.handleMouse(e);
			}
			inputManager.add(InputKey.MOUSELEFT);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (currentScreen != null) {
				currentScreen.handleMouse(e);
			}
			inputManager.remove(InputKey.MOUSELEFT);
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (currentScreen != null) {
				currentScreen.handleMouse(e);
			}
			updateCursor();
		}
		
		private function onMouseLeave(e:Event):void {
			cursor.x = -cursor.width;
			cursor.y = -cursor.width;
			
			if (currentScreen != null) {
				currentScreen.handleMouse(e);
			}
		}
		
		private function updateCursor():void {
			cursor.x = mouseX;
			cursor.y = mouseY;
		}
		
		private function startGame():void {	
			currentScreen = new gameClass(inputManager, debug);
			addChild(currentScreen);
		}
		
		public function resetGame(distance:Number):void {
			removeChild(currentScreen);
			startGame();
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			inputManager.add(e.keyCode);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			inputManager.remove(e.keyCode);
		}
	}
}