package system
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gamedata.DatabaseURL;
	
	import resources.Resources;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import ui.popup.NoticePopup;
	import gamedata.DataManager;
	import ui.popup.PopupManager;
	
	public class NoticeManager extends Manager
	{
		private static var _instance:NoticeManager;
		
		private var _numLoad:int;
		private var _isNotice:Boolean;
		private var _noticeList:Vector.<String>;
	
		public static function get instance():NoticeManager
		{
			if (!_instance)
			{
				_instance = new NoticeManager();
			}
			return _instance;
		}
		
		public function get isNotice():Boolean
		{
			return _isNotice;
		}

		public function get noticeList():Vector.<String>
		{
			return _noticeList;
		}
	
		
		public function NoticeManager()
		{
			
		}

		public override function initialize():void
		{
			var url:String = DatabaseURL.NOTICE + "getNoticeToShow.php";

			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(flash.events.Event.COMPLETE, onGotNoticeData);
		}
		
		public override function dispose():void
		{
			// Popup 제거
			for (var i:int = 0; i < _noticeList.length; i++)
			{
				PopupManager.instance.removePopup(_noticeList[i]);
				_noticeList[i] = null;
			}
			_noticeList = null;
				
			// Resource 제거
			Resources.instance.removeNoticeImage();
		}
		
		private function onGotNoticeData(event:flash.events.Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, onGotNoticeData);
			
			var needToShow:Boolean = false;
			
			if (urlLoader.data != "[]")
			{
				_numLoad = 0;
				_isNotice = true;
				_noticeList = new Vector.<String>();
				
				var data:Object = JSON.parse(urlLoader.data);
				var imageName:String;
				for (var i:int = 0; i < data.length; i++)
				{
					imageName = data[i].image;
					
					if (!DataManager.instance.settingData.isBannedPopup(imageName))
					{
						_noticeList.push(imageName);
						Resources.instance.addEventListener(Resources.NOTICE_IMAGE_READY, onLoadedNoticeImage);
						Resources.instance.loadFromURL(Resources.NOTICE_IMAGE, imageName);
						
						needToShow = true;
					}
				}
			}

			if (!needToShow)
			{
				this.dispatchEvent(new starling.events.Event(Manager.INITIALIZED));	
			}
		}
		
		private function onLoadedNoticeImage(event:starling.events.Event):void
		{
			var imageName:String = event.data as String;
			var image:Texture = Resources.instance.getNoticeImage(imageName);
			
			if (image)
			{
				var stageWidth:Number = Starling.current.nativeStage.stageWidth;
				var stageHeight:Number = Starling.current.nativeStage.stageHeight;
				
				var popup:NoticePopup = new NoticePopup();
				popup.name = imageName;
				popup.initialize();
				var scale:Number =  stageWidth * 0.8 / popup.width;
				popup.width *= scale;
				popup.height *= scale;
				popup.setContent(image);
				
				PopupManager.instance.addPopup(imageName, popup);
			}
			
			_numLoad++;
			if (_numLoad == _noticeList.length)
			{
				Resources.instance.removeEventListener(Resources.NOTICE_IMAGE_READY, onLoadedNoticeImage);
				this.dispatchEvent(new starling.events.Event(Manager.INITIALIZED));
			}
		}
	}
}