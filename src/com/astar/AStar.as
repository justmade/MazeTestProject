package com.astar
{
	public class AStar
	{
		private var waits:Array ;
		
		private var closes:Array
		
		private var startNode:Node ;
		
		private var endNode:Node ; 
		
		private var pathArr:Array ; 
		
		private var grid:Grid ; 
		
		private var straight:int = 1 ;
		
		private var slash:Number = 20 ; 
		
		private var allNode:Array;
		
		public function AStar()
		{
		}
		
		public function setGrid(_grid:Grid):Boolean{
			grid = _grid ;
			waits = new Array();
			closes = new Array();
			allNode = new Array();
			startNode = grid.startNode ;
			endNode = grid.endNode ; 
			
			startNode.g = 0 ;
			startNode.h = getDistance(startNode);
			startNode.f = startNode.g + startNode.h ;
			
			return searchWay();
		}
		
		private function searchWay():Boolean{
			var centerNode:Node = startNode ; 
			while(centerNode != endNode){
				var startX:int = Math.max(0,centerNode._x -1);
				var startY:int = Math.max(0,centerNode._y -1);
				var endX:int = Math.min(grid.gridRowNum-1, centerNode._x+1);
				var endY:int = Math.min(grid.gridLineNum -1 ,centerNode._y+1);
				var count:int = 0
				for(var i:int = startX ; i <= endX ; i++){
					for(var j:int = startY ; j <= endY ; j++){
						count++;
//						if((count == 0 || count == 2 || count==6 || count == 8)) continue;
						var aimNode:Node = grid.getNode(i,j);
						if(aimNode == centerNode || aimNode.walkable == false||
						!grid.getNode(centerNode._x,aimNode._y).walkable||
						!grid.getNode(aimNode._x,centerNode._y).walkable) {continue;}
						if(aimNode._x == centerNode._x || aimNode._y == centerNode._y){
							var cost:Number = straight
						}else{
							cost = slash ; 
						}
						var g:Number = centerNode.g + cost ;
						var h:Number = getDistance(aimNode);
						var f:Number = g +h ;
						if(inWaits(aimNode) || inCloses(aimNode)){
							if(aimNode.f > f){
								aimNode.f = f ;
								aimNode.g = g;
								aimNode.h = h ; 
								aimNode.preNode = centerNode ; 
							}
						}else{
							aimNode.f = f ;
							aimNode.g = g;
							aimNode.h = h ; 
							aimNode.preNode = centerNode ; 
							waits.push(aimNode);
							allNode.push(aimNode);
						}
					}
				}
				closes.push(centerNode);
				if(waits.length == 0){
					trace("没有路径")
					return false ; 
				}
//				waits.sortOn("f",Array.NUMERIC);
				waits.sort(sortNode);
				centerNode = waits.shift() as Node ;
			}
			buildPaths();
			return true ;
		}
		
		private function sortNode(aNode:Node , bNode:Node):int{
			if(aNode.f < bNode.f){
				return -1
			}else if(aNode.f == bNode.f){
				return 0
			}else{
				return 1
			}
		}
		
		private function buildPaths():void{
			pathArr = new Array();
			var node:Node = endNode ;
			pathArr.push(node);
			while(node!=startNode){
				node = node.preNode
				pathArr.unshift(node);
			}
		}
		
		public function getOpens():Array{
			return allNode;
		}
		public function getPath():Array{
			return pathArr	;
		}
		
		private function getDistance(_node:Node):Number{
			var dx:int =Math.abs(_node._x -endNode._x);
			var dy:int =Math.abs(_node._y -endNode._y);
			var min:int = Math.min(dx,dy);
			var total:int = dx+dy ;
			return min * slash + (total - 2*min) *straight ; 
		}
		
//		private function getDistance(_node:Node):Number{
//			return Math.sqrt((_node._x * endNode._x) + (_node._y * endNode._y));
//		}
		
		private function inWaits(_node:Node):Boolean{
			for(var i:int = 0 ; i < waits.length ; i++){
				if(waits[i] == _node)return true ;
			}
			return false ;
		}
		
		private function inCloses(_node:Node):Boolean{
			for(var i:int = 0 ; i < closes.length ; i++){
				if(closes[i] == _node)return  true ;
			}
			return false ;
		}
		
		
	}
}