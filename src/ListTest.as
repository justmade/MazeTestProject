package
{
	import com.sociodox.theminer.TheMiner;
	import com.sty.display.ItemRender;
	import com.sty.display.SList;
	
	import flash.display.Sprite;
	[SWF(frameRate="60")]
	public class ListTest extends Sprite
	{
		public function ListTest()
		{
			var arr:Array = new Array();
			for(var i:int = 0 ; i < 4 ;arr.push(i++));
			var list:SList = new SList();
			list.setSize(200,200);
			list.itemClass = ItemRender;
			list.gap = 20;
			list.itemsData = arr;
			this.addChild(list);
			
			this.addChild(new TheMiner());
		}
	}
}