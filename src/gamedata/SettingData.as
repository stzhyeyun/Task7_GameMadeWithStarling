package gamedata
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;

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

		private var _onReadyToPreset:Function;
		
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
		
		public function set onReadyToPreset(value:Function):void
		{
			_onReadyToPreset = value;
		}

		
		public function SettingData(name:String, path:File)
		{
			super(name, path);
			
			_bgm = true;
			_sound = true;
			_onReadyToPreset = null;
		}
		
		public override function dispose():void
		{
			_onReadyToPreset = null;
			
			super.dispose();
		}
		
		/**
		 * SettingData를 AES-128로 암호화하여 JSON 파일로 출력합니다.   
		 * 
		 */
		public override function write():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " write : No name.");
				if (!_path) trace(TAG + " write : No path.");				
				return;
			}
			
			var plainText:String =	"{\n\t\"bgm\" : "	+	_bgm.toString()		+	",\n"	+
									"\t\"sound\" : "	+	_sound.toString()	+	"\n}";
			
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
			
			_bgm = plainText.bgm;
			_sound = plainText.sound;
			
			if (_onReadyToPreset)
			{
				_onReadyToPreset();
			}
		}
	}
}