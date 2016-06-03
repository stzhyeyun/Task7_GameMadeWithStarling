package resources
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import media.Sound;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Resources extends EventDispatcher
	{
		public static const USER_PICTURE_READY:String = "userPictureReady";
		
		private static var _current:Resources;
		
		private static var _textureAtlas:TextureAtlas;
		private static var _soundDic:Dictionary;
		private static var _userPicture:Texture;
		
		private static var _path:File;
		private static var _pngList:Array;
		private static var _mp3List:Array;
		private static var _totalResourcesCount:int;
		private static var _loadedResourcesCount:int;
		
		private static var _onReadyToUseResources:Function;
		
		public static function get current():Resources
		{
			return _current;
		}
		
		public static function set onReadyToUseResources(value:Function):void
		{
			_onReadyToUseResources = value;
		}

		
		public function Resources()
		{
			
		}
		
		public static function dispose():void
		{
			if (_textureAtlas)
			{
				_textureAtlas.dispose();
			}
			_textureAtlas = null;
			
			if (_soundDic)
			{
				for (var key:Object in _soundDic)
				{
					_soundDic[key] = null;
					delete _soundDic[key];
				}
			}
			_soundDic = null;
			
			_onReadyToUseResources = null;
		}
		
		public static function initialize():void
		{
			_current = new Resources();
		}
		
		public static function loadFromDisk(path:File):void
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
					sound.addEventListener(Event.COMPLETE, onLoadedSound);
					sound.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
					sound.load(new URLRequest(_mp3List[i]));
				}
				_mp3List.splice(0, _mp3List.length);
				_mp3List = null;
				
				sound = null;
			}
		}
		
		public static function loadImageFromURL(url:String):void
		{
			if (!url)
			{
				if (!url) trace("loadImageFromURL : No URL.");
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(flash.events.Event.COMPLETE, onLoadedFromURL);
			loader.load(new URLRequest(url));
		}
		
		public static function getTexture(textureName:String):Texture
		{
			if (!_textureAtlas)
			{
				if (!_textureAtlas) trace("getTexture : No texture atlas.");
				return null;
			}
			
			var texture:Texture = _textureAtlas.getTexture(textureName);
			
			if (!texture)
			{
				trace("getTexture : Not registered texture name.");
			}
			return texture;
		}
		
		public static function getUserPicture():Texture
		{
			return _userPicture;
		}
		
		public static function removeUserPicture():void
		{
			if (_userPicture)
			{
				_userPicture.dispose();
				_userPicture = null;
			}
		}
		
		public static function getSound(name:String):Sound
		{
			if (!_soundDic || !_soundDic[name])
			{
				if (!_soundDic) trace("getSound : No sounds.");
				if (!_soundDic[name]) trace("getSound : Not registered sound name.");
				return null;
			}
			
			return _soundDic[name];
		}
		
		private static function checkLoadingProgress():void
		{
			if (_loadedResourcesCount == _totalResourcesCount)
			{
				_path = null;
				
				if (_onReadyToUseResources)
				{
					_onReadyToUseResources();
				}
			}
		}
		
		private static function onLoadedTextureAtlas(name:String, bitmap:Bitmap, xml:XML, loader:TextureAtlasLoader):void
		{
			_textureAtlas = new TextureAtlas(Texture.fromBitmap(bitmap), xml);
			
			loader.dispose();
			
			_loadedResourcesCount += 2;
			checkLoadingProgress();
		}
		
		private static function onLoadedSound(event:Event):void
		{
			var sound:Sound = event.currentTarget as Sound;
			if (!sound)
			{
				trace("onLoadedSound : No sound.");
				return;
			}
			
			sound.removeEventListener(Event.COMPLETE, onLoadedSound);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			var fileName:String = sound.url.replace(_path.url + "/", "").replace(/\.mp3$/i, "");			
			
			if (!_soundDic)
			{
				_soundDic = new Dictionary();
			}
			_soundDic[fileName] = sound;
			
			_loadedResourcesCount++;
			checkLoadingProgress();
		}
				
		private static function onFailedLoadingSound(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onLoadedSound);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			trace("failed to load sound.");
		}

		private static function onLoadedFromURL(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, onLoadedFromURL);
			
			var byteArray:ByteArray = urlLoader.data;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadedByteArray);
			loader.loadBytes(byteArray);
		}
		
		private static function onLoadedByteArray(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadedByteArray);
						
			var bitmap:Bitmap = loaderInfo.loader.content as Bitmap;
			_userPicture = Texture.fromBitmap(bitmap);
			
			Resources.current.dispatchEvent(new starling.events.Event(Resources.USER_PICTURE_READY));
		}
	}
}