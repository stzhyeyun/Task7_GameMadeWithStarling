package gamedata
{
	import flash.filesystem.File;
	
	import media.SoundManager;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class DataManager extends EventDispatcher
	{
		public static const UPDATE:String = "update";
		
		private static var _current:DataManager;	
		private static var _path:File;
		private static var _playData:PlayData;
		private static var _settingData:SettingData;
		
		public static function get current():DataManager
		{
			return _current;
		}

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
		
		public static function dispose():void
		{
			export();
			
//			_playData = null;
//			_settingData = null;
		}

		public static function initialize():void
		{
			_current = new DataManager();
			_path = File.applicationStorageDirectory.resolvePath("data");
			
			_playData = new PlayData("playData", _path);
			_playData.read();
			
			_settingData = new SettingData("settingData", _path);
			_settingData.onReadyToPreset = preset;
			_settingData.read();
		}
		
		public static function updateCurrentScore(numBlockTiles:int, numClearTiles:int = 0):void
		{
			// 맞춘 블럭 타일당 1점
			var obtainedScore:int = numBlockTiles; 
			
			if (numClearTiles > 0)
			{
				obtainedScore += 
					// 클리어한 타일당 1점
					numClearTiles + 
					// 클리어한 라인 1개 초과 시마다 10점
					((numClearTiles / _playData.tableData.size - 1) * 10);
			}
			
			_playData.currentScore += obtainedScore;
			
			DataManager.current.dispatchEvent(new Event(DataManager.UPDATE, false, _playData.currentScore));	
		}
		
		public static function updateBestScore():void
		{
			if (_playData.currentScore > _playData.bestScore)
			{
				_playData.bestScore = _playData.currentScore;
			}
			
			DataManager.current.dispatchEvent(new Event(DataManager.UPDATE, false, _playData.bestScore));	
		}
		
		public static function export():void
		{
			if (_playData)
			{
				_playData.write();
			}
			
			if (_settingData)
			{
				_settingData.write();
			}
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