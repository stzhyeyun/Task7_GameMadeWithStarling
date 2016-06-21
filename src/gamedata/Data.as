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
		
		protected var _fileName:String;
		protected var _path:File;
		
		public function get fileName():String
		{
			return _fileName;
		}
		
		public function set fileName(value:String):void
		{
			_fileName = value;
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
			_fileName = name;
			_path = path;
		}

		public function dispose():void
		{
			_fileName = null;
			_path = null;
		}
			
		/**
		 * 해당 경로의 파일을 읽습니다. 
		 * 
		 */
		public function read():void
		{
			if (!_fileName || !_path)
			{
				if (!_fileName) trace(TAG + " read : No name.");
				if (!_path) trace(TAG + " read : No path.");
				
				// 읽기 실패 이벤트 dispatch
				this.dispatchEvent(new starling.events.Event(FAILED_READING));
				return;
			}
			
			// 파일이 존재하면 읽음
			var file:File = _path.resolvePath(_fileName + ".json");
			if (file.exists)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(flash.events.Event.COMPLETE, onCompleteLoad);
				urlLoader.load(new URLRequest(file.url));
			}
			else
			{
				// 읽기 실패 이벤트 dispatch
				this.dispatchEvent(new starling.events.Event(FAILED_READING));	
			}
		}
		
		public virtual function write():void
		{
			// empty
		}
		
		/**
		 * 파일 로드 완료 시 호출되는 함수입니다.
		 * @param event Event.COMPLETE
		 * 
		 */
		protected function onCompleteLoad(event:flash.events.Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (loader)
			{
				loader.removeEventListener(flash.events.Event.COMPLETE, onCompleteLoad);
			}
			
			// 읽기 성공 이벤트 dispatch
			this.dispatchEvent(new starling.events.Event(SUCCEEDED_READING));
		}
	}
}