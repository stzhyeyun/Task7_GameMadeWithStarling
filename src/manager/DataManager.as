package manager
{
	import flash.filesystem.File;
	
	import gamedata.Data;
	import gamedata.PlayData;
	import gamedata.Rank;
	import gamedata.SettingData;
	
	import manager.LogInManager;
	import manager.SoundManager;
	
	import starling.events.Event;
	
	import user.UserInfo;
	
	public class DataManager extends Manager
	{
		public static const UPDATE_CURRENT_SCORE:String = "updateCurrentScore";
		public static const UPDATE_BEST_SCORE:String = "updateBestScore";
		public static const UPDATE_RANK:String = "updateRank";
		
		private static var _instance:DataManager;	
		
		private var _numLoad:int;
		private var _path:File;
		
		private var _playData:PlayData;
		private var _settingData:SettingData;
		private var _rank:Rank;

		public static function get instance():DataManager
		{
			if (!_instance)
			{
				_instance = new DataManager();
			}
			return _instance;
		}

		public function get playData():PlayData
		{
			return _playData;
		}
		
		public function get settingData():SettingData
		{
			return _settingData;
		}
		
		public function get rank():Rank
		{
			return _rank;
		}
		
		
		public function DataManager()
		{
			
		}
		
		public override function dispose():void
		{
			export();
			
			_playData = null;
			_settingData = null;
			_rank = null;
		}

		public override function initialize():void
		{
			_numLoad = 2;
			_path = File.applicationStorageDirectory.resolvePath("data");
			
			_playData = new PlayData("playData", _path);
			_playData.addEventListener(Data.SUCCEEDED_READING, onReadPlayData);
			_playData.addEventListener(Data.FAILED_READING, onFailedReadingPlayData);
			_playData.read();
			
			_settingData = new SettingData("settingData", _path);
			_settingData.addEventListener(Data.SUCCEEDED_READING, onReadSettingData);
			_settingData.addEventListener(Data.FAILED_READING, onFailedReadingSettingData);
			_settingData.read();
			
			_rank = new Rank();
		}
		
		public function updateCurrentScore(numBlockTiles:int, numClearTiles:int = 0):void
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
			
			this.dispatchEvent(new Event(UPDATE_CURRENT_SCORE, false, _playData.currentScore));	
		}
		
		public function updateBestScore():void
		{
			if (_playData.currentScore > _playData.bestScore)
			{
				_playData.bestScore = _playData.currentScore;
				
				this.dispatchEvent(new Event(UPDATE_BEST_SCORE, false, _playData.bestScore));
			}
		}
		
		public function updateRank():void
		{
			var userInfo:UserInfo = LogInManager.instance.userInfo;
			
			if (userInfo.userId)
			{
				userInfo.score = _playData.currentScore;
				
				_rank.addEventListener(Rank.ADD, onUpdateRank);
				_rank.addData(userInfo);
			}
		}
		
		public function export():void
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
		
		private function onReadPlayData(event:Event):void
		{
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onFailedReadingPlayData(event:Event):void
		{
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onReadSettingData(event:Event):void
		{
			preset();
			
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function onFailedReadingSettingData(event:Event):void
		{
			_numLoad--;
			checkLoadingProgress();
		}
		
		private function checkLoadingProgress():void
		{
			if (_numLoad == 0)
			{
				_playData.removeEventListener(Data.SUCCEEDED_READING, onReadPlayData);
				_playData.removeEventListener(Data.FAILED_READING, onFailedReadingPlayData);
				
				_settingData.removeEventListener(Data.SUCCEEDED_READING, onReadSettingData);
				_settingData.removeEventListener(Data.FAILED_READING, onFailedReadingSettingData);
				
				this.dispatchEvent(new Event(Manager.INITIALIZED));
			}
		}
		
		private function preset():void
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
		
		private function onUpdateRank(event:Event):void
		{
			_rank.removeEventListener(Rank.ADD, onUpdateRank);
			
			var userRank:int = int(event.data);
			if (userRank > 0)
			{
				this.dispatchEvent(new Event(UPDATE_RANK, false, userRank));
			}
		}
	}
}