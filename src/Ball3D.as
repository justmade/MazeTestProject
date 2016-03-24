package
{
	import flash.display.Sprite;

	public class Ball3D extends Sprite
	{
		public var xpos = 0;
		public var ypos = 0;
		public var zpos = 0 ;
		public var vx = 0;
		public var vy = 0;
		public var vz = 0;
		public var mass = 0
		
		public function Ball3D(_r,_c)
		{
			this.graphics.beginFill(_c,1);
			this.graphics.drawCircle(0,0,_r)
			this.graphics.endFill()
		}
	}
}