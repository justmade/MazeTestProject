package
{
	import flash.geom.Point;

	public class MazeNode
	{
		public var pos:Point;
		
		public var state:int = 1;
		
		public var connects:Array = [0,1,2,3];
		
		public var childNodes:Array = [] 
		
		public var parentNodes:Array = []
			
		public var isDead:Boolean = false 
		
		public function MazeNode(_pos:Point)
		{
			pos = _pos
		}
	}
}