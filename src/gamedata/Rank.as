package gamedata
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.events.EventDispatcher;
	
	import user.UserInfo;
	
	public class Rank extends EventDispatcher
	{
		public static const ADD:String = "added";  
		public static const GET_RANK:String = "getRank";
		public static const GET_USER:String = "getUser";
		public static const COUNT:String = "count";
		
		private const TAG:String = "[Rank]";
		
		
		public function Rank()
		{
			
		}
		
		/**
		 * 해당 유저를 랭킹에 등록하고 랭크를 확인합니다.
		 * @param userInfo 등록한 유저입니다.
		 * Rank.ADD 이벤트를 수신하여 결과(int)를 받습니다.
		 */
		public function addData(userInfo:UserInfo):void
		{
			var url:String =
				DatabaseURL.USER +
				"updateScore.php" +
				"?id=" + userInfo.userId +
				"&name=" + userInfo.userName +
				"&score=" + userInfo.score;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onAddedData);
		}
		
		/**
		 * 해당 유저의 랭크를 확인합니다. 
		 * @param userInfo 랭크를 확인하고자 하는 유저입니다.
		 * Rank.GET_RANK 이벤트를 수신하여 결과(int)를 받습니다. 랭크에 등록된 유저가 아니거나 랭크 확인에 실패할 경우 0을 반환합니다.
		 */
		public function getRank(userInfo:UserInfo):void
		{
			var url:String =
				DatabaseURL.USER +
				"getRank.php" +
				"?id=" + userInfo.userId;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotRank);
		}
		
		/**
		 * 랭킹에 등록된  유저 정보를 가져옵니다.
		 * @param rank 기준 랭크입니다.
		 * @param numResult 원하는 결과값의 수입니다.
		 * @param currUserId 특정 유저를 중심으로 한 결과를 얻고 싶을 경우 해당 유저의 유저 ID를 입력합니다. 이때, 결과값의 수는 홀수여야 합니다.
		 * Rank.GET_USER 이벤트를 수신하여 결과(Vector.<UserInfo>)를 받습니다.
		 */
		public function getUser(rank:int, numResult:int = 1, currUserId:String = null):void
		{
			var url:String =
				DatabaseURL.USER +
				"getRankedUser.php" +
				"?rank=" + rank +
				"&numResult=" + numResult +
				"&currUserId=" + currUserId;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotUser);
		}

		/**
		 * 랭킹에 등록된 유저의 수를 가져옵니다.
		 * Rank.COUNT 이벤트를 수신하여 결과(int)를 받습니다.
		 */
		public function count():void
		{
			var url:String =
				DatabaseURL.USER +
				"getNumRanker.php?";
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotNumRank);
		}
		
		private function onAddedData(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onAddedData);
			
			this.dispatchEvent(new starling.events.Event(ADD, false, urlLoader.data)); 
		}
		
		private function onGotRank(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotRank);
			
			this.dispatchEvent(new starling.events.Event(GET_RANK, false, urlLoader.data)); 
		}
		
		private function onGotUser(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotUser);
			
			var userInfoVec:Vector.<UserInfo> = null;
			if (urlLoader.data != 0)
			{
				var data:Object = JSON.parse(urlLoader.data);
				
				userInfoVec = new Vector.<UserInfo>();
				var userInfo:UserInfo;
				for (var i:int = 0; i < data.length; i++)
				{
					userInfo = new UserInfo();
					userInfo.setInfo(data[i].id, data[i].name, data[i].score);
					userInfoVec.push(userInfo);
				}
			}
			
			this.dispatchEvent(new starling.events.Event(GET_USER, false, userInfoVec)); 
		}
		
		private function onGotNumRank(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onGotNumRank);
			
			this.dispatchEvent(new starling.events.Event(COUNT, false, urlLoader.data)); 
		}
	}
}