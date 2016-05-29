package gamedata
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import core.BlockData;
	import core.TableData;
	import core.TileData;

	public class PlayData extends Data
	{
		private const TAG:String = "[PlayData]";
		
		private var _bestScore:int;
		private var _currentScore:int;
		private var _tableData:TableData;
		private var _blocksData:Vector.<BlockData>

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
		
		public function get tableData():TableData
		{
			return _tableData;
		}
		
		public function set tableData(value:TableData):void
		{
			_tableData = value;
		}
	
		
		public function PlayData(name:String, path:File)
		{
			super(name, path);
			
			_bestScore = 0;
			_currentScore = 0;
			_tableData = null;
			_blocksData = null;
		}
		
		public override function dispose():void
		{
			// to do
			
			
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
									"\t\"currentScore\" : "	+	_currentScore.toString();

			if (_tableData)
			{
				plainText += _tableData.export();
			}
			
			if (_blocksData)
			{
				plainText += ",\n\t\"blocksData\" : [";
				for (var i:int = 0; i < _blocksData.length; i++)
				{
					plainText += _blocksData[i].export();	
				}
				plainText += "]";
			}
			
			plainText += "\n}";
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
			
			if (plainText.tableSize)
			{
				_tableData = new TableData();
				_tableData.size = plainText.tableSize;
				
				var data:Vector.<Vector.<TileData>> = new Vector.<Vector.<TileData>>();
				var plainTextIndex:int = 0;
				for (var i:int = 0; i < _tableData.size; i++)
				{
					data[i] = new Vector.<TileData>();
					
					for (var j:int = 0; j < _tableData.size; j++)
					{
						data[i].push(new TileData(
							plainText.tableData[plainTextIndex++],
							plainText.tableData[plainTextIndex++],
							plainText.tableData[plainTextIndex++]));
					}
				}
				_tableData.data = data;
			}
			
			if (plainText.blocksData)
			{
				_blocksData = new Vector.<BlockData>();
				
				var blockData:BlockData;
				var count:int = 0;
				var length:int;
				for (i = 0; i < plainText.blocksData.length; )
				{
					blockData = new BlockData();
					length = plainText.blocksData[i++];
					
					while (count < length)
					{
						blockData.addData(
							new TileData(plainText.blocksData[i++], plainText.blocksData[i++], plainText.blocksData[i++]));
						count++;
					}
					
					_blocksData.push(blockData);
					count = 0;
				}
			}
		}
		
		public function setBlockData(index:int, data:BlockData):void
		{
			
		}
		
		public function clean():void
		{
			_currentScore = 0;
			_tableData = null;
			_blocksData = null;
		}
	}
}