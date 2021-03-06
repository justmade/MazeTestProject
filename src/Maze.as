package
{
	import com.astar.AStar;
	import com.astar.Grid;
	import com.astar.Node;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[SWF(height="700",width="700")]
	public class Maze extends Sprite
	{
		
		private var viewRect:Rectangle
		
		private var allRects:Array;
		
		private var mazeNodes:Array;
		
		private var currentPoint:Point;
		
		private var connectNodes:Array;
		
		private var childIndex:int = 0;
		
		private var searchQueue:Array;
		public function Maze()
		{
			super();
			
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE
			gridMap()
			viewRect = new Rectangle(5,0,10,50);
			allRects = new Array();
			connectNodes = new Array();
			searchQueue = new Array();
			
			var w:int =  1;
			var h:int =  1;
			var posx:int = viewRect.x + Math.random() * (viewRect.width - w) ;
			var posy:int = Math.random() * (viewRect.height - h);
			var newR:Rectangle = new Rectangle(posx,posy,w,h)
			var mazeRect:MazeRect = new MazeRect(newR,true);
			
			this.addChild(mazeRect);
			allRects.push(mazeRect);
			changeNodeState(newR)	
			
			generateBlocks();
			getFirstPoint()
			initAstar()
//			
//			var n:MazeNode = getMazeNode(currentPoint)
//				n.isDead = true;
//				trace(n.pos)
//			connectNodes = [n]
			generateMaze();
//			findDoor();
//			findDieWay();
			drawTree();
//			
//			searchQueue = [n]
//			levelSearch();
//			
//			var i = n.childNodes.indexOf(new Point(0,0));
//			for(var i:int = 0 ; i < n.childNodes.length ; i++){
//				trace(n.childNodes[i].pos)
//			}
			
//			searchRoomByOrder(n)
//			this.addEventListener(Event.ENTER_FRAME , onEnter);
//			this.stage.addEventListener(MouseEvent.CLICK , onEnter);
		}
		private var grid:Grid ;
		private var astar:AStar;
		private var gridSp:Sprite
		
		
		private function initAstar():void{
			grid = new Grid();
			grid.creatGrid(50,20)
				
			for(var i:int = 0 ; i < allRects.length ; i++){
//				if(allRects[i].state == 0){
					var arr:Array = grid.nodeArrayList ; 
					var x:int = allRects[i].mRect.x;
					var y:int = allRects[i].mRect.y;
//					trace(x,y)
					var node:Node = arr[x][y];
					if(node.walkable){
						grid.setWalkAble(x,y,false);
					}
					
//				}
			}
//			allRects.sort(sortRectByPosX);
//			allRects.sort(sortRectByPos);
			sortAllRect();
			
			for(var i:int = 0 ; i < allRects.length ; i ++){
				allRects[i].setText(i)
			}
			astar = new AStar()
			
				
			gridSp = new Sprite();
			this.addChild(gridSp)
			gridSp.x = 200
			drawGird();
			findRectPath()
		}
		
		private function sortAllRect():void{
			var all:Array = new Array()
			for(var i:int = 0 ; i < 50 ; i ++){
				var temp:Array = new Array()
				for(var j:int = 0 ; j < allRects.length ; j++){
					if(allRects[j].mRect.y == i){
						temp.push(allRects[j]);
					}
				}
				
				if(temp.length > 0){
					temp.sort(sortRectByPosX);
					all = all.concat(temp)
				}
			}
			allRects = all;
		}
		
		private function drawGird():void{
			gridSp.graphics.clear()
			var arr:Array = grid.nodeArrayList ; 
			for(var i:int = 0 ; i < grid.gridLineNum ; i++){
				for(var j:int = 0 ; j < grid.gridRowNum ; j++){
					var node:Node = arr[j][i];
					gridSp.graphics.lineStyle(0);
					gridSp.graphics.beginFill(getNodeColor(node));
					gridSp.graphics.drawRect(j*10 , i *10 , 10 , 10);
				}
			}
		}
		
		private function getNodeColor(_node:Node):uint
		{
			if(_node == grid.startNode){return 0xff0000};
			if(_node == grid.endNode){return 0xff0000} ;
			if(!_node.walkable){return 0x000000}
			if(_node.isPath){return 0x00ff00};
			if(_node.isFind){return 0x333333};
			return 0x0000ff ;
			
		}
		
		/**
		 *将所有矩形连接起来 
		 * 
		 */
		private function findRectPath():void{
			for(var i:int = 0 ; i <allRects.length-1 ; i ++){
				var startRect:MazeRect = allRects[i];
				var endRect:MazeRect = allRects[i+1];
				
				var points:Array = getLocation(startRect , endRect)
					
				var p:Point = points[0];
				for(var k:int = 0 ; k < startRect.doors.length ; k++){
					if(p.equals(startRect.doors[k])){
						p = points[1];
						break
					}
				}
				
				startRect.doors.push(p);
				endRect.doors.push(new Point(-p.x , -p.y))
				
				grid.setStartNode(startRect.mRect.x + p.x ,startRect.mRect.y + p.y);
				grid.setEndNode(endRect.mRect.x - p.x,endRect.mRect.y - p.y);
				astar.setGrid(grid)
				var parr:Array = astar.getPath() ; 
				parr.unshift(new Node(startRect.mRect.x , startRect.mRect.y))
				parr.push(new Node(endRect.mRect.x , endRect.mRect.y))
				for(var j:int = 0 ; j <parr.length; j++){
					parr[j].isPath = true ;
					if( j < parr.length -1){
						var parentNode:MazeNode = getMazeNode(new Point(parr[j]._x ,parr[j]._y))
						var childNode:MazeNode = getMazeNode(new Point(parr[j+1]._x ,parr[j+1]._y))
						parentNode.childNodes.push(childNode);
						childNode.parentNodes.push(parentNode)
							
						parentNode.isMain = true	
						parentNode.state = 0;
						connectNodes.push(parentNode);	
						parentNode.isMain = true
						childNode.state = 0;
						connectNodes.push(childNode);		
						
					}
					
				}
				
				
				drawGird();
			}
		}
		
		private function getLocation(startRect:MazeRect , endRect:MazeRect):Array{
			var dx:int = endRect.mRect.x - startRect.mRect.x;
			var dy:int = endRect.mRect.y - startRect.mRect.y;
			
			var arr:Array = new Array();
			if(Math.abs(dx) < Math.abs(dy)){
				
				if(dy > 0){
					arr.push(new Point(0,1))
				}else{
					arr.push(new Point(0,-1))
				}
				
				if(dx > 0){
					arr.push(new Point(1,0))
				}else{
					arr.push(new Point(-1,0))
				}
			}else{
				if(dx > 0){
					arr.push(new Point(1,0))
				}else{
					arr.push(new Point(-1,0))
				}
				
				if(dy >= 0){
					arr.push(new Point(0,1))
				}else{
					arr.push(new Point(0,-1))
				}
			}
			return arr
			
		}
		
		private function setRectPath():void{
			
		}
		
		/**
		 * 按照矩形的y轴排序 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */
		private function sortRectByPos(a:MazeRect , b:MazeRect):int{
			var posa:int = a.mRect.y;
			var posb:int = b.mRect.y;
			if(posa > posb){
				return 1;
			}else if(posa < posb){
				return -1;
			}else{
				return 0
			}
			
			
		}
		
		private function sortRectByPosX(a:MazeRect , b:MazeRect):int{
			var posa:int = a.mRect.x;
			var posb:int = b.mRect.x;
			if(posa > posb){
				return 1;
			}else if(posa < posb){
				return -1;
			}else{
				return 0
			}
			
			
		}
		
		
		
		
		
		
		private function getFirstPoint():void{
			for(var i:int = 0 ; i < mazeNodes.length ; i++){
				if(mazeNodes[i].state == 1){
					currentPoint = new Point( int(i /20),i%20);
					break
				}
			}
		}
		
		private function gridMap():void{
//			this.graphics.beginFill(0x000000,1);
			mazeNodes = new Array();
			for(var i:int = 0 ; i < 50 ; i++){
				for(var j:int = 0 ; j < 20 ; j ++){
					var sp:Sprite = new Sprite();
					sp.graphics.beginFill(0x000000);
					sp.graphics.drawCircle(j * 10,i * 10 , 0)
					sp.graphics.endFill()
					this.addChild(sp);
					var mNode:MazeNode = new MazeNode(new Point(j,i));
					mazeNodes.push(mNode);
				}
			}
			
		}
		
		/**
		 *从生成的房间里开一个门 与地图联通 
		 * 
		 */		
		private function findDoor():void{
			for(var i:int = 0 ; i < allRects.length ; i++){
				var rect:Rectangle = allRects[i].mRect;
				var bRect:Array = new Array();
					for(var startX:int = rect.x ; startX <= rect.x + rect.width ; startX ++){
						for(var startY:int = rect.y ; startY <= rect.y + rect.height ; startY ++){
							if(((startX > rect.x) && (startX < (startX + rect.width)))
								&& ((startY > rect.y) && (startY < (startY + rect.height)))
								&& startX!=0 && startX!=19 && startY!=0 && startY!=49){
								
							}else{
								bRect.push(new Point(startX , startY));
							}
							
							
						}
					}
					
					
				var index:int = int(bRect.length * Math.random());
//				for(var j:int = 0 ; j < 1 ; j ++){
					var p:Point = bRect[index];
					var node:MazeNode = getMazeNode(p);
					node.room = allRects[i];
					for(var k:int = 0 ; k < node.connects.length; k ++){
						var startP:Point = node.pos.clone();
						var endP:Point = startP.add(dirs[node.connects[k]]);
						
						var toNode:MazeNode = getMazeNode(endP);
						toNode.childNodes.push(node);
						node.parentNodes.push(toNode)
						node.isDead = true;
						
						this.graphics.lineStyle(3,0x000000);
						this.graphics.moveTo(startP.x * 10 +2 , startP.y * 10);
						this.graphics.lineTo(endP.x * 10 +2, endP.y * 10);
						break
						
					}
//				}
				
			}
		}
		
		private function onEnter(e):void{
			if(searchQueue.length !=0){
				var cNode:MazeNode = searchQueue.shift();
				trace("cNode",cNode.pos)
				searchRoomByLevel(cNode)
			}
			
		}
		
		
		private function levelSearch():void{
//			while(searchQueue.length !=0){
//				var cNode:MazeNode = searchQueue.shift();
//				
//				searchRoom(cNode)
//			}
		}
		
		private function sortByPos(a:MazeNode , b:MazeNode):int{
			var posa:Point = a.pos;
			var posb:Point = b.pos;
			if(posa.y > posb.y){
				return 1;
			}else if(posa.y < posb.y){
				return -1;
			}else{
				return 0
			}
			
			
		}
		
		private function searchRoomByOrder(cNode:MazeNode):void{
			cNode.childNodes = cNode.childNodes.sort(sortByPos)
			for(var i:int = 0 ; i < cNode.childNodes.length ; i++){
				
				var childNode:MazeNode = cNode.childNodes[i]
					
				this.graphics.lineStyle(3,0xff0000);
				this.graphics.moveTo(cNode.pos.x * 10 +2 , cNode.pos.y * 10);
				this.graphics.lineTo(childNode.pos.x * 10 +2, childNode.pos.y * 10);
				if(childNode.room){
					childNode.room.setText(childIndex);
					childIndex ++;
				}else{
					searchRoomByOrder(childNode);
				}
			}
		}
		
		private function searchRoomByLevel(cNode:MazeNode):void{
			trace("root" , cNode.pos ,cNode.childNodes.length);
			cNode.childNodes = cNode.childNodes.sort(sortByPos)
			for(var i:int = 0 ; i < cNode.childNodes.length ; i++){
				var childNode:MazeNode = cNode.childNodes[i]
//				trace(childNode.pos)
				this.graphics.lineStyle(3,0xff0000);
				this.graphics.moveTo(cNode.pos.x * 10 +2 , cNode.pos.y * 10);
				this.graphics.lineTo(childNode.pos.x * 10 +2, childNode.pos.y * 10);
				
				 if(childNode.room){
					 childNode.room.setText(childIndex);
					 childIndex ++;
				 }else{
					
					 if(childNode.pos != cNode.pos){
						 trace("childNode",childNode.pos)
						 searchQueue.push(childNode)
					 }
					
					
				 }
				
			}
			
			
			
			
		}
		
		private function drawTree():void{
			this.graphics.clear();
			for(var i:int = 0 ; i < mazeNodes.length ; i++){
				var cNode:MazeNode = mazeNodes[i];
				drawNode(cNode)
			}
		}
		
		private function drawNode(cNode:MazeNode):void{
			if(cNode.parentNodes.length != 0){
				var pNode:MazeNode = cNode.parentNodes[0];
				if(cNode.isMain == false){
					this.graphics.lineStyle(3,0x000000,0.1);
				}else{
					this.graphics.lineStyle(3,0xff0000,0.8);

				}
				
				this.graphics.moveTo(cNode.pos.x * 10 +2 , cNode.pos.y * 10);
				this.graphics.lineTo(pNode.pos.x * 10 +2, pNode.pos.y * 10);
			}
		}
		
		
		private function findDieWay():void{
			for(var i:int = 0 ; i < mazeNodes.length ; i++){
			  	var cNode:MazeNode = mazeNodes[i];
				deadDieWay(cNode)
			}
		}
		
		private function deadDieWay(cNode:MazeNode):void{
			if(cNode.isDead == false){
				if(cNode.childNodes.length == 0){
					cNode.isDead = true
					var pNode:MazeNode = cNode.parentNodes[0];
					if(pNode){
						cNode.parentNodes = []
						var childIndex:int = pNode.childNodes.indexOf(cNode);
						pNode.childNodes.splice(childIndex,1);
						
						this.graphics.lineStyle(3,0xffffff);
						this.graphics.moveTo(cNode.pos.x * 10 +2 , cNode.pos.y * 10);
						this.graphics.lineTo(pNode.pos.x * 10 +2, pNode.pos.y * 10);
						deadDieWay(pNode)
					}
					return
					
				}else{
					return
				}
				
			}
			return
		}
		
		
		private function generateBlocks():void{
			var index:int = 0
			while(index < 200){
				var w:int =  1;
				var h:int =  1;
				var posx:int = viewRect.x + Math.random() * (viewRect.width - w) ;
				var posy:int = Math.random() * (viewRect.height - h);
				var newR:Rectangle = new Rectangle(posx,posy,w,h)
				var hasContain:Boolean = false
				for(var i:int=0 ; i < allRects.length ; i++){
					var r:Rectangle = allRects[i].mRect;
					var cr:Rectangle = new Rectangle(r.x - 3,r.y-3,r.width +6, r.height+6)
					if(cr.intersects(newR)){
						hasContain = true;
					}
				}
				if(!hasContain){
					var mazeRect:MazeRect = new MazeRect(newR);
					this.addChild(mazeRect);
					allRects.push(mazeRect);
					changeNodeState(newR)
				}
				index++
			}
				
			for(var j:int = 0 ; j < mazeNodes.length ; j++){
				var node:MazeNode = mazeNodes[j];
				var connects:Array = []
				for(var i:int = 0 ; i < dirs.length ; i++){
					var p:Point = node.pos.clone();
					var cp:Point = p.add(dirs[i]);
					cp.x = Math.min(Math.max(cp.x , 0),19)
					cp.y = Math.min(Math.max(cp.y , 0),49)
					if( getMazeNode(cp).state == 1){
						connects.push(i)
					}
				}
				node.connects = connects;	
				
			}
		}
		
		/**
		 * 改变节点状态 
		 * @param rect 已经生产的方块
		 * 
		 */
		private function changeNodeState(rect:Rectangle):void{
			for(var i:int = 0 ; i <= rect.height ; i++){
				var startIndex:int = (rect.y + i) * 20  + rect.x ;
				for(var j:int = startIndex ; j <= startIndex + rect.width ; j++ ){
					mazeNodes[j].state = 0;
					mazeNodes[j].isDead = true;
				}
			}
		}
		
		private function generateMaze():Boolean{
			if(findAll()){
				return false
			}
			var curNode:MazeNode = getMazeNode(currentPoint)
			if(curNode.connects == []){
				currentPoint = getConnectNodes().pos.clone();
				generateMaze();
				return true
			}else{
				var ran:Point = getRanDirect(curNode);			
				var nextPoint:Point = currentPoint.add(ran);
				nextPoint.x = Math.min(Math.max(nextPoint.x , 0),19)
				nextPoint.y = Math.min(Math.max(nextPoint.y , 0),49)
				var nextNode:MazeNode = getMazeNode(nextPoint);
			}
			
//			
			
			if(nextNode !=null){
				if(nextNode.state == 1){
					if(curNode != nextNode){
						curNode.childNodes.push(nextNode);
						nextNode.parentNodes.push(curNode);
					}
					
					nextNode.state = 0;
					connectNodes.push(nextNode);
					
					this.graphics.lineStyle(3,0xff0000);
					this.graphics.moveTo(currentPoint.x * 10 +2 , currentPoint.y * 10);
					this.graphics.lineTo(nextPoint.x * 10 +2, nextPoint.y * 10);
					currentPoint = nextNode.pos.clone();
					generateMaze();
				}else{
					currentPoint = getConnectNodes().pos.clone();
					generateMaze();
				}
				
			}else{
				currentPoint = getConnectNodes().pos.clone();
				generateMaze();
			}
			
			return false
			
		}
		
		private function findAll():Boolean{
			var counts:int = 0 ;
			for(var i:int = 0 ; i<mazeNodes.length ; i++){
				if(mazeNodes[i].state == 0){
					counts ++
				}
			}
			if(counts >=   mazeNodes.length-1){
				return true
			}
			return false;
		}
		
		private var dirs:Array = [new Point(0,1) , new Point(1,0) ,new Point(0,-1),new Point(-1,0)]
		
		private function getConnectNodes():MazeNode{
			for(var i:int = connectNodes.length - 1; i >=0 ; i--){
				if(connectNodes[i].connects.length <1){
					connectNodes.splice(i,1)
					return getConnectNodes()
				}
				
			}
			
			var l:int = connectNodes.length;
			var index:int = l * Math.random();
			var node:MazeNode = connectNodes[index];
				var connects:Array = []
				for(var i:int = 0 ; i < dirs.length ; i++){
					var p:Point = node.pos.clone();
					var cp:Point = p.add(dirs[i]);
					cp.x = Math.min(Math.max(cp.x , 0),19)
					cp.y = Math.min(Math.max(cp.y , 0),49)
					if( getMazeNode(cp).state == 1){
						connects.push(i)
					}
				}
				node.connects = connects;	
			
			return node
		}
		
		private function getMazeNode(p:Point):MazeNode{
			return mazeNodes[p.y * 20 + p.x]
		}
		
		private function getRanDirect(node:MazeNode):Point{
			var arr:Array = node.connects;
			var r:int = node.connects[int(Math.random() * arr.length)];
			switch(r)
			{
				case 0:
					return new Point(0,1);
				case 1:
					return new Point(1,0);
				case 2:
					return new Point(0,-1);
				case 3:
					return new Point(-1,0);
			}
			return new Point(1,1);
		}
		
	}
}