package gamedata
{
	import flash.filesystem.File;
	
	import media.SoundManager;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import user.LogInManager;
	import user.UserInfo;
	
	public class DataManager extends EventDispatcher
	{
		public static const UPDATE_CURRENT_SCORE:String = "updateCurrentScore";
		public static const UPDATE_BEST_SCORE:String = "updateBestScore";
		public static const UPDATE_RANK:String = "updateRank";
		
		private static var _current:DataManager;	
		private static var _path:File;
		private static var _playData:PlayData;
		private static var _settingData:SettingData;
		private static var _rank:Rank;

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
		
		public static function get rank():Rank
		{
			return _rank;
		}
		
		
		public function DataManager()
		{
			
		}
		
		public static function dispose():void
		{
			export();
			
			_playData = null;
			_settingData = null;
			_rank = null;
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
			
			_rank = new Rank("rank", _path);
			_rank.read();
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
			
			DataManager.current.dispatchEvent(new Event(DataManager.UPDATE_CURRENT_SCORE, false, _playData.currentScore));	
		}
		
		public static function updateBestScore():void
		{
			if (_playData.currentScore > _playData.bestScore)
			{
				_playData.bestScore = _playData.currentScore;
				
				DataManager.current.dispatchEvent(new Event(DataManager.UPDATE_BEST_SCORE, false, _playData.bestScore));
			}
		}
		
		public static function updateRank():void
		{
			var userInfo:UserInfo = LogInManager.userInfo;
			
			if (userInfo.id)
			{
				userInfo.score = _playData.currentScore;
				
				var userRank:int = _rank.addData(userInfo);
				if (userRank > 0)
				{
					DataManager.current.dispatchEvent(new Event(DataManager.UPDATE_RANK, false, userRank));
				}
			}
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
			
			if (_rank)
			{
				_rank.write();
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