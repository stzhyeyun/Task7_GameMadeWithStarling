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
		
		private var _top:Tile;
		private var _bottom:Tile;
		private var _left:Tile;
		private var _right:Tile;
		
		public function get data():TileData
		{
			return _data;
		}
		
		public function set data(value:TileData):void
		{
			_data = value;
		}

		public function get top():Tile
		{
			return _top;
		}

		public function set top(value:Tile):void
		{
			_top = value;
		}

		public function get bottom():Tile
		{
			return _bottom;
		}

		public function set bottom(value:Tile):void
		{
			_bottom = value;
		}

		public function get left():Tile
		{
			return _left;
		}

		public function set left(value:Tile):void
		{
			_left = value;
		}

		public function get right():Tile
		{
			return _right;
		}

		public function set right(value:Tile):void
		{
			_right = value;
		}

		
		public function Tile(tileData:TileData)
		{
			_data = tileData;

			super(Resources.getTexture(_data.textureName));
			
			top = null;
			bottom = null;
			left = null;
			right = null;
		}
		
		public override function dispose():void
		{
			top = null;
			bottom = null;
			left = null;
			right = null;
			
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
		
		public function checkLineEmpty(direction:int, range:int):Boolean
		{
//			if (_isFilled)
//			{
//				return false;
//			}
//			
			range--;
			if (range == 0)
			{
				return true;
			}
			
			switch (direction)
			{
				case UP:
				{
					if (_top)
						return _top.checkLineEmpty(direction, range);
					else
						return false;
				}
					break;
				
				case DOWN:
				{
					if (_bottom)
						return _bottom.checkLineEmpty(direction, range);
					else
						return false;
				}
					break;
				
				case LEFT:
				{
					if (_left)
						return _left.checkLineEmpty(direction, range);
					else
						return false;
				}
					break;
				
				case RIGHT:
				{
					if (_right)
						return _right.checkLineEmpty(direction, range);
					else
						return false;
				}
					break;
				
				default:
				{
					trace(TAG + " checkLineEmpty : Invalid direction.");
					return false;
				}
					break;
			}
		}
		
		public function checkLineFilled(direction:int):Boolean
		{
//			if (!_isFilled)
//			{
//				return false;	
//			}
			
			switch (direction)
			{
				case UP:
				{
					if (_top)
						return _top.checkLineFilled(direction);
					else
						return true;
				}
					break;
				
				case DOWN:
				{
					if (_bottom)
						return _bottom.checkLineFilled(direction);
					else
						return true;
				}
					break;
				
				case LEFT:
				{
					if (_left)
						return _left.checkLineFilled(direction);
					else
						return true;
				}
					break;
				
				case RIGHT:
				{
					if (_right)
						return _right.checkLineFilled(direction);
					else
						return true;
				}
					break;
				
				default:
				{
					trace(TAG + " checkLineFilled : Invalid direction.");
					return false;
				}
					break;
			}
		}
		
		public function clear(direction:int):void
		{
//			_blockType = null;
//			_isFilled = false;
//			this.texture = Resources.getTexture(ResourcesName.ATLAS, ResourcesName.WHITE);
			
			switch (direction)
			{
				case VERTICAL:
				{
					if (_top) _top.clear(UP);
					if (_bottom) _bottom.clear(DOWN);
				}
					break;
				
				case HORIZONTAL:
				{
					if (_left) _left.clear(LEFT);
					if (_right) _right.clear(RIGHT);
				}
					break;
				
				case UP:
				{
					if (_top) _top.clear(direction);
				}
					break;
				
				case DOWN:
				{
					if (_bottom) _bottom.clear(direction);
				}
					break;
				
				case LEFT:
				{
					if (_left) _left.clear(direction);
				}
					break;
				
				case RIGHT:
				{
					if (_right) _right.clear(direction);
				}
					break;
			}
		}
	}
}