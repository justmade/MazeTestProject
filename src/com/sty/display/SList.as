package  com.sty.display
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.easing.Circ;
	import gs.easing.Strong;
	
	
	public class SList extends Sprite
	{
		//显示区域宽
		private var viewWidth:int ;
		//显示区域高
		private var viewHeight:int ;
		//设置间隔
		public var gap:int ;
		//列表数据
		private var _itemsData:Array;
		//单元类型Class
		private var _itemClass:Class;
		//显示单元个数
		private var itemCounts:int;
		//显示单元数组
		private var itemsArray:Array ; 
		//手势状态
		private var moveState:String = "DOWN";
		//显示单元首位的下标
		private var headIndex:int;
		//显示单元末尾的下标
		private var tailIndex:int ; 
		//tween动画当前帧数
		private var animationFrames:int = 0 ;
		//鼠标开始位置
		private var beginX:Number ;
		
		private var beginY:Number ;
		//列表的移动速度
		private var speed:Number ;
		//鼠标最后经过位置
		private var mousePosVector:Vector.<Point> = new Vector.<Point>();
		//鼠标释放时起始速度
		private var startSpeed:Number ;
		//加速度，速度变化量
		private var changeValue:Number ;
		//缓动时间
		private var duration:int ;
		//缓动是否完成
		private var tweenComplete:Boolean = true ;
		//是否已经反弹
		private var rebound:Boolean = false;
		//单元物体高
		private var itemHeight:Number ; 
		//单元物体宽
		private var itemWidth:Number ;
		//总高度
		private var totalHeiht:Number ;
		//当前位置的高度
		private var currentHeight:Number ;
		//利用加速度得出的距离
		private var changeS:Number;
		//缓动完成
		private var tweenCompleteFunction:Function ;
		//反弹的距离
		private var boundDistace:Number ;
		
		
		
		
		
		public function SList()
		{
			super();
			initSkin();
		}
		
		
		public function get itemClass():Class
		{
			return _itemClass;
		}
		
		/**
		 *定义单元类型 
		 * @param value
		 * 
		 */
		public function set itemClass(value:Class):void
		{
			_itemClass = value;
		}
		
		public function get itemsData():Array
		{
			return _itemsData;
		}
		
		/**
		 *设置数据 
		 * @param value
		 * 
		 */
		public function set itemsData(value:Array):void
		{
			_itemsData = value;
			initList();
		}
		
		
		/**
		 *初始化列表 
		 * 
		 */
		private function initList():void{
			var itemRender:ItemRender = new itemClass();
			itemRender.setData(itemsData[0]);
			itemHeight = itemRender.height;
			itemWidth = itemRender.width ; 
			if((itemRender.height + gap) * itemsData.length > viewHeight){
				itemCounts = Math.ceil(viewHeight / (itemRender.height + gap))+1;
			}else{
				itemCounts = itemsData.length ; 
			}
			for(var i:int = 0 ; i < itemCounts ; i++){
				itemsArray.push(new itemClass());
				itemsArray[i].setData(itemsData[i]);
				itemsArray[i].y = (itemsArray[i].height +gap)*i + itemHeight/2;
				itemsArray[i].x = itemWidth/2
				this.addChild(itemsArray[i]);
			}
			headIndex = 0 ;
			tailIndex = itemCounts - 1 ;
			
			totalHeiht = itemHeight * itemsData.length ; 
			currentHeight = 0 ; 
			
		}
		
		private function initSkin():void{
			itemsArray = new Array();
			resetMouseVector();
			this.addEventListener(Event.ADDED_TO_STAGE , onStage);
		}
		
		private function onStage(e:Event):void{
			
			this.addEventListener(Main.downEvent , onDown);
		}
		
		protected function onDown(event:Event):void
		{
			//			resetMouseVector();
			//			speed = 0;
			tweenHasComplete();
			this.removeEventListener(Main.downEvent , onDown);
			Main.sceneManager.stage.addEventListener(Main.upEvent,onUp);
			Main.sceneManager.stage.addEventListener(Main.moveEvent,onMove);
			
			beginX = mouseX;
			beginY = mouseY ;
			
		}
		
		protected function onUp(event:Event):void
		{
			Main.sceneManager.stage.removeEventListener(Main.moveEvent,onMove);
			Main.sceneManager.stage.removeEventListener(Main.upEvent,onUp);
			this.addEventListener(Main.downEvent, onDown);
			
			//			trace(mousePosVector[2].y - mousePosVector[1].y , mousePosVector[1].y - mousePosVector[0].y , mousePosVector[2].y - mousePosVector[0].y)
			
			var p2p1:Number = int((mousePosVector[2].y - mousePosVector[1].y) * 100)/100;
			var p1p0:Number = int((mousePosVector[1].y - mousePosVector[0].y) * 100)/100;
			var p2p0:Number = int((mousePosVector[2].y - mousePosVector[0].y) * 100)/100;
			
			
			
			startSpeed = Math.max(Math.min(20 , p2p1),-20);
			changeValue = startSpeed * -1.5 ;
			if(Math.abs(changeValue) - Math.abs(startSpeed) >0){
				changeValue = -startSpeed;
			}
			duration = Math.abs(changeValue / 10 * 30);
			getMoveValue(startSpeed/7,duration);
			//			trace("startSpeed:",startSpeed,changeValue,duration)
			startTween();
		}
		
		/**
		 * 
		 * @param a 加速度
		 * @param d 时间 帧数
		 * 
		 */
		private function getMoveValue(a:Number,d:int):void{
			//可以移动的距离
			var distance:Number = 0 ;
			if(moveState == "UP"){
				distance = (itemsData.length - tailIndex - 1) * itemHeight;
				if(itemsArray[itemsArray.length - 1].y + itemHeight/2 > viewHeight){
					distance += (itemsArray[itemsArray.length - 1].y + itemHeight/2 - viewHeight);
				}
			}
			else if(moveState == "DOWN"){
				distance = (headIndex) * itemHeight; 
				if(itemsArray[0].y - itemHeight/2 < 0 ){
					distance += itemHeight/2 - itemsArray[0].y ;
				}
			}
			currentHeight = distance ;
			changeS = Math.ceil((a * a * d /2) *100)/100 * (a / Math.abs(a));
			//trace("distance:",distance,changeS)
			if(itemsArray[0].y - itemHeight/2 > 0){
				rebound = true ;
				boundDistace = itemsArray[0].y - itemHeight/2;
				setTweenParameters(0,0,0,3);
			}
			else if(itemsArray[itemsArray.length - 1].y + itemHeight/2 < viewHeight){
				rebound = true ;
				boundDistace = viewHeight - (itemsArray[itemsArray.length - 1].y + itemHeight/2 );
				setTweenParameters(0,0,0,3);
			}
			else if(Math.abs(changeS) > distance){
				trace("p2")
				boundDistace = Math.min((changeS - distance),30);
				rebound = true ;
				setTweenParameters(0,changeS,-changeS,d);
			}else{
				trace("p3")
				setTweenParameters(0,changeS,-changeS,d);
			}
			
			
			
		}
		
		/**
		 *开始执行缓动 
		 * 
		 */
		private function startTween():void{
			if(!this.hasEventListener(Event.ENTER_FRAME))this.addEventListener(Event.ENTER_FRAME , onRender);
			tweenComplete = false ;
			//			rebound = false;
			
			
		}
		
		protected function onMove(event:Event):void
		{
			recordMousePos(mouseX , mouseY);
			speed = mouseY - beginY ;
			if(speed > 0){
				moveState = "DOWN"
			}else{
				moveState = "UP";
			}
			changeMoveSpeed();
			beginY = mouseY;
			listMove();
		}
		
		
		/**
		 *帧监听 
		 * @param event
		 * 
		 */
		protected function onRender(event:Event):void
		{
			listMove();
			animationFrames ++ ;
			
		}
		
		/**
		 *设置tween的参数 
		 * @param a 当前帧
		 * @param s 起始速度
		 * @param c 变化量
		 * @param d 时间
		 * 
		 */
		private function setTweenParameters(a:int,s:Number,c:Number,d:int,onComplete:Function = null):void{
			animationFrames = a ;
			startSpeed = s;
			changeValue = c ;
			duration = d ;
			lastSpeed = s;
			if(onComplete == null){
				tweenCompleteFunction = tweenHasComplete ; 
			}else{
				tweenCompleteFunction = onComplete ;
			}
		}
		
		private var lastSpeed:Number ;
		/**
		 *缓动方法，获取速度变量 
		 * 
		 */
		private function tween():void{
			if(animationFrames < duration){
				var a:Number = Strong.easeOut(animationFrames,startSpeed,changeValue,duration);
				speed = Math.ceil((lastSpeed - a) * 100)/100;
				lastSpeed = a;
				//				trace("speed:",speed)
			}
			else {
				tweenCompleteFunction.call();
			}
		}
		
		/**
		 *完成缓动 
		 * 
		 */
		private function tweenHasComplete():void{
			rebound = false ;
			animationFrames = 0 ;
			speed = 0 ;
			tweenComplete = true ;
			if(this.hasEventListener(Event.ENTER_FRAME)){
				this.removeEventListener(Event.ENTER_FRAME,onRender);
				resetMouseVector();
				listMove();
			}
		}
		
		/**
		 *反弹 
		 * 
		 */
		private function listBound():void{
			if(itemsArray[0].y - itemHeight/2 >= boundDistace && rebound){
				rebound = false;
				setTweenParameters(0,-boundDistace,boundDistace,Math.min(boundDistace,30))
			}else if(itemsArray[itemsArray.length - 1].y + itemHeight + gap <= viewHeight && rebound){
				rebound = false;
				setTweenParameters(0,boundDistace,-boundDistace,Math.min(boundDistace,30))
			}
		}
		
		/**
		 *移动过程中，如果已经需要反弹则先减速 
		 * 
		 */
		private function changeMoveSpeed():void{
			if(itemsArray[0].y - itemHeight/2 >=0){
				speed/=3;
			}else if(itemsArray[itemsArray.length - 1].y + itemHeight + gap <= viewHeight){
				speed/=3;
			}
		}
		
		
		
		
		
		
		/**
		 *列表移动 
		 * 
		 */
		private function listMove():void{
			if(tweenComplete == false)tween();
			
			if(moveState == "DOWN"){
				for(var i:int = 0 ; i < itemsArray.length ; i++){
					itemsArray[i].y += speed;
				}
				
				listBound();
				
				//判断最后一个的位置
				if(itemsArray[itemsArray.length - 1].y - itemHeight/2> viewHeight && headIndex > 0){
					
					itemsArray.unshift(itemsArray.pop());
					itemsArray[0].y = itemsArray[1].y - itemsArray[1].height - gap ;
					headIndex -- ;
					tailIndex --;
					itemsArray[0].setData(itemsData[headIndex]);
				}
				
			}
			else if(moveState == "UP"){
				for(i = 0 ; i < itemsArray.length ;  i++){
					itemsArray[i].y += speed;
				}
				listBound();
				
				//				
				//判断第一个的位置
				if(itemsArray[0].y + itemsArray[0].height/2 < 0 && tailIndex < itemsData.length -1){
					itemsArray.push(itemsArray.shift());
					itemsArray[itemsArray.length -1].y = itemsArray[itemsArray.length -2].y + itemsArray[itemsArray.length -2].height +gap;
					tailIndex ++ ;
					headIndex ++;
					
					itemsArray[itemsArray.length -1].setData(itemsData[tailIndex]);
				}
				
			}
		}
		
		/**
		 *设置可显示区域 
		 * @param width
		 * @param height
		 * 
		 */
		public function setSize(width:int,height:int):void{
			trace("setSize",width , height)
			viewHeight = height ;
			viewWidth = width ;
			//			this.scrollRect = new Rectangle(0,0,viewWidth,viewHeight);		
			//			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xff00ff,0.3);
			sp.graphics.drawRect(0,0,viewWidth,viewHeight);
			sp.graphics.endFill();
			this.addChild(sp)
			
		}
		
		/**
		 *记录最后进过的3个位置 
		 * @param _mouseX
		 * @param _mouseY
		 * 
		 */
		private function recordMousePos(_mouseX:Number,_mouseY:Number):void{
			if(mousePosVector.length >= 3){
				mousePosVector.push(new Point(_mouseX , _mouseY));
				mousePosVector.shift();
			}else{
				mousePosVector.push(new Point(_mouseX , _mouseY));
			}
		}
		
		/**
		 *重置鼠标进过位置的数组 
		 * 
		 */
		private function resetMouseVector():void{
			for(var i:int = mousePosVector.length -1 ; i>=0 ; i--){
				mousePosVector[i] = null ;
				mousePosVector[i] = new Point(0,0);
			}
			
		}
		
		public function destroy():void{
			tweenHasComplete();
			for(var i:int = mousePosVector.length -1 ; i>=0 ; i--){
				mousePosVector.splice(i,1);
				mousePosVector[i] = null ;
			}
			mousePosVector = null;
			
			for(i = itemsArray.length -1 ; i >= 0 ; i --){
				this.removeChild(itemsArray[i]);
				itemsArray.splice(i,1);
				itemsArray[i] = null;
			}
			itemsArray = null;
			
			for( i = itemsData.length -1 ; i >= 0 ; i --){
				itemsData.splice(i,1);
				itemsData[i] = null;
			}
			itemsData[i] = null;
			
			for(i = this.numChildren -1 ; i >= 0 ; i --){
				this.removeChildAt(i);
			}
		}
		
	}
}