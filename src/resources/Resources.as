package resources
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import user.UserManager;
	
	import media.Sound;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import user.UserInfo;
	
	public class Resources extends EventDispatcher
	{
		[Embed(
			source = "res/daumSemiBold.ttf",
			fontName = "daumSemiBold",			
			embedAsCFF="false",
			advancedAntiAliasing = "true")]
		public static const DaumSemiBold:Class;
		
		public static const COMPLETE_LOAD:String = "completeLoad";
		public static const NOTICE_IMAGE:String = "noticeImage";
		public static const USER_PICTURE:String = "userPicture";
		public static const NOTICE_IMAGE_READY:String = "noticeImageReady";
		public static const USER_PICTURE_READY:String = "userPictureReady";
		
		private static var _instance:Resources;
		
		private var _textureAtlasDic:Dictionary;
		private var _soundDic:Dictionary;
		private var _userPictureDic:Dictionary;
		private var _noticeImageDic:Dictionary;
		
		private var _path:File;
		private var _pngList:Array;
		private var _mp3List:Array;
		private var _totalResourcesCount:int;
		
		public static function get instance():Resources
		{
			if (!_instance)
			{
				_instance = new Resources();
			}
			return _instance;
		}

		
		public function Resources()
		{
			
		}
		
		public function dispose():void
		{
			if (_textureAtlasDic)
			{
				var textureAtlas:TextureAtlas;
				for (var key:Object in _textureAtlasDic)
				{
					textureAtlas = _textureAtlasDic[key];
					if (textureAtlas)
					{
						textureAtlas.dispose();
					}
					textureAtlas = null;
					delete _textureAtlasDic[key];
				}
			}
			_textureAtlasDic = null;
			
			if (_soundDic)
			{
				for (key in _soundDic)
				{
					_soundDic[key] = null;
					delete _soundDic[key];
				}
			}
			_soundDic = null;
			
			if (_userPictureDic)
			{
				var texture:Texture;
				for (key in _userPictureDic)
				{
					texture = _userPictureDic[key];
					if (texture)
					{
						texture.dispose();
					}
					texture = null;
					delete _userPictureDic[key];
				}
			}
			_userPictureDic = null;
			
			if (_noticeImageDic)
			{
				
				for (key in _noticeImageDic)
				{
					texture = _noticeImageDic[key];
					if (texture)
					{
						texture.dispose();
					}
					texture = null;
					delete _noticeImageDic[key];
				}
			}
			_noticeImageDic = null;
		}
		
		public function initialize():void
		{
			_instance = new Resources();
		}
		
		public function loadFromDisk(path:File):void
		{
			if (!path.exists)
			{
				trace("load : The path does not exist.");
				return;
			}
			
			_path = path;
			var resourcesList:Array = _path.getDirectoryListing();
			if (!resourcesList)
			{
				trace("load : No files.");
				return;
			}
			
			var url:String;
			for (var i:int = 0; i < resourcesList.length; i++)
			{
				url = resourcesList[i].url;
				
				if (url.match(/\.png$/i))
				{
					if (!_pngList)
					{
						_pngList = new Array();
					}
					_pngList.push(url);
					_totalResourcesCount++;
				}
				else if (url.match(/\.xml$/i))
				{
					_totalResourcesCount++;
				}
				else if (url.match(/\.mp3$/i))
				{
					if (!_mp3List)
					{
						_mp3List = new Array();
					}
					_mp3List.push(url);
					_totalResourcesCount++;
				}
			}

			if (_pngList)
			{
				var loader:TextureAtlasLoader;
				var fileName:String;
				for (i = 0; i < _pngList.length; i++)
				{
					url = _pngList[i];
					fileName = url.replace(_path.url + "/", "").replace(/\.png$/i, "");
					
					loader = new TextureAtlasLoader(onLoadedTextureAtlas);
					loader.load(url, fileName);
				}
				_pngList.splice(0, _pngList.length);
				_pngList = null;
				
				loader = null;
				fileName = null;
			}
			
			if (_mp3List)
			{
				var sound:Sound;
				for (i = 0; i < _mp3List.length; i++)
				{
					sound = new Sound();
					sound.addEventListener(flash.events.Event.COMPLETE, onLoadedSound);
					sound.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
					sound.load(new URLRequest(_mp3List[i]));
				}
				_mp3List.splice(0, _mp3List.length);
				_mp3List = null;
				
				sound = null;
			}
		}
		
		public function loadFromURL(type:String, key:String):void
		{
			if (!type || !key)
			{
				if (!type) trace("loadFromURL : No type.");
				if (!key) trace("loadFromURL : No key.");
				return;
			}
			
			if (type == USER_PICTURE && _userPictureDic && _userPictureDic[key])
			{
				this.dispatchEvent(
						new starling.events.Event(Resources.USER_PICTURE_READY, false, key));
				return;
			}
			
			var loader:URLBitmapLoader = new URLBitmapLoader(onLoadedFromURL);
			loader.load(type, key);
		}
		
		public function getTexture(textureAtlasName:String, textureName:String):Texture
		{
			if (!_textureAtlasDic || !_textureAtlasDic[textureAtlasName])
			{
				if (!_textureAtlasDic) trace("getTexture : No texture atlas.");
				if (!_textureAtlasDic[textureAtlasName]) trace("getTexture : Not registered texture atlas name.");
				return null;
			}
			
			var texture:Texture = _textureAtlasDic[textureAtlasName].getTexture(textureName);
			
			if (!texture)
			{
				trace("getTexture : Not registered texture name.");
			}
			return texture;
		}
		
		public function getSound(name:String):Sound
		{
			if (!_soundDic || !_soundDic[name])
			{
				if (!_soundDic) trace("getSound : No sounds.");
				if (!_soundDic[name]) trace("getSound : Not registered sound name.");
				return null;
			}
			
			return _soundDic[name];
		}
		
		public function getNoticeImage(name:String):Texture
		{
			if (name && _noticeImageDic[name])
			{
				return _noticeImageDic[name];
			}
			else
			{
				return null;
			}
		}
		
		public function getCurrentUserPicture():Texture
		{
			var userInfo:UserInfo = UserManager.instance.userInfo;
			var userId:String = null;
			if (userInfo)
			{
				userId = UserManager.instance.userInfo.userId;
			}
			
			if (userId && _userPictureDic && _userPictureDic[userId])
			{
				return _userPictureDic[userId];
			}
			else
			{
				return null;
			}
		}
		
		public function getUserPicture(userId:String):Texture
		{
			if (userId && _userPictureDic[userId])
			{
				return _userPictureDic[userId];
			}
			else
			{
				return null;
			}
		}
		
		public function removeNoticeImage():void
		{
			if (_noticeImageDic)
			{
				var texture:Texture;
				for (var key:Object in _noticeImageDic)
				{
					texture = _noticeImageDic[key];
					if (texture)
					{
						texture.dispose();
					}
					texture = null;
					delete _noticeImageDic[key];
				}
			}
			_noticeImageDic = null;
		}
		
		private function checkLoadingProgress():void
		{
			if (_totalResourcesCount == 0)
			{
				_path = null;
				
				this.dispatchEvent(new starling.events.Event(Resources.COMPLETE_LOAD));
			}
		}
		
		private function onLoadedTextureAtlas(name:String, bitmap:Bitmap, xml:XML, loader:TextureAtlasLoader):void
		{
			if (!_textureAtlasDic)
			{
				_textureAtlasDic = new Dictionary();
			}
			_textureAtlasDic[name] = new TextureAtlas(Texture.fromBitmap(bitmap), xml);
			
			loader.dispose();
			
			_totalResourcesCount -= 2;
			checkLoadingProgress();
		}
		
		private function onLoadedSound(event:flash.events.Event):void
		{
			var sound:Sound = event.currentTarget as Sound;
			if (!sound)
			{
				trace("onLoadedSound : No sound.");
				return;
			}
			
			sound.removeEventListener(flash.events.Event.COMPLETE, onLoadedSound);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			var fileName:String = sound.url.replace(_path.url + "/", "").replace(/\.mp3$/i, "");			
			
			if (!_soundDic)
			{
				_soundDic = new Dictionary();
			}
			_soundDic[fileName] = sound;
			
			_totalResourcesCount--;
			checkLoadingProgress();
		}
				
		private function onFailedLoadingSound(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(flash.events.Event.COMPLETE, onLoadedSound);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			trace("Failed to load sound.");
			
			_totalResourcesCount--;
			checkLoadingProgress();
		}

		private function onLoadedFromURL(type:String, key:String, bitmap:Bitmap, loader:URLBitmapLoader):void
		{
			switch (type)
			{
				case NOTICE_IMAGE:
				{
					if (!_noticeImageDic)
					{
						_noticeImageDic = new Dictionary();
					}
					_noticeImageDic[key] = Texture.fromBitmap(bitmap);
					
					this.dispatchEvent(
						new starling.events.Event(Resources.NOTICE_IMAGE_READY, false, key));
				}
					break;
				
				case USER_PICTURE:
				{
					if (!_userPictureDic)
					{
						_userPictureDic = new Dictionary();
					}
					_userPictureDic[key] = Texture.fromBitmap(bitmap);
					
					this.dispatchEvent(
						new starling.events.Event(Resources.USER_PICTURE_READY, false, key));
				}
					break;
				
				default:
					return;
			}
			
			loader.dispose();
		}
	}
}