package gamedata
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;

	/**
	 * 인게임 환경설정 정보입니다. (배경음악, 효과음)
	 * @author user
	 * 
	 */
	public class SettingData extends Data
	{
		private const TAG:String = "[SettingData]";
		
		private var _bgm:Boolean;
		private var _sound:Boolean;
		private var _bannedPopups:Dictionary;

		public function get bgm():Boolean
		{
			return _bgm;
		}
		
		public function set bgm(value:Boolean):void
		{
			_bgm = value;
		}
		
		public function get sound():Boolean
		{
			return _sound;
		}
		
		public function set sound(value:Boolean):void
		{
			_sound = value;
		}
		
		public function get bannedPopups():Dictionary
		{
			return _bannedPopups;
		}

		
		public function SettingData(name:String, path:File)
		{
			super(name, path);
			
			_bgm = true;
			_sound = true;
			_bannedPopups = null;
		}

		/**
		 * SettingData를 AES-128로 암호화하여 JSON 파일로 출력합니다.   
		 * 
		 */
		public override function write():void
		{
			if (!_fileName || !_path)
			{
				if (!_fileName) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				return;
			}
			
			var plainText:String =	"{\n\t\"bgm\" : "	+	_bgm.toString()		+	",\n"	+
									"\t\"sound\" : "	+	_sound.toString();
			
			if (_bannedPopups)
			{
				var index:int = 0;
				plainText += ",\n\t\"bannedPopups\" : [";
				for (var key:String in _bannedPopups)
				{
					if (index != 0)
					{
						plainText += ", ";
					}
					plainText += "\"" + key + "\", \"" + _bannedPopups[key] + "\"";
					index++;
				}
				plainText += "]";
			}
			plainText += "\n}";
			
			plainText = AesCrypto.encrypt(plainText, "ahundrendblocksbybamkie");
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath(_fileName + ".json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(plainText);
			stream.close();
			
			plainText = null;
			stream = null;
			file = null;
		}
		
		protected override function onCompleteLoad(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (!loader)
			{
				return;
			}
			
			var plainText:Object = JSON.parse(AesCrypto.decrypt(loader.data, "ahundrendblocksbybamkie"));
			
			_bgm = plainText.bgm;
			_sound = plainText.sound;
			
			if (plainText.bannedPopups)
			{
				_bannedPopups = new Dictionary();
				for (var i:int = 0; i < plainText.bannedPopups.length; i += 2)
				{
					_bannedPopups[plainText.bannedPopups[i]] = plainText.bannedPopups[i + 1];
				}
			}
			
			super.onCompleteLoad(event);
		}
		
		/**
		 * 오늘 다시 보지 않을 팝업을 등록합니다. 
		 * @param name 팝업의 이릅입니다.
		 * 
		 */
		public function addBannedPopup(name:String):void
		{
			if (!name)
			{
				trace(TAG + " addBannedPopup : No name.");
				return;
			}
			
			// 현재 시간 저장
			var today:Date = new Date();
			var formatter:DateTimeFormatter = new DateTimeFormatter("date");
			formatter.setDateTimePattern("yyyy-MM-dd");
			
			if (!_bannedPopups)
			{
				_bannedPopups = new Dictionary();
			}
			_bannedPopups[name] = formatter.format(today);
		}
		
		/**
		 * 오늘 다시 보지 않도록 설정한 팝업인지 여부를 확인합니다. 
		 * @param name 팝업의 이름입니다.
		 * @return 
		 * 
		 */
		public function isBannedPopup(name:String):Boolean
		{
			if (_bannedPopups && _bannedPopups[name])
			{
				var bannedDateStr:String = _bannedPopups[name];
				var bannedYear:Number = Number(bannedDateStr.substring(0, bannedDateStr.indexOf("-")));
				
				bannedDateStr = bannedDateStr.substring(bannedDateStr.indexOf("-") + 1, bannedDateStr.length);
				var bannedMonth:Number = Number(bannedDateStr.substring(0, bannedDateStr.indexOf("-")));
				
				var bannedDate:Number = Number(bannedDateStr.substring(bannedDateStr.indexOf("-") + 1, bannedDateStr.length));
				
				var today:Date = new Date();
				
				// 등록된 날짜가 오늘이면 true 아니면 false
				if (today.getFullYear() == bannedYear &&
					today.getMonth() + 1 == bannedMonth &&
					today.getDate() == bannedDate)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
}