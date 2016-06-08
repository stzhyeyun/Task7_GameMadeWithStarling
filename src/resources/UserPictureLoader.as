package resources
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	internal class UserPictureLoader
	{
		private var _userId:String;
		private var _onCompleteLoad:Function;
		private var _isCurrentUser:Boolean;
		
		public function UserPictureLoader(onCompleteLoad:Function)
		{
			_userId = null;
			_onCompleteLoad = onCompleteLoad;
			_isCurrentUser = false;
		}
		
		public function dispose():void
		{
			_userId = null;
			_onCompleteLoad = null;
		}
		
		public function load(userId:String, isCurrentUser:Boolean = false):void
		{
			_userId = userId;
			_isCurrentUser = isCurrentUser;
			
			var url:String = "https://graph.facebook.com/" + userId + "/picture?type=large";
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(flash.events.Event.COMPLETE, onLoadedFromURL);
			loader.load(new URLRequest(url));
		}
		
		private function onLoadedFromURL(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, onLoadedFromURL);
			
			var byteArray:ByteArray = urlLoader.data;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadedByteArray);
			loader.loadBytes(byteArray);
		}
		
		private function onLoadedByteArray(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadedByteArray);
			
			var bitmap:Bitmap = loaderInfo.loader.content as Bitmap;

			if (_onCompleteLoad)
			{
				_onCompleteLoad(_userId, bitmap, _isCurrentUser, this);
			}
		}
	}
}