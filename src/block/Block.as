package block
{
	import starling.display.Sprite;

	public class Block extends Sprite
	{
		private const TAG:String = "[Block]";
		
		private var _type:String;
		private var _tiles:Vector.<Tile>;
		
		public function get type():String
		{
			return _type;
		}

		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}
		
		
		public function Block()
		{
			_type = null;
		}
		
		public override function dispose():void
		{
			_type = null;
			
			if (_tiles)
			{
				for (var i:int = 0; i < _tiles.length; i++)
				{
					_tiles[i].dispose();
					_tiles[i] = null;
				}
				_tiles.splice(0, _tiles.length);
			}
			_tiles = null;	
			
			super.dispose();
		}
		
		public function initialize(type:String):void
		{
			_type = type;
			
			switch (_type)
			{
				case BlockType.I_TWO_VERTICAL:
				{
					
				}
					break;
				
				case BlockType.I_THREE_VERTICAL:
				{
					
				}
					break;
				
				case BlockType.I_FOUR_VERTICAL:
				{
					
				}
					break;
				
				case BlockType.I_FIVE_VERTICAL:
				{
					
				}
					break;
				
				case BlockType.I_TWO_HORIZONTAL:
				{
					
				}
					break;
				
				case BlockType.I_THREE_HORIZONTAL:
				{
					
				}
					break;
				
				case BlockType.I_FOUR_HORIZONTAL:
				{
					
				}
					break;
				
				case BlockType.I_FIVE_HORIZONTAL:
				{
					
				}
					break;
				
				case BlockType.L_TWO_LEFTTOP:
				{
					
				}
					break;
				
				case BlockType.L_TWO_LEFTBOTTOM:
				{
					
				}
					break;
				
				case BlockType.L_TWO_RIGHTTOP:
				{
					
				}
					break;
				
				case BlockType.L_TWO_RIGHTBOTTOM:
				{
					
				}
					break;
				
				case BlockType.L_THREE_LEFTTOP:
				{
					
				}
					break;
				
				case BlockType.L_THREE_LEFTBOTTOM:
				{
					
				}
					break;
				
				case BlockType.L_THREE_RIGHTTOP:
				{
					
				}
					break;
				
				case BlockType.L_THREE_RIGHTBOTTOM:
				{
					
				}
					break;
				
				case BlockType.O_ONE:
				{
					
				}
					break;
				
				case BlockType.O_TWO:
				{
					
				}
					break;
				
				case BlockType.O_THREE:
				{
					
				}
					break;
				
				default:
				{
					_type = null;
					trace(TAG + " initialize : Invalid block type.");
				}
					break;
			} // switch (_type)
		} // public function initialize(id:int):void
	}
}