package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Prim extends Sprite
	{
		
		private var walls:Array;
		
		private var cheackPoint:Array;
		
		private var wallWidth:int = 20;
		
		private var wallHeight:int = 20;
		public function Prim()
		{
			trace(int(true))
			super();
			trace([1,2,3,4,5])
		}
		
		
		private function randomArr(arr:Array):Array
		{
			var cloneArr:Array = arr.slice();
			var outputArr:Array = [];
			var i:int = cloneArr.length;
			
			while (i)
			{
				outputArr.push(cloneArr.splice(int(Math.random() * i--), 1)[0]);
			}
			
			return outputArr;
		}
		
		private function initCheckPoint():void{
			walls = new Array();
			cheackPoint = new Array();
			for(var i:int = 0 ; i < wallHeight ; i++){
				walls[i] = new Array();
				for(var j:int = 0 ; j < wallWidth ; j++){
					cheackPoint.push(new Point(i,j))
					if(i == j){
						walls[i][j] = 0;
					}else{
						walls[i][j] = Math.random() * 100;
					}
					
				}
			}
		}
	}
}