package {
	import flash.display.Sprite;
	import flash.events.Event; 
	[SWF(backgroundColor=0x000000)]
	public class Fireworks extends Sprite {
		private var balls:Array;
		private var numBalls:uint = 100;
		private var fl:Number = 250;
		private var vpX:Number =600 / 2; 
		private var vpY:Number = 400 / 2; 
		private var gravity:Number = 0.4 ;
		private var gravityX:Number = 0.989;
		private var floor:Number = 200;
		private var bounce:Number = -0.6;
		private var currentFrame:int = 0
		public function Fireworks() {
//			init(); 
			initO()
		}
		
		private function initO(){
			var obj:Object = new Object();
			obj["201"] = [1,1,1];
			for(var a:* in obj){
				trace(a)
			}
		}
		private function init():void {
			balls = new Array();
			for (var i:uint = 0; i < numBalls; i++) {
				var ball:Ball3D = new Ball3D(3, Math.random() * 0xffffff); balls.push(ball);
				ball.ypos = -100;
				ball.vx = Math.random() * 6 - 3;
				ball.vy = Math.random() * 8 - 8; 
				ball.vz = Math.random() * 2 - 1; 
				ball.mass = Math.random() * 0.5 + 0.5
				addChild(ball);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame); 
		}
		private function onEnterFrame(event:Event):void 
		{ 
			currentFrame ++ 
//			if (currentFrame == 20) {
//				gravity = 0.3
//				gravityX = 0.01
//			}
			for (var i:uint = 0; i < numBalls; i++)
			{
				var ball:Ball3D = balls[i];
				move(ball); 
			}
			sortZ(); 
		}
		private function move(ball:Ball3D):void { 
//			if (currentFrame == 20) {
//				ball.vy = 0.2
//				ball.vz = 0.2
//			}
			ball.vy += (gravity * ball.mass + ball.vy * -1 *0.098 );
//			ball.vy *= gravityX
			ball.vx *= gravityX 
			ball.xpos += ball.vx;
			ball.ypos += ball.vy;
			ball.zpos += ball.vz; 
			if (ball.ypos > floor) {
				ball.ypos = floor;
				ball.vy *= bounce; 
			}
			if (ball.zpos > -fl) {
				var scale:Number = fl / (fl + ball.zpos); 
				ball.scaleX = ball.scaleY = scale; 
				ball.x = vpX + ball.xpos * scale;
				ball.y = vpY + ball.ypos * scale; 
				ball.visible = true;
			} else {
				ball.visible = false;
			} 
		}
		private function sortZ():void {
			balls.sortOn("zpos", Array.DESCENDING | Array.NUMERIC); for (var i:uint = 0; i < numBalls; i++) {
				var ball:Ball3D = balls[i];
				setChildIndex(ball, i); }
		} 
	}
}