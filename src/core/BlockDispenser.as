package core
{
	import resources.ResourcesName;

	public class BlockDispenser
	{
		private static var _data:Vector.<BlockData>;
		
		public function BlockDispenser()
		{
			
		}		
		
		public static function initialize():void
		{
			_data = new Vector.<BlockData>();
			
			// O
			var oneO:BlockData = new BlockData();
			oneO.addData(new TileData(0, 0, ResourcesName.YELLOW));
			_data.push(oneO);
			
			var twoO:BlockData = new BlockData();
			twoO.addData(new TileData(0, 0, ResourcesName.YELLOW));
			twoO.addData(new TileData(0, 1, ResourcesName.YELLOW));
			twoO.addData(new TileData(1, 0, ResourcesName.YELLOW));
			twoO.addData(new TileData(1, 1, ResourcesName.YELLOW));
			_data.push(twoO);
			
			var threeO:BlockData = new BlockData();
			threeO.addData(new TileData(0, 0, ResourcesName.YELLOW));
			threeO.addData(new TileData(0, 1, ResourcesName.YELLOW));
			threeO.addData(new TileData(0, 2, ResourcesName.YELLOW));
			threeO.addData(new TileData(1, 0, ResourcesName.YELLOW));
			threeO.addData(new TileData(1, 1, ResourcesName.YELLOW));
			threeO.addData(new TileData(1, 2, ResourcesName.YELLOW));
			threeO.addData(new TileData(2, 0, ResourcesName.YELLOW));
			threeO.addData(new TileData(2, 1, ResourcesName.YELLOW));
			threeO.addData(new TileData(2, 2, ResourcesName.YELLOW));
			_data.push(threeO);
			
			// I (Vertical)
			var twoVerticalI:BlockData = new BlockData();
			twoVerticalI.addData(new TileData(0, 0, ResourcesName.RED));
			twoVerticalI.addData(new TileData(0, 1, ResourcesName.RED));
			_data.push(twoVerticalI);
			
			var threeVerticalI:BlockData = new BlockData();
			threeVerticalI.addData(new TileData(0, 0, ResourcesName.RED));
			threeVerticalI.addData(new TileData(0, 1, ResourcesName.RED));
			threeVerticalI.addData(new TileData(0, 2, ResourcesName.RED));
			_data.push(threeVerticalI);
			
			var fourVerticalI:BlockData = new BlockData();
			fourVerticalI.addData(new TileData(0, 0, ResourcesName.RED));
			fourVerticalI.addData(new TileData(0, 1, ResourcesName.RED));
			fourVerticalI.addData(new TileData(0, 2, ResourcesName.RED));
			fourVerticalI.addData(new TileData(0, 3, ResourcesName.RED));
			_data.push(fourVerticalI);
			
			var fiveVerticalI:BlockData = new BlockData();
			fiveVerticalI.addData(new TileData(0, 0, ResourcesName.RED));
			fiveVerticalI.addData(new TileData(0, 1, ResourcesName.RED));
			fiveVerticalI.addData(new TileData(0, 2, ResourcesName.RED));
			fiveVerticalI.addData(new TileData(0, 3, ResourcesName.RED));
			fiveVerticalI.addData(new TileData(0, 4, ResourcesName.RED));
			_data.push(fiveVerticalI);
			
			// I (Horizontal)
			var twoHorizontalI:BlockData = new BlockData();
			twoHorizontalI.addData(new TileData(0, 0, ResourcesName.ORANGE));
			twoHorizontalI.addData(new TileData(1, 0, ResourcesName.ORANGE));
			_data.push(twoHorizontalI);
			
			var threeHorizontalI:BlockData = new BlockData();
			threeHorizontalI.addData(new TileData(0, 0, ResourcesName.ORANGE));
			threeHorizontalI.addData(new TileData(1, 0, ResourcesName.ORANGE));
			threeHorizontalI.addData(new TileData(2, 0, ResourcesName.ORANGE));
			_data.push(threeHorizontalI);
			
			var fourHorizontalI:BlockData = new BlockData();
			fourHorizontalI.addData(new TileData(0, 0, ResourcesName.ORANGE));
			fourHorizontalI.addData(new TileData(1, 0, ResourcesName.ORANGE));
			fourHorizontalI.addData(new TileData(2, 0, ResourcesName.ORANGE));
			fourHorizontalI.addData(new TileData(3, 0, ResourcesName.ORANGE));
			_data.push(fourHorizontalI);
			
			var fiveHorizontalI:BlockData = new BlockData();
			fiveHorizontalI.addData(new TileData(0, 0, ResourcesName.ORANGE));
			fiveHorizontalI.addData(new TileData(1, 0, ResourcesName.ORANGE));
			fiveHorizontalI.addData(new TileData(2, 0, ResourcesName.ORANGE));
			fiveHorizontalI.addData(new TileData(3, 0, ResourcesName.ORANGE));
			fiveHorizontalI.addData(new TileData(4, 0, ResourcesName.ORANGE));
			_data.push(fiveHorizontalI);
			
			// L (LeftTop)
			var twoLefttopL:BlockData = new BlockData();
			twoLefttopL.addData(new TileData(0, 0, ResourcesName.GREEN));
			twoLefttopL.addData(new TileData(0, 1, ResourcesName.GREEN));
			twoLefttopL.addData(new TileData(1, 0, ResourcesName.GREEN));
			_data.push(twoLefttopL);
			
			var threeLefttopL:BlockData = new BlockData();
			threeLefttopL.addData(new TileData(0, 0, ResourcesName.BLUE));
			threeLefttopL.addData(new TileData(0, 1, ResourcesName.BLUE));
			threeLefttopL.addData(new TileData(0, 2, ResourcesName.BLUE));
			threeLefttopL.addData(new TileData(1, 0, ResourcesName.BLUE));
			threeLefttopL.addData(new TileData(2, 0, ResourcesName.BLUE));
			_data.push(threeLefttopL);
			
			// L (LeftBottom)
			var twoLeftbottomL:BlockData = new BlockData();
			twoLeftbottomL.addData(new TileData(0, 0, ResourcesName.GREEN));
			twoLeftbottomL.addData(new TileData(0, 1, ResourcesName.GREEN));
			twoLeftbottomL.addData(new TileData(1, 1, ResourcesName.GREEN));
			_data.push(twoLeftbottomL);
			
			var threeLeftbottomL:BlockData = new BlockData();
			threeLeftbottomL.addData(new TileData(0, 0, ResourcesName.BLUE));
			threeLeftbottomL.addData(new TileData(0, 1, ResourcesName.BLUE));
			threeLeftbottomL.addData(new TileData(0, 2, ResourcesName.BLUE));
			threeLeftbottomL.addData(new TileData(1, 2, ResourcesName.BLUE));
			threeLeftbottomL.addData(new TileData(2, 2, ResourcesName.BLUE));
			_data.push(threeLeftbottomL);
			
			// L (RightTop)
			var twoRighttopL:BlockData = new BlockData();
			twoRighttopL.addData(new TileData(0, 0, ResourcesName.GREEN));
			twoRighttopL.addData(new TileData(1, 0, ResourcesName.GREEN));
			twoRighttopL.addData(new TileData(1, 1, ResourcesName.GREEN));
			_data.push(twoRighttopL);
			
			var threeRighttopL:BlockData = new BlockData();
			threeRighttopL.addData(new TileData(0, 0, ResourcesName.BLUE));
			threeRighttopL.addData(new TileData(1, 0, ResourcesName.BLUE));
			threeRighttopL.addData(new TileData(2, 0, ResourcesName.BLUE));
			threeRighttopL.addData(new TileData(2, 1, ResourcesName.BLUE));
			threeRighttopL.addData(new TileData(2, 2, ResourcesName.BLUE));
			_data.push(threeRighttopL);
			
			// L (RightBottom)
			var twoRightbottomL:BlockData = new BlockData();
			twoRightbottomL.addData(new TileData(1, 0, ResourcesName.GREEN));
			twoRightbottomL.addData(new TileData(1, 1, ResourcesName.GREEN));
			twoRightbottomL.addData(new TileData(0, 1, ResourcesName.GREEN));
			_data.push(twoRightbottomL);
			
			var threeRightbottomL:BlockData = new BlockData();
			threeRightbottomL.addData(new TileData(2, 0, ResourcesName.BLUE));
			threeRightbottomL.addData(new TileData(2, 1, ResourcesName.BLUE));
			threeRightbottomL.addData(new TileData(2, 2, ResourcesName.BLUE));
			threeRightbottomL.addData(new TileData(1, 2, ResourcesName.BLUE));
			threeRightbottomL.addData(new TileData(0, 2, ResourcesName.BLUE));
			_data.push(threeRightbottomL);
		}
		
		public static function pop():BlockData
		{
			var index:int = Math.random() * _data.length;
			
			return _data[index];
		}
	}
}