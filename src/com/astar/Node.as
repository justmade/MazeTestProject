package com.astar
{
	

	public class Node
	{
		public var _x:int ;
		
		public var _y:int ;
		 
		public var f:Number ; 
		
		public var g:Number ;
		
		public var h:Number ;
		
		public var walkable:Boolean = true;
		
		public var preNode:Node ;
		
		public var isPath:Boolean ; 
		
		public var isFind:Boolean ; 
		
		
		public function Node(_x:int,_y:int)
		{
			this._x = _x ;
			this._y = _y ; 
		}
		
	}
}