package data
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import block.Table;
	import block.Tile;
	
	import resources.Resources;
	import resources.ResourcesName;

	public class PlayData extends Data
	{
		private const TAG:String = "[PlayData]";
		
		private var _bestScore:int;
		private var _currentScore:int;
		private var _table:Table;

		public function get bestScore():int
		{
			return _bestScore;
		}
		
		public function set bestScore(value:int):void
		{
			_bestScore = value;
		}
		
		public function get currentScore():int
		{
			return _currentScore;
		}
		
		public function set currentScore(value:int):void
		{
			_currentScore = value;
		}
		
		public function get table():Table
		{
			return _table;
		}
		
		public function set table(value:Table):void
		{
			_table = value;
		}
		
		
		public function PlayData(name:String, path:File)
		{
			super(name, path);
			
			_bestScore = 0;
			_currentScore = 0;
			_table = null;
		}

		public override function dispose():void
		{
			if (_table)
			{
				_table.dispose();
			}
			_table = null;
			
			super.dispose();
		}
		
		/**
		 * PlayData를 AES-128로 암호화하여 JSON 파일로 출력합니다.   
		 * 
		 */
		public override function write():void
		{
			if (!_name || !_path || _currentScore == 0)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				if (!_currentScore == 0) trace(TAG + " write : No necessity of writing.");
				return;
			}
			
			var plainText:String = "{\n\t\"bestScore\" : "	+	_bestScore.toString()		+	",\n"	+
									"\t\"currentScore\" : "	+	_currentScore.toString()	+	",\n" +
									"\t\"table\" : [";
			
			if (_table && _table.tiles)
			{
				var tiles:Vector.<Vector.<Tile>> = _table.tiles;
				for (var i:int = 0; i < tiles.length; i++)
				{
					for (var j:int = 0; j < tiles[i].length; j++)
					{
						if (i < tiles.length - 1)
						{
							plainText += tiles[i][j].blockType + ", " +
										 tiles[i][j].isFilled + ", ";
						}
						else
						{
							plainText += tiles[i][j].blockType + ", " +
										 tiles[i][j].isFilled + "]\n}";
						}
					}
				}
			}
			else
			{
				plainText += "]\n}";
			}
			
			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath(_name + ".json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(plainText);
			stream.close();
			
			plainText = null;
			stream = null;
			file = null;
		}
		
		protected override function onCompleteLoad(event:Event):void
		{
			super.onCompleteLoad(event);
			
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_bestScore = plainText.bestScore;
			_currentScore = plainText.currentScore;
			
			if (plainText.table.length > 0)
			{
				_table = new Table();
				
				var tiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
				var tile:Tile;
				var blockType:String;
				var isFilled:Boolean;
				var indexI:int = 0;
				
				for (var i:int = 0; i < plainText.table.length; i += 2)
				{
					blockType = plainText.table[i];
					isFilled = plainText.table[i + 1];
					
					if (blockType && isFilled)
					{
						tile = new Tile(Resources.getTexture(ResourcesName.ATLAS, blockType));
					}
					else
					{
						tile = new Tile(Resources.getTexture(ResourcesName.ATLAS, ResourcesName.TILE_EMPTY));
					}
					tile.blockType = blockType;
					tile.isFilled = isFilled;
					
					if (!tiles[indexI])
					{
						tiles[indexI] = new Vector.<Tile>();
					}
					tiles[indexI].push(tile);
					
					if (i != 0 && i % 20 == 0)
					{
						indexI++;
					}
				}
				_table.tiles = tiles;
			}
		}
	}
}