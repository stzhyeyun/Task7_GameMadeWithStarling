package data
{
	import flash.filesystem.File;
	
	import media.SoundManager;

	public class DataManager
	{
		private static var _path:File;
		private static var _playData:PlayData;
		private static var _settingData:SettingData;
		
		public static function get playData():PlayData
		{
			return _playData;
		}
		
		public static function get settingData():SettingData
		{
			return _settingData;
		}

		
		public function DataManager()
		{
			
		}

		public static function initialize():void
		{
			_path = File.applicationStorageDirectory.resolvePath("data");
			
			_playData = new PlayData("playData", _path);
			_playData.read();
			
			_settingData = new SettingData("settingData", _path);
			_settingData.onReadyToPreset = preset;
			_settingData.read();
		}
		
		public static function dispose():void
		{
			if (_playData)
			{
				_playData.write();
				_playData.dispose();
			}
			_playData = null;
			
			if (_settingData)
			{
				_settingData.write();
				_settingData.dispose();
			}
			_settingData = null;
		}
		
		private static function preset():void
		{
			if (!_settingData.bgm)
			{
				SoundManager.isBgmActive = false;
				SoundManager.stopBgm();
			}
			
			if (!_settingData.sound)
			{
				SoundManager.isSoundEffectActive = false;	
				SoundManager.stopSoundEffect();
			}
		}
	}
}