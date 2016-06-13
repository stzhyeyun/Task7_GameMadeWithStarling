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
	
	import gamedata.DatabaseURL;

	internal class URLBitmapLoader
	{
		private var _type:String;
		private var _name:String;
		private var _onCompleteLoad:Function;
		
		public function URLBitmapLoader(onCompleteLoad:Function)
		{
			_name = null;
			_onCompleteLoad = onCompleteLoad;
		}
		
		public function dispose():void
		{
			_name = null;
			_onCompleteLoad = null;
		}
		
		public function load(type:String, name:String):void
		{
			_type = type;
			_name = name;
			
			var url:String;
			switch (_type)
			{
				case Resources.NOTICE_IMAGE:
				{
					url = DatabaseURL.RESOURCE + name;
				}
					break;
				
				case Resources.USER_PICTURE:
				{
					url = "https://graph.facebook.com/" + name + "/picture?type=large";
				}
					break;
				
				default:
					return;
			}
			
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
				_onCompleteLoad(_type, _name, bitmap, this);
			}
		}
	}
}