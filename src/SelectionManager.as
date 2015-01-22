package {
	import ethteck.InputManager;
	import ethteck.InputKey;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public final class SelectionManager {
		public var rect:SelectionRectangle;
		public var selecting:Boolean;
		
		public var selectedTowers:Vector.<Tower>;
		
		public function SelectionManager() {
			rect = new SelectionRectangle();
			
			selectedTowers = new Vector.<Tower>;
		}
		
		public function manageSelectionRect(mx:int, my:int, towers:Vector.<Tower>):void {
			clearSelection();
			
			updateSelectionRect(mx, my);
			var tmpSel:Vector.<Tower> = new Vector.<Tower>();
			
			//Add towers to selection vector
			for each (var t:Tower in towers) {
				if (rect.hitTestObject(t.gfx)) {
					tmpSel.push(t);
					selectTower(t);
				}
			}
			
			selectedTowers = tmpSel;
		}
		
		public function resetSelectionRect():void {
			selecting = false;
			rect.removeAllChildren();
		}
		
		public function clickTower(sel:Tower, keysPressed:InputManager):void {
			if (keysPressed.isKeyPressed(InputKey.SHIFT)) {
				if (selectedTowers.indexOf(sel) == -1) {
					selectTower(sel);
				}
				else {
					removeSelection(sel);
				}
			}
			else {
				clearSelection();
				selectTower(sel);
			}
		}
		
		private function selectTower(tower:Tower):void {
			if (selectedTowers.indexOf(tower) == -1) {
				selectedTowers.push(tower);
				tower.rangeGfx.visible = true;
			}
		}
		
		public function startSelecting(startX:int, startY:int):SelectionRectangle {
			rect.start(startX, startY);
			selecting = true;
			return rect;
		}
		
		private function updateSelectionRect(mouseX:int, mouseY:int):SelectionRectangle {
			rect.update(mouseX, mouseY);
			return rect;
		}
		
		public function removeSelection(tower:Tower):void {
			tower.rangeGfx.visible = false;
			selectedTowers.splice(selectedTowers.indexOf(tower), 1);
		}
		
		public function clearSelection():void {
			for (var i:int = selectedTowers.length - 1; i >= 0; i-- ) {
				removeSelection(selectedTowers[i]);
			}
		}
		
		public function getSelection():Vector.<Tower> {
			return selectedTowers;
		}
	}
}
