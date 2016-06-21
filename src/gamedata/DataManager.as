package gamedata
{
	import flash.filesystem.File;
	
	import media.SoundManager;
	
	import starling.events.Event;
	
	import system.Manager;
	
	import user.UserInfo;
	import user.UserManager;
	
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
			
			_instance = null;
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
		
		/**
		 * 현재 점수를 업데이트합니다. 
		 * @param numBlockTiles 세팅된 Block의 Tile 개수입니다.
		 * @param numClearTiles 클리어된 라인의 수입니다.
		 * 
		 */
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
			
			// 점수 업데이트 이벤트 dispatch
			this.dispatchEvent(new Event(UPDATE_CURRENT_SCORE, false, _playData.currentScore));	
		}
		
		/**
		 * 최고 점수를 업데이트합니다. 
		 * 
		 */
		public function updateBestScore():void
		{
			if (_playData.currentScore > _playData.bestScore)
			{
				_playData.bestScore = _playData.currentScore;
				
				// 점수 업데이트 이벤트 dispatch
				this.dispatchEvent(new Event(UPDATE_BEST_SCORE, false, _playData.bestScore));
			}
		}
		
		/**
		 * 랭크를 업데이트합니다. 
		 * 
		 */
		public function updateRank():void
		{
			var userInfo:UserInfo = UserManager.instance.userInfo;
			
			// 로그인한 유저가 있으면 랭크 업데이트
			if (userInfo.userId)
			{
				userInfo.score = _playData.currentScore;
				
				_rank.addEventListener(Rank.ADD, onUpdateRank);
				_rank.addData(userInfo);
			}
		}
		
		/**
		 * 정해진 Block(Tile 수)만큼 점수를 되돌립니다.  
		 * @param numTile 되돌리고자 하는 Block의 Tile 수입니다.
		 * 
		 */
		public function revertScore(numTile:int):void
		{
			_playData.currentScore -= numTile;
			
			// 점수 업데이트 이벤트 dispatch
			this.dispatchEvent(new Event(UPDATE_CURRENT_SCORE, false, _playData.currentScore));	
		}
		
		/**
		 * 데이터를 로컬로 출력합니다. 
		 * 
		 */
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
		
		/**
		 * 로딩 진행 정도를 체크하여 완료된 경우 이벤트를 dispatch합니다. 
		 * 
		 */
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
		
		/**
		 * SettingData에 따라 BGM과 사운드 이펙트를 제어합니다. 
		 * 
		 */
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
		
		/**
		 * 랭크 업데이트 완료 시 호출되는 함수입니다.
		 * @param event Rank.ADD
		 * 
		 */
		private function onUpdateRank(event:Event):void
		{
			_rank.removeEventListener(Rank.ADD, onUpdateRank);
			
			// 랭크가 정상적으로 업데이트 되었을 경우
			var userRank:int = int(event.data);
			if (userRank > 0)
			{
				// 랭크 업데이트 이벤트 dispatch 
				this.dispatchEvent(new Event(UPDATE_RANK, false, userRank));
			}
		}
	}
}