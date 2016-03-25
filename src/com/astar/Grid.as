package com.astar
{

	public class Grid
	{
		private var _startNode:Node ; 
		
		private var _endNode:Node ;
		//行数
		private var lineNum:int ;
		//列数
		private var rowNum:int ;
		
		private var nodeArray:Array ; 
		
		
		public function Grid()
		{
			
		}
		
		public function creatGrid(_lineNum:int , _rowNum:int):void{
			lineNum = _lineNum ;
			rowNum = _rowNum  ;
			nodeArray = new Array();
			for(var i:int = 0 ; i < _rowNum ; i++ ){
				nodeArray[i] = new Array() ; 
				for(var j:int = 0 ; j < _lineNum ; j++){
					var node:Node = new Node(i,j);
					nodeArray[i][j] = node ; 
				}
			}
		}
		
		public function get gridLineNum():int{
			return lineNum ; 
		}
		
		public function get gridRowNum():int{
			return rowNum ; 
		}
		
		public function get nodeArrayList():Array{
			return nodeArray ; 
		}
		
		public function get startNode():Node{
			return _startNode ; 
		}
		
		public function get endNode():Node{
			return _endNode ; 
		}
		
		public function setStartNode(_x:int,_y:int):void{
			_startNode = nodeArray[_x][_y] ;
		}
		
		public function setEndNode(_x:int , _y:int):void{
			_endNode = nodeArray[_x][_y] ; 
		}
		
		public function getNode(_x:int , _y:int):Node{
			return nodeArray[_x][_y] as Node 
		}
		
		public function setWalkAble(_x:int , _y:int , _walkable:Boolean):void{
			(nodeArray[_x][_y] as Node).walkable = _walkable ; 
		}
		
		
	}
}