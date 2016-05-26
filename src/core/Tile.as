package core
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import resources.Resources;
	
	import starling.display.Image;

	public class Tile extends Image
	{
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1;
		public static const UP:int = 2;
		public static const DOWN:int = 3;
		public static const LEFT:int = 4;
		public static const RIGHT:int = 5;
	
		private const TAG:String = "[Tile]"; 
		
		private var _data:TileData;
		
		public function get data():TileData
		{
			return _data;
		}
		
		public function set data(value:TileData):void
		{
			_data = value;
		}

		
		public function Tile(tileData:TileData)
		{
			_data = tileData;

			super(Resources.getTexture(_data.textureName));
		}
		
		public override function dispose():void
		{
			_data = null;
			
			super.dispose();
		}
		
		public function getDistance(target:Tile):Number
		{
			var globalBoundA:Rectangle = this.getBounds(Main.current);
			var globalBoundB:Rectangle = target.getBounds(Main.current);
			
			var globalCenterA:Point =
				new Point(globalBoundA.x + globalBoundA.width / 2, globalBoundA.y + globalBoundA.height / 2);
			var globalCenterB:Point =
				new Point(globalBoundB.x + globalBoundB.width / 2, globalBoundB.y + globalBoundB.height / 2);
			
			var dx:Number = globalCenterA.x - globalCenterB.x;
			var dy:Number = globalCenterA.y - globalCenterB.y;
			
			globalBoundA = null;
			globalBoundB = null;
			globalCenterA = null;
			globalCenterB = null;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
	}
}