package  
{
	import enem.*;
	import ethteck.CollisionDetection;
	import ethteck.GameScreen;
	import ethteck.InputKey;
	import ethteck.InputManager;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import tow.*;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent; //die
	import flash.geom.Point;
	import flash.utils.Timer; //die

	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class TowerDefense extends GameScreen {
		//{ Vars
			//Graphics
			private var backgroundGfx:Sprite;
			private var pathGfx:Sprite;
			private var towerPreviewGfx:MovieClip;

			//Game Size
			public var gameWidth:int;
			public var gameHeight:int;
			
			//Level Info
			public var enemyPoints:Vector.<Point>;
			public var pathPoints:Vector.<Point>;
			public var mapPoints:Vector.<Vector.<Boolean>>;
			public var enemies:Vector.<Enemy>;
			public var towers:Vector.<Tower>;
			public var projectiles:Vector.<Projectile>;
			public var damageNumbers:Vector.<DamageNumber>;
			public var gameGrid:Grid;
			
			public var enemySwitch:Boolean = true //remove eventually
			
			//Options
			public var showDamageNumbers:Boolean;
			
			//Misc
			public var towerBuildType:int;
			public var pauseDownLastFrame:Boolean;
			public var mouseDownPt:Point;
			public var mousePt:Point;
			public var selectionManager:SelectionManager;
			public var selectionRectangle:SelectionRectangle;
			public var selectedTowers:Vector.<Tower>;
		//}
		
		public function TowerDefense(inputManager:InputManager, debugMode:Boolean) {
			super(inputManager, debugMode);
			gameWidth = Common.GAMEWIDTH;
			gameHeight = Common.GAMEHEIGHT;
			
			gameGrid = new Grid(gameWidth, gameHeight, 25);
			
			gameRunning = true;
			showDamageNumbers = false;
			pauseDownLastFrame = false;
			mouseDownPt = new Point();
			mousePt = new Point();
			selectionManager = new SelectionManager();
			selectionRectangle = new SelectionRectangle();
			selectedTowers = new Vector.<Tower>;
			
			backgroundGfx = new Sprite();
			pathGfx = new Sprite();
			towerPreviewGfx = new MovieClip();
			
			enemies = new Vector.<Enemy>;
			towers = new Vector.<Tower>;
			projectiles = new Vector.<Projectile>();
			damageNumbers = new Vector.<DamageNumber>();
			
			//enemyPoints = Vector.<Point>([new Point(3, 15), new Point(4, 3), new Point(15, 4)]);
			//enemyPoints = Vector.<Point>([new Point(11, 3), new Point(14, 3), new Point(17, 6), new Point(17, 9), new Point(14, 12), new Point(11, 12), new Point(8, 9), new Point(8,6), new Point(11,3)]);
			enemyPoints = Vector.<Point>([new Point(3,16), new Point(17,16), new Point(17,15), new Point(10,13), new Point(10,10), new Point(17,10), new Point(17,2), new Point(1,2), new Point(19,6)]);
			//enemyPoints = Vector.<Point>([new Point(10, 10), new Point(10, 5), new Point(15, 5), new Point(15, 10), new Point(10, 10)]);
			//enemyPoints = Vector.<Point>([new Point(3, 16), new Point(17, 16)]);
			//enemyPoints = Vector.<Point>([new Point(1, 1), new Point(5, 1), new Point(5, 7), new Point(6, 11), new Point(7, 15), new Point(16, 15), new Point(17, 11), new Point(18, 7), new Point(18, 1), new Point(22, 1)]);
			// crazy level mapPoints = Vector.<Point>([new Point(3, 14), new Point(6, 5), new Point(8, 12), new Point(12, 9), new Point(2, 8), new Point(5, 2), new Point(3, 8), new Point(5, 10), new Point(8, 6), new Point(13, 4), new Point(18, 10), new Point(13, 14), new Point(15, 11), new Point(15, 7), new Point(17, 14), new Point(22, 11), new Point(19, 4), new Point(15, 2), new Point(9, 9), new Point(11, 17)]);
			// spiral mapPoints = Vector.<Point>([new Point(1, 16), new Point(1, 1), new Point(22, 1), new Point(22, 16), new Point(4, 16), new Point(4, 4), new Point(19, 4), new Point(19, 14), new Point(7, 14), new Point(7, 7), new Point(15, 7), new Point(15, 12), new Point(10, 12), new Point(12, 10)]);
			//enemyPoints = Vector.<Point>([new Point(-2, 1), new Point(4, 1), new Point(4, 15), new Point(5, 16), new Point(8, 16), new Point(9, 15), new Point(8, 2), new Point(9, 1), new Point(12, 1), new Point(13, 2), new Point(13, 15), new Point(14, 16), new Point(17, 16), new Point(18, 15), new Point(18, 2), new Point(19, 1), new Point(21, 1), new Point(22, 2), new Point(22, 9), new Point(25, 9)]);
			//enemyPoints = Vector.<Point>([new Point(-2, 1), new Point(-1, 1), new Point(0, 1), new Point(1, 1), new Point(2, 1), new Point(2, 2), new Point(2, 3), new Point(2, 5), new Point(2, 4), new Point(2, 6), new Point(2, 7), new Point(2, 8)]);
			//enemyPoints = Vector.<Point>([new Point(3, 18), new Point(6, 3), new Point(14, 13), new Point(5, 4), new Point(15, 12), new Point(5, 5), new Point(15, 11), new Point(5, 6), new Point(15, 10), new Point(5, 7), new Point(15, 9), new Point(5, 8), new Point(15, 8), new Point(5, 9), new Point(15, 7), new Point(5, 10), new Point(15, 6), new Point(5, 11), new Point(15, 5), new Point(5, 12), new Point(15, 4), new Point(6, 13), new Point(14, 3), new Point(15, -1)]);
			enemyPoints = offsetPoints(enemyPoints, 0.5);
			
			pathPoints = getPath();
			initializeMapPoints();
			
			drawBackground();
			
			towerBuildType = -1;
			addChild(towerPreviewGfx);
			towerPreviewGfx.visible = false;
			
			drawPath();
			
			//REMOVE SOON
			var enemyTime:Timer = new Timer(800);
			enemyTime.start();
			enemyTime.addEventListener(TimerEvent.TIMER, createEnemy);
			createEnemy();
			//REMOVE SOON
		}
		
		private function offsetPoints(pts:Vector.<Point>, amt:Number):Vector.<Point> {
			for (var i:int = 0; i < pts.length; i++) {
				pts[i].x += amt;
				pts[i].y += amt;
			}
			return pts;
		}
		
		//REMOVE SOON
		private function createEnemy(e:TimerEvent = null):void {
			var en:Enemy;
			if (enemySwitch) {
				en = new NormalEnemy(enemyPoints, gameGrid);
			}
			else {
				en = new DifferentEnemy(enemyPoints, gameGrid);
			}
			enemySwitch = !enemySwitch;
			enemies.push(en);
			addChild(en);
		}
		//REMOVE SOON
		
		override public function onTick(keysPressed:InputManager):void {
			handlePause(keysPressed);
			handleInput(keysPressed);
			if (gameRunning) {
				manageEnemies();
				manageTowers();
				manageBullets();
				manageDamageNumbers();
				removeObjects();
				fixObjectDepth();
			}
		}
		
		public function handlePause(keysPressed:InputManager):void {
			if (!pauseDownLastFrame && keysPressed.isKeyPressed(InputKey.P)) {
				if (!gameRunning) {
					//removeChild(pauseDisplay);
				}
				else {
					//addChild(pauseDisplay);
				}
				gameRunning = !gameRunning;
			}
			pauseDownLastFrame = keysPressed.isKeyPressed(InputKey.P);
		}
		
		private function updateTowerPreview():void {
			removeChild(towerPreviewGfx);
			
			var tmpScale:Number = gameGrid.getScale(2);
			var towerClip:Class = getTowerClass(towerBuildType);
			
			towerPreviewGfx = new (towerClip.m_gfxClass)();
			addChild(towerPreviewGfx);
			
			var selPoint:Point = gameGrid.getPixelPoint(mouseX, mouseY);
			towerPreviewGfx.x = selPoint.x + tmpScale;
			towerPreviewGfx.y = selPoint.y + tmpScale;
			towerPreviewGfx.width = towerClip.m_area.x * gameGrid.gridSize - tmpScale;
			towerPreviewGfx.height = towerClip.m_area.y * gameGrid.gridSize - tmpScale;
			
			/*var colorTint:ColorTransform;
			if (!isFree(gameGrid.getGridPoint(mouseX, mouseY))) {
				colorTint = new ColorTransform(1, 0.2, 0.2, 1, 255, 0, 0, 1);
				towerPreviewGfx.transform.colorTransform = colorTint;
			}*/
		}
		
		private function getTowerClass(type:int):Class {
			switch (type) {
				case TowerType.SIMPLETOWER:
					return SimpleTower;
					break;
				case TowerType.OTHERTOWER:
					return OtherTower;
					break;
				case TowerType.BIGGERTOWER:
					return BiggerTower;
					break;
				default:
					return null;
			}
		}
		
		private function startSelectionRectangle(keysPressed:InputManager):void {
			selectionRectangle = selectionManager.startSelecting(mouseDownPt.x, mouseDownPt.y);
			addChild(selectionRectangle);
			if (!keysPressed.isKeyPressed(InputKey.SHIFT)) {
				selectionManager.clearSelection();
			}
		}
		
		public override function handleMouse(e:Event):void {
			switch (e.type) {
				case "mouseMove":
					if (towerBuildType != -1 && changedCell()){
						updateTowerPreview();
					}
					if (!selectionManager.selecting && mouseMoved() && inputManager.isMouseDown()) {
						startSelectionRectangle(inputManager)
					}//move this below
					break;
				case "mouseDown":
					mouseDownPt.x = mouseX;
					mouseDownPt.y = mouseY;
					break;
				case "mouseUp":
					if (gameRunning) {
						if (e.target.parent is Tower && !selectionManager.selecting) {
							selectionManager.clickTower(e.target.parent, inputManager);
						}
						else if (!inputManager.isKeyPressed(InputKey.SHIFT) && !selectionManager.selecting) {
							if (selectedTowers.length == 0 && towerBuildType != -1) {
								createTower(gameGrid.getGridPoint(towerPreviewGfx.x, towerPreviewGfx.y));
							}
							selectionManager.clearSelection();
						}
					}
					selectionManager.resetSelectionRect();
					if (selectionRectangle.stage) {
						removeChild(selectionRectangle);
					}
					break;
				}
		}
		
		private function changedCell():Boolean {
			var newCell:Point = gameGrid.getGridPoint(mouseX, mouseY);
			if (!newCell.equals(mousePt)) {
				mousePt = newCell;
				return true;
			}
			return false;
		}
		
		private function mouseMoved():Boolean {
			//if (mouseDownPt == null) return false;
			if (Math.abs(mouseX - mouseDownPt.x) > 5) {
				return true;
			}
			if (Math.abs(mouseY - mouseDownPt.y) > 5) {
				return true;
			}
			return false;
		}
		
		private function createTower(pt:Point):void {
			if (isFree(gameGrid.getGridPoint(pt.x, pt.y))) {
				var towerClass:Class = getTowerClass(towerBuildType);
				var tmpTower:Tower = new towerClass(pt, gameGrid);
				towers.push(tmpTower);
				addChild(tmpTower);
				
				stopBuildingTower();
			}
		}
		
		private function stopBuildingTower():void {
			towerBuildType = -1;
			towerPreviewGfx.visible = false;
			//updateTowerPreview();
		}
		
		private function isFree(pt:Point):Boolean {
			for (var i:int = 0; i < pathPoints.length; i++) {
				if (pathPoints[i].x == pt.x && pathPoints[i].y == pt.y) {
					return false;
				}
			}
			return true;
		}
		
		private function manageEnemies():void {
			if (enemies == null || enemies.length == 0) return;
			
			for (var i:int = 0; i < enemies.length; i++) {
				if (!enemies[i].isAlive) {
					continue;
				}
				setChildIndex(enemies[i], numChildren - 1);
				enemies[i].move();
			}
		}
		
		private function manageTowers():void {
			if (towers == null || towers.length == 0) return;
			
			for (var i:int = 0; i < towers.length; i++) {
				if (towers[i].shootTime == 0) {
					towers[i].readyToShoot = true;
				}
				towers[i].shootTime --;
				if (towers[i].readyToShoot) {
					tryToShoot(towers[i]);
				}
			}
		}
		
		private function tryToShoot(tower:Tower):void {
			var tmpProj:Projectile = tower.shoot();
			if (tmpProj != null){
				projectiles.push(tmpProj);
				addChild(tmpProj);
			}
		}
		
		private function manageBullets():void {
			if (projectiles == null || projectiles.length == 0) return;
			
			for (var i:int = 0; i < projectiles.length; i++) {
				projectiles[i].move();
				checkCollision(projectiles[i]);
			}
		}
		
		private function manageDamageNumbers():void {
			if (damageNumbers == null || damageNumbers.length == 0) return;
			
			for (var i:int = 0; i < damageNumbers.length; i++) {
				damageNumbers[i].tick();
			}
		}
		
		private function checkCollision(p:Projectile):void {			
			for each (var e:Enemy in enemies) {
				var coll:Boolean = CollisionDetection.testObjects(p, e, this);
				if (coll) {
					collide(p, e);
				}
			}
		}
		
		private function collide(proj:Projectile, enemy:Enemy):void {
			if (proj.isActive){
				dealDamage(proj, enemy);
				proj.isActive = false;
			}
		}
		
		private function dealDamage(p:Projectile, enemy:Enemy):void {
			var critCheck:Number = Math.random();
			var damage:Number;
			var isCrit:Boolean = false;
			
			if (critCheck > p.critChance){
				damage = p.power;
			}
			else {
				damage = p.power * p.critMultiplier;
				isCrit = true;
			}
			enemy.hp -= damage;
			enemy.healthBarGfx.width = Math.round((enemy.hp / enemy.maxHp) * HelperMethods.getUnrotatedWidth(enemy.gfx));
			
			if (showDamageNumbers){
				var dn:DamageNumber = new DamageNumber(gameGrid, enemy, damage, 0xFFFFFF, isCrit);
				addChild(dn);
				damageNumbers.push(dn);
			}
				
			if (enemy.hp <= 0) {
				enemy.isAlive = false;
			}
		}
		
		private function removeObjects():void {
			removeProjectiles();
			removeEnemies();
			removeDamageNumbers();
		}
		
		private function fixObjectDepth():void {
			selectedTowers = selectionManager.getSelection();
			if (selectedTowers.length > 0) {
				for each (var i:Tower in selectedTowers){
					setChildIndex(i, numChildren - 1);
				}
			}
			if (selectionManager.selecting) {
				selectionManager.manageSelectionRect(mouseX, mouseY, towers); //is this where this is supposed to go?
				//setChildIndex(selectionRect, numChildren - 1);
			}
		}
		
		private function handleInput(keysPressed:InputManager):void {
			if (keysPressed.isKeyPressed(InputKey.DELETE)) {
				if (selectedTowers.length > 0) {
					for (var i:int = selectedTowers.length - 1; i >= 0; i--) {
						removeTower(selectedTowers[i]);
					}
				}
			}
			if (keysPressed.isKeyPressed(InputKey.NUM_1) && towerBuildType != TowerType.SIMPLETOWER) {
				towerBuildType = TowerType.SIMPLETOWER;
				updateTowerPreview();
			}
			if (keysPressed.isKeyPressed(InputKey.NUM_2) && towerBuildType != TowerType.OTHERTOWER) {
				towerBuildType = TowerType.OTHERTOWER;
				updateTowerPreview();
			}
			if (keysPressed.isKeyPressed(InputKey.NUM_3) && towerBuildType != TowerType.BIGGERTOWER) {
				towerBuildType = TowerType.BIGGERTOWER;
				updateTowerPreview();
			}
			if (keysPressed.isKeyPressed(InputKey.ESCAPE)) {
				stopBuildingTower();
			}
			
		}
		
		private function removeTower(tower:Tower):void {
			selectionManager.removeSelection(tower);
			towers.splice(towers.indexOf(tower), 1);
			removeChild(tower);			
		}
		
		private function removeProjectiles():void {
			if (projectiles == null || projectiles.length == 0) return;
			for (var i:int = projectiles.length - 1; i >= 0; i--) {
				if (!projectiles[i].isActive) {
					removeProjectile(i);
				}
			}
		}
		
		private function removeProjectile(i:int):void {
			removeChild(projectiles[i]);
			projectiles.splice(i, 1);
		}
		
		private function removeEnemies():void {
			if (enemies == null || enemies.length == 0) return;
			for (var i:int = enemies.length - 1; i >= 0; i--) {
				if (!enemies[i].isAlive) {
					removeEnemy(i);
				}
			}
		}
		
		private function removeEnemy(i:int):void {
			removeChild(enemies[i]);
			enemies.splice(i, 1);
		}
		
		private function removeDamageNumbers():void {
			if (damageNumbers == null || damageNumbers.length == 0) return;
			for (var i:int = damageNumbers.length - 1; i >= 0; i--) {
				if (damageNumbers[i].time >= 20) {
					removeChild(damageNumbers[i]);
					damageNumbers.splice(i, 1);
				}
			}
		}
		
		protected function drawBackground():void {
			var gfx:Graphics = backgroundGfx.graphics;
			gfx.beginFill(0x000000);
			gfx.drawRect(0, 0, gameWidth, gameHeight);
			gfx.endFill();
			addChild(backgroundGfx);
			
			gameGrid.drawGrid();
			addChild(gameGrid);
		}
		
		protected function getPath():Vector.<Point> {
			var testEn:EnemyDummy = new EnemyDummy(enemyPoints, gameGrid);
			while (testEn.isActive){
				testEn.move();
			}
			var tmpPoints:Vector.<Point> = testEn.markedPath;
			for (var i:int = 0; i < tmpPoints.length; i++) {
				for (var j:int = i + 1; j < tmpPoints.length; j++) {
					if (tmpPoints[i].x == tmpPoints[j].x && tmpPoints[i].y == tmpPoints[j].y) {
						//get rid of duplicates in the tmpPoints
						tmpPoints.splice(j, 1);
						j--;
					}
				}
				if (tmpPoints[i].x < 0 || tmpPoints[i].y < 0 || tmpPoints[i].x + 1 > gameGrid.getGridWidth() || tmpPoints[i].y + 1> gameGrid.getGridHeight()) {
					tmpPoints.splice(i, 1);
				}
			}
			return tmpPoints;
		}
		
		protected function drawPath():void {
			var pathGraphics:Graphics = pathGfx.graphics;
			var tmpX:int;
			var tmpY:int;
			for (var i:int = 0; i < pathPoints.length; i++){
				tmpX = pathPoints[i].x * gameGrid.gridSize;
				tmpY = pathPoints[i].y * gameGrid.gridSize;
				pathGraphics.beginFill(0x6666FF, 0.4);
				pathGraphics.drawRect(tmpX, tmpY, gameGrid.gridSize, gameGrid.gridSize);
				pathGraphics.endFill();
			}
			addChild(pathGfx);
		}
		
		protected function initializeMapPoints():void {
			var tmpVecX:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>;
			for (var x:int = 0; x < gameGrid.getGridWidth(); x++) {
				var tmpVecY:Vector.<Boolean> = new Vector.<Boolean>;
				for (var y:int = 0; y < gameGrid.getGridHeight(); y++) {
					tmpVecY.push(false);
				}
				tmpVecX.push(tmpVecY);
			}
			
			mapPoints = tmpVecX;
			populateMapPoints(pathPoints);
		}
		
		protected function populateMapPoints(vecPoints:Vector.<Point>):void {
			for each (var p:Point in vecPoints) {
				mapPoints[p.x][p.y] = true;
			}
		}
	}
}