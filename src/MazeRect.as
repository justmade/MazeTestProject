package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class MazeRect extends Sprite
	{
		public var mRect:Rectangle;
		public function MazeRect(rect:Rectangle,f:Boolean = false)
		{
			super();
			mRect = rect
			this.graphics.beginFill(0xffffff * Math.random() , 1);
			this.graphics.drawRect(rect.x * 10 + 2,rect.y * 10,rect.width * 10,rect.height * 10);
			this.graphics.endFill();
		}
	}
}