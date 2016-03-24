package com.sty.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ItemRender extends Sprite
	{
		
		private var defaultSkin:Sprite ;
		
		private var HEIGHT:Number ; 
		public function ItemRender()
		{
			super();
			initSkin();
			HEIGHT = defaultSkin.height ;
		}
		
		private function initSkin():void{
			defaultSkin = new Sprite();
			defaultSkin.graphics.beginFill(0x00ff00);
			defaultSkin.graphics.drawRect(0,-25,100,50);
			defaultSkin.graphics.endFill();
			this.addChild(defaultSkin);
			
		}
		
		public function setData(_data:Object):void{
			clearSp();
			initSkin();
			var tf:TextField = new TextField();
			tf.text = String(_data);
			this.addChild(tf);
		}
		
		override public function get height():Number
		{
			// TODO Auto Generated method stub
			return HEIGHT;
		}
		
		override public function set height(value:Number):void
		{
			// TODO Auto Generated method stub
			super.height = value;
		}
		
		
		private function clearSp():void{
			for(var i:int = this.numChildren - 1 ; i >=0 ; i--){
				var child:DisplayObject = this.getChildAt(i);
				this.removeChild(child);
				child = null ;
				
			}
			
		}
	}
}