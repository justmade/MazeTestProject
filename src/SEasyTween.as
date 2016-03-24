package
{
	import flash.display.DisplayObject;

	public class SEasyTween
	{
		static private var _instance:SEasyTween;
		
		public function SEasyTween(lock:Lock) 
		{
			
		}
		
		
		public static function getInstance():SEasyTween{
			if(_instance == null){
				_instance = new SEasyTween(new Lock);
			}
			return _instance;
		}
		
		public function to(target:DisplayObject , ):void{
			
		}
		
	}
}class Lock{}