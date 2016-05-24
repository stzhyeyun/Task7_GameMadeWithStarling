package data
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import block.Table;
	import block.Tile;

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
				for (var i:int = 0; i < _table.tiles.length; i++)
				{
					if (i < _table.tiles.length - 1)
					{
						plainText += _table.tiles[i].index + ", " +
									 _table.tiles[i].blockId + ", " +
									 _table.tiles[i].isFilled + ", ";
					}
					else
					{
						plainText += _table.tiles[i].index + ", " +
									 _table.tiles[i].blockId + ", " +
									 _table.tiles[i].isFilled + "]\n}";
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
				
				var index:int;
				var blockId:int;
				var isFilled:Boolean;
				var tile:Tile;
				for (var i:int = 0; i < plainText.table.length; i += 3)
				{
					index = plainText.table[i];
					blockId = plainText.table[i + 1];
					isFilled = plainText.table[i + 2];
					
					if (blockId >= 0 && isFilled)
					{
						// create tile with specific texture
					}
					else
					{
						// create tile with default texture
					}
					tile.blockId = blockId;
					tile.isFilled = isFilled;
						
					_table.addTile(tile);
				}
			}
		}
	}
}