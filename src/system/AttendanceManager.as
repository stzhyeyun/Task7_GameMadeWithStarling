package system
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gamedata.DatabaseURL;
	
	import item.ItemData;
	import item.ItemID;
	
	import starling.events.Event;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;
	import ui.popup.RewardPopup;
	
	import user.UserInfo;
	import user.UserManager;

	public class AttendanceManager extends Manager
	{
		public static const READY_TO_REWARD:String = "readyReward";
		
		private static var _instance:AttendanceManager;
		
		private const TAG:String = "[AttendanceManager]";
		
		private var _rewarded:Boolean;
		private var _attendance:int;
		private var _rewardData:Vector.<Vector.<ItemData>>;

		public static function get instance():AttendanceManager
		{
			if (!_instance)
			{
				_instance = new AttendanceManager();
			}
			return _instance;
		}
		
		public function get rewarded():Boolean
		{
			return _rewarded;
		}
		
		public function set rewarded(value:Boolean):void
		{
			_rewarded = value;
		}

		
		public function AttendanceManager()
		{
			
		}
		
		public override function initialize():void
		{
			var userInfo:UserInfo = UserManager.instance.userInfo;
			if (userInfo && userInfo.userId)
			{
				_rewarded = userInfo.rewarded;
				_attendance = userInfo.attendance;
				setRewardPopup();
			}
			else
			{
				_rewarded = true;
				_attendance = 0;	
			}
			
			// Reward data
			_rewardData = new Vector.<Vector.<ItemData>>();
			
			var day1:Vector.<ItemData> = new Vector.<ItemData>();
			day1.push(new ItemData(ItemID.REFRESH_BLOCKS, 1));
			day1.push(new ItemData(ItemID.UNDO, 1));
			
			var day2:Vector.<ItemData> = new Vector.<ItemData>();
			day2.push(new ItemData(ItemID.REFRESH_BLOCKS, 3));
			
			var day3:Vector.<ItemData> = new Vector.<ItemData>();
			day3.push(new ItemData(ItemID.UNDO, 3));
			
			var day4:Vector.<ItemData> = new Vector.<ItemData>();
			day4.push(new ItemData(ItemID.REFRESH_BLOCKS, 3));
			day4.push(new ItemData(ItemID.UNDO, 3));
			
			var day5:Vector.<ItemData> = new Vector.<ItemData>();
			day5.push(new ItemData(ItemID.REFRESH_BLOCKS, 5));
			day5.push(new ItemData(ItemID.UNDO, 5));
			
			_rewardData.push(day1);
			_rewardData.push(day2);
			_rewardData.push(day3);
			_rewardData.push(day4);
			_rewardData.push(day5);
			//
			
			UserManager.instance.addEventListener(UserManager.LOG_OUT, onLogOut);
			UserManager.instance.addEventListener(UserManager.GET_USER_DB, onGotAttendanceData);
		}
		
		public override function dispose():void
		{
			UserManager.instance.removeEventListener(UserManager.LOG_OUT, onLogOut);
			UserManager.instance.removeEventListener(UserManager.GET_USER_DB, onGotAttendanceData);
			
			_instance = null;
		}
		
		public function reward():void
		{
			var index:int = _attendance - 1;
			if (index < 0 || index >= _rewardData.length)
			{
				trace(TAG + " reward : Invalid attendance.");
				return;
			}
			
			var url:String =
				DatabaseURL.USER +
				"reward.php" +
				"?id=" + UserManager.instance.userInfo.userId;
						
			if (_rewardData[index][0].id == ItemID.REFRESH_BLOCKS)
			{
				url += "&numItem0=" + _rewardData[index][0].num;
				
				if (_rewardData[index].length > 1)
				{
					url += "&numItem1=" + _rewardData[index][1].num;
				}
				else
				{
					url += "&numItem1=0";
				}
			}
			else if (_rewardData[index][0].id == ItemID.UNDO)
			{
				url +=
					"&numItem0=0" +
					"&numItem0=" + _rewardData[index][0].num;
			}
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(flash.events.Event.COMPLETE, onRewarded);
			
			_rewarded = true;
		}
		
		private function setRewardPopup():void
		{
			if (_rewarded || _attendance <= 0)
			{
				return;
			}
			
			var popup:RewardPopup = PopupManager.instance.getPopup(PopupName.REWARD) as RewardPopup;
			if (!popup)
			{
				trace(TAG + " onGotAttendance : Failed to get Reward pop-up.");	
				return;
			}
			
			popup.setDay(_attendance);
			this.dispatchEvent(new starling.events.Event(READY_TO_REWARD));
		}

		private function onLogOut(event:starling.events.Event):void
		{
			_attendance = 0;
			_rewarded = true;
		}
		
		private function onGotAttendanceData(event:starling.events.Event):void
		{
			var userInfo:UserInfo = UserManager.instance.userInfo;

			_rewarded = userInfo.rewarded;
			_attendance = userInfo.attendance;
			
			if (!_rewarded)
			{
				setRewardPopup();
			}
		}
		
		private function onRewarded(event:flash.events.Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, onRewarded);
			
			if (urlLoader.data == 1)
			{
				var index:int = _attendance - 1;
				if (index < 0 || index >= _rewardData.length)
				{
					trace(TAG + " reward : Invalid attendance.");
					return;
				}
				
				for (var i:int = 0; i < _rewardData[index].length; i++)
				{
					UserManager.instance.updateItemData(
						UserManager.ADD_ITEM, _rewardData[index][i].id, _rewardData[index][i].num); 	
				}
			}
		}
	}
}