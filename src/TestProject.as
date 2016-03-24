package
{
	import flash.display.Sprite;
	
	public class TestProject extends Sprite
	{
		public function TestProject()
		{
			
			var a:String='{"total": 12,"value": [{"key": "x"},{"key": "y"}]}';
			var b:*=JSON.parse(a);
			trace(b.total);
			
		}
	}
}