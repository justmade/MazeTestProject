package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MazeRect extends Sprite
	{
		public var mRect:Rectangle;
		
		private var tf:TextField ;
		public function MazeRect(rect:Rectangle,f:Boolean = false)
		{
			super();
			mRect = rect 
			this.graphics.beginFill(0x91fbff , 1);
			this.graphics.drawRect(rect.x * 10 + 2,rect.y * 10,rect.width * 10,rect.height * 10);
			this.graphics.endFill();
		}
		
		public function setText(id:int):void{
			tf = new TextField();
			tf.width = mRect.width * 15;
			tf.height = mRect.height * 15;
			tf.defaultTextFormat = new TextFormat(null,10,0x000000);
			this.addChild(tf);
			tf.text = String(id)
				
			tf.x = mRect.x * 10 ;
			tf.y = mRect.y * 10-1 ;
			
		}
	}
}