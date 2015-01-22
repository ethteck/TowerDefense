package  
{
	import gskinner.Rndm;
	/**
	 * ...
	 * @author 
	 */
	public class EnemyManager {
		private var rand:Rndm;
		private var time:Number;
		public var finished:Boolean;
		
		public function EnemyManager(rand:Rndm) {
			this.rand = rand;
			time = 0;
			finished = false;
		}
		
		public function onTick(gameSpeed:Number):Vector.<Fuzz> {
			var enemies:Vector.<Enemy> = new Vector.<Enemy>;
			
			time += gameSpeed;
			
			while (levelData.data.length > 0 && time >= levelData.data[0][1]) {
				incomingFuzz.push(getFuzz(levelData.data[0]));
				levelData.data.splice(0, 1);
			}
			
			if (levelData.data.length == 0) finished = true;
			
			return incomingFuzz;
		}
		
		private function getFuzz(data:Array):Enemy {
			var fuzzClass:Class;
			var fuzzStartX:Number;
			
			switch (data[0]) {
				case FuzzType.SIMPLE:
					fuzzClass = SimpleFuzz;
					break;
				case FuzzType.BOUNCY:
					fuzzClass = BouncyFuzz;
					break;
				case FuzzType.UNPREDICTABLE:
					fuzzClass = UnpredictableFuzz;
					break;
			}
			
			fuzzStartX = rand.float(data[2], data[3]);
			
			return new fuzzClass(fuzzStartX, rand);
		}
		
	}

}