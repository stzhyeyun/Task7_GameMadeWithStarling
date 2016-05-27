package ui.popup
{
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;

	public class Popup extends Sprite
	{
		private const TAG:String = "[Popup]";
		
		private var _assets:Dictionary;
		
		public function Popup(base:Image)
		{
			addChild(base);
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			
			_assets = new Dictionary();
			_assets[base] = base;
		}
		
		public override function dispose():void
		{
			if (_assets)
			{
				for (var key:Object in _assets)
				{
					//_assets[key].dispose();
					delete _assets[key];
				}
			}
			_assets = null;
			
			super.dispose();
		}
		
		public function addAsset(name:String, asset:DisplayObject):void
		{
			if (!name || !asset)
			{
				if (!name) trace(TAG + " addAsset : No name.");
				if (!asset) trace(TAG + " addAsset : No asset.");
				return;
			}
			
			_assets[name] = asset;
		}
		
		public function removeAsset(name:String):void
		{
			if (!name || !_assets[name])
			{
				if (!name) trace(TAG + " removeAsset : No name.");
				if (!_assets[name]) trace(TAG + " removeAsset : Not registered name.");
				return;
			}
			
			removeChild(_assets[name], true);
			delete _assets[name];
		}
		
		public function getAsset(name:String):DisplayObject
		{
			if (!name || !_assets[name])
			{
				if (!name) trace(TAG + " getAsset : No name.");
				if (!_assets[name]) trace(TAG + " getAsset : Not registered name.");
				return null;
			}
			
			return _assets[name];
		}
	}
}