package resources
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class TextureAtlasLoader
	{
		private const TAG:String = "[TextureAtlasLoader]";
		
		private var _path:String;
		private var _name:String;
		private var _bitmap:Bitmap;
		private var _xml:XML;
		private var _onCompleteLoad:Function;
		
		public function TextureAtlasLoader(onCompleteLoad:Function)
		{
			_path = null;
			_name = null;
			_bitmap = null;
			_xml = null;
			_onCompleteLoad = onCompleteLoad;
		}
		
		public function dispose():void // need test
		{
			_path = null;
			_name = null;
			_bitmap = null; 
			_xml = null;
			_onCompleteLoad = null;
		}
		
		public function load(pngPath:String, name:String):void
		{
			_path = pngPath;
			_name = name;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedPNG);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingPNG);
			loader.load(new URLRequest(_path));
		}
		
		private function onLoadedPNG(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			if (!loaderInfo)
			{
				trace(TAG + "onLoadedPNG : No loaderInfo.");
				return;
			}
			
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadedPNG);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingPNG);
		
			_bitmap = loaderInfo.loader.content as Bitmap;
			
			// Load XMl
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingXML);
			loader.load(new URLRequest(_path.replace(/\.png$/i, ".xml")));
		}
		
		private function onLoadedXML(event:Event):void
		{
			var loader:URLLoader = event.currentTarget as URLLoader;
			if (!loader)
			{
				trace(TAG + "onLoadedXML : No loader.");
				return;
			}
			
			loader.removeEventListener(Event.COMPLETE, onLoadedXML);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingXML);
			
			_xml = new XML(loader.data);
			
			if (_onCompleteLoad)
			{
				_onCompleteLoad(_name, _bitmap, _xml, this);
			}
		}
		
		private function onFailedLoadingPNG(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onLoadedPNG);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingPNG);
			
			trace(TAG + "failed to load PNG.");
		}
		
		private function onFailedLoadingXML(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onLoadedXML);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingXML);
			
			trace(TAG + "failed to load XML.");
		}
	}
}