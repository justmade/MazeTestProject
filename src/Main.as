package
{
	import com.sty.display.SList;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import gs.easing.Circ;

	[SWF(frameRate="60")]
	public class Main extends Sprite
	{
		public static var sceneManager:Main;
		public static var downEvent: String;
		public static var upEvent:String;
		public static var moveEvent:String;
		public static var isMultiTouch: Boolean;
		public static var debug:Boolean=false;
		public var s:Stage ;
		private var list:SList ;
		
		private var arr:Array = [2,2];
		private var arr2:Array = new Array();
		
		private var animationIndex:int ;
		public function Main()
		{
			animationIndex = 0;
			addListener();
		}
		
		private function addListener():void{
			this.addEventListener(Event.ENTER_FRAME , onEnter);
		}
		
		protected function onEnter(event:Event):void
		{
			animationIndex ++;
			var s:Number = Circ.easeIn(animationIndex,10,100,20);
		}
		
	}
}