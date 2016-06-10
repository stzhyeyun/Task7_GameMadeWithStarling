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
		
		public function addData(userInfo:UserInfo):void
		{
			var url:String =
				DatabaseURL.RANK +
				"addRankData.php" +
				"?id=" + userInfo.id +
				"&name=" + userInfo.name +
				"&score=" + userInfo.score;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onAddedData);
		}
		
		public function getRank(userInfo:UserInfo):void
		{
			var url:String =
				DatabaseURL.RANK +
				"getRank.php" +
				"?id=" + userInfo.id;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotRank);
		}
		
		public function getUser(rank:int, numResult:int = 1):void
		{
			var url:String =
				DatabaseURL.RANK +
				"getRankedUser.php" +
				"?rank=" + rank +
				"&numResult=" + numResult;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onGotUser);
		}

		public function count():void
		{
			var url:String =
				DatabaseURL.RANK +
				"getNumRank.php?";
			
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
				for (var i:int = 0; i < data.length; i++)
				{
					userInfoVec.push(new UserInfo(data[i].id, data[i].name, data[i].score));
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