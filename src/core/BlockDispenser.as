package core
{
	import resources.TextureName;

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
			oneO.addData(new TileData(0, 0, TextureName.TILE_YELLOW));
			_data.push(oneO);
			
			var twoO:BlockData = new BlockData();
			twoO.addData(new TileData(0, 0, TextureName.TILE_YELLOW));
			twoO.addData(new TileData(0, 1, TextureName.TILE_YELLOW));
			twoO.addData(new TileData(1, 0, TextureName.TILE_YELLOW));
			twoO.addData(new TileData(1, 1, TextureName.TILE_YELLOW));
			_data.push(twoO);
			
			var threeO:BlockData = new BlockData();
			threeO.addData(new TileData(0, 0, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(0, 1, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(0, 2, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(1, 0, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(1, 1, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(1, 2, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(2, 0, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(2, 1, TextureName.TILE_YELLOW));
			threeO.addData(new TileData(2, 2, TextureName.TILE_YELLOW));
			_data.push(threeO);
			
			// I (Vertical)
			var twoVerticalI:BlockData = new BlockData();
			twoVerticalI.addData(new TileData(0, 0, TextureName.TILE_RED));
			twoVerticalI.addData(new TileData(0, 1, TextureName.TILE_RED));
			_data.push(twoVerticalI);
			
			var threeVerticalI:BlockData = new BlockData();
			threeVerticalI.addData(new TileData(0, 0, TextureName.TILE_RED));
			threeVerticalI.addData(new TileData(0, 1, TextureName.TILE_RED));
			threeVerticalI.addData(new TileData(0, 2, TextureName.TILE_RED));
			_data.push(threeVerticalI);
			
			var fourVerticalI:BlockData = new BlockData();
			fourVerticalI.addData(new TileData(0, 0, TextureName.TILE_RED));
			fourVerticalI.addData(new TileData(0, 1, TextureName.TILE_RED));
			fourVerticalI.addData(new TileData(0, 2, TextureName.TILE_RED));
			fourVerticalI.addData(new TileData(0, 3, TextureName.TILE_RED));
			_data.push(fourVerticalI);
			
			var fiveVerticalI:BlockData = new BlockData();
			fiveVerticalI.addData(new TileData(0, 0, TextureName.TILE_RED));
			fiveVerticalI.addData(new TileData(0, 1, TextureName.TILE_RED));
			fiveVerticalI.addData(new TileData(0, 2, TextureName.TILE_RED));
			fiveVerticalI.addData(new TileData(0, 3, TextureName.TILE_RED));
			fiveVerticalI.addData(new TileData(0, 4, TextureName.TILE_RED));
			_data.push(fiveVerticalI);
			
			// I (Horizontal)
			var twoHorizontalI:BlockData = new BlockData();
			twoHorizontalI.addData(new TileData(0, 0, TextureName.TILE_ORANGE));
			twoHorizontalI.addData(new TileData(1, 0, TextureName.TILE_ORANGE));
			_data.push(twoHorizontalI);
			
			var threeHorizontalI:BlockData = new BlockData();
			threeHorizontalI.addData(new TileData(0, 0, TextureName.TILE_ORANGE));
			threeHorizontalI.addData(new TileData(1, 0, TextureName.TILE_ORANGE));
			threeHorizontalI.addData(new TileData(2, 0, TextureName.TILE_ORANGE));
			_data.push(threeHorizontalI);
			
			var fourHorizontalI:BlockData = new BlockData();
			fourHorizontalI.addData(new TileData(0, 0, TextureName.TILE_ORANGE));
			fourHorizontalI.addData(new TileData(1, 0, TextureName.TILE_ORANGE));
			fourHorizontalI.addData(new TileData(2, 0, TextureName.TILE_ORANGE));
			fourHorizontalI.addData(new TileData(3, 0, TextureName.TILE_ORANGE));
			_data.push(fourHorizontalI);
			
			var fiveHorizontalI:BlockData = new BlockData();
			fiveHorizontalI.addData(new TileData(0, 0, TextureName.TILE_ORANGE));
			fiveHorizontalI.addData(new TileData(1, 0, TextureName.TILE_ORANGE));
			fiveHorizontalI.addData(new TileData(2, 0, TextureName.TILE_ORANGE));
			fiveHorizontalI.addData(new TileData(3, 0, TextureName.TILE_ORANGE));
			fiveHorizontalI.addData(new TileData(4, 0, TextureName.TILE_ORANGE));
			_data.push(fiveHorizontalI);
			
			// L (LeftTop)
			var twoLefttopL:BlockData = new BlockData();
			twoLefttopL.addData(new TileData(0, 0, TextureName.TILE_GREEN));
			twoLefttopL.addData(new TileData(0, 1, TextureName.TILE_GREEN));
			twoLefttopL.addData(new TileData(1, 0, TextureName.TILE_GREEN));
			_data.push(twoLefttopL);
			
			var threeLefttopL:BlockData = new BlockData();
			threeLefttopL.addData(new TileData(0, 0, TextureName.TILE_BLUE));
			threeLefttopL.addData(new TileData(0, 1, TextureName.TILE_BLUE));
			threeLefttopL.addData(new TileData(0, 2, TextureName.TILE_BLUE));
			threeLefttopL.addData(new TileData(1, 0, TextureName.TILE_BLUE));
			threeLefttopL.addData(new TileData(2, 0, TextureName.TILE_BLUE));
			_data.push(threeLefttopL);
			
			// L (LeftBottom)
			var twoLeftbottomL:BlockData = new BlockData();
			twoLeftbottomL.addData(new TileData(0, 0, TextureName.TILE_GREEN));
			twoLeftbottomL.addData(new TileData(0, 1, TextureName.TILE_GREEN));
			twoLeftbottomL.addData(new TileData(1, 1, TextureName.TILE_GREEN));
			_data.push(twoLeftbottomL);
			
			var threeLeftbottomL:BlockData = new BlockData();
			threeLeftbottomL.addData(new TileData(0, 0, TextureName.TILE_BLUE));
			threeLeftbottomL.addData(new TileData(0, 1, TextureName.TILE_BLUE));
			threeLeftbottomL.addData(new TileData(0, 2, TextureName.TILE_BLUE));
			threeLeftbottomL.addData(new TileData(1, 2, TextureName.TILE_BLUE));
			threeLeftbottomL.addData(new TileData(2, 2, TextureName.TILE_BLUE));
			_data.push(threeLeftbottomL);
			
			// L (RightTop)
			var twoRighttopL:BlockData = new BlockData();
			twoRighttopL.addData(new TileData(0, 0, TextureName.TILE_GREEN));
			twoRighttopL.addData(new TileData(1, 0, TextureName.TILE_GREEN));
			twoRighttopL.addData(new TileData(1, 1, TextureName.TILE_GREEN));
			_data.push(twoRighttopL);
			
			var threeRighttopL:BlockData = new BlockData();
			threeRighttopL.addData(new TileData(0, 0, TextureName.TILE_BLUE));
			threeRighttopL.addData(new TileData(1, 0, TextureName.TILE_BLUE));
			threeRighttopL.addData(new TileData(2, 0, TextureName.TILE_BLUE));
			threeRighttopL.addData(new TileData(2, 1, TextureName.TILE_BLUE));
			threeRighttopL.addData(new TileData(2, 2, TextureName.TILE_BLUE));
			_data.push(threeRighttopL);
			
			// L (RightBottom)
			var twoRightbottomL:BlockData = new BlockData();
			twoRightbottomL.addData(new TileData(1, 0, TextureName.TILE_GREEN));
			twoRightbottomL.addData(new TileData(1, 1, TextureName.TILE_GREEN));
			twoRightbottomL.addData(new TileData(0, 1, TextureName.TILE_GREEN));
			_data.push(twoRightbottomL);
			
			var threeRightbottomL:BlockData = new BlockData();
			threeRightbottomL.addData(new TileData(2, 0, TextureName.TILE_BLUE));
			threeRightbottomL.addData(new TileData(2, 1, TextureName.TILE_BLUE));
			threeRightbottomL.addData(new TileData(2, 2, TextureName.TILE_BLUE));
			threeRightbottomL.addData(new TileData(1, 2, TextureName.TILE_BLUE));
			threeRightbottomL.addData(new TileData(0, 2, TextureName.TILE_BLUE));
			_data.push(threeRightbottomL);
		}
		
		public static function pop():BlockData
		{
			var index:int = Math.random() * _data.length;
			
			return _data[index];
		}
	}
}