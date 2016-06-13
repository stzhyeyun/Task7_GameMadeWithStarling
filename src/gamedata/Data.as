package gamedata
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Data extends EventDispatcher
	{
		public static const SUCCEEDED_READING:String = "loadSucceeded";
		public static const FAILED_READING:String = "loadFailed";
		
		private const TAG:String = "[Data]";
		
		protected var _name:String;
		protected var _path:File;
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get path():File
		{
			return _path;
		}
		
		public function set path(value:File):void
		{
			_path = value;
		}
		
		
		public function Data(name:String, path:File)
		{
			_name = name;
			_path = path;
		}

		public function dispose():void
		{
			_name = null;
			_path = null;
		}
			
		public function read():void
		{
			if (!_name || !_path)
			{
				if (!_name) trace(TAG + " read : No name.");
				if (!_path) trace(TAG + " read : No path.");
				
				this.dispatchEvent(new starling.events.Event(FAILED_READING));
				return;
			}
			
			var file:File = _path.resolvePath(_name + ".json");
			if (file.exists)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(flash.events.Event.COMPLETE, onCompleteLoad);
				urlLoader.load(new URLRequest(file.url));
			}
			else
			{
				this.dispatchEvent(new starling.events.Event(FAILED_READING));	
			}
		}
		
		public virtual function write():void
		{
			// empty
		}

		
		protected function onCompleteLoad(event:flash.events.Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (loader)
			{
				loader.removeEventListener(flash.events.Event.COMPLETE, onCompleteLoad);
			}
			
			this.dispatchEvent(new starling.events.Event(SUCCEEDED_READING));
		}
	}
}