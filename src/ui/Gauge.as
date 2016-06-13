package ui
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Gauge extends Sprite
	{
		private const TAG:String = "[Gauge]";
		
		private var _total:int;
		private var _current:int;
		private var _base:Image;
		private var _bar:Image;
		
		public function get total():int
		{
			return _total;
		}
		
		public function set total(value:int):void
		{
			_total = value;
		}
		
		public function get current():int
		{
			return _current;
		}
		
		public function set current(value:int):void
		{
			_current = value;
		}
		
		
		public function Gauge(width:Number, height:Number, base:Texture, bar:Texture, total:int = 0)
		{
			if (width == 0 || height == 0 || !base || !bar)
			{
				if (width == 0 || height == 0) trace(TAG, " ctor : Width and Height can't be zero.");
				if (!base || !bar) trace(TAG, " ctor : Base and Bar can't be null.");
				return;
			}
			
			_base = new Image(base);
			_base.width = width;
			_base.height = height;
			addChild(_base);
			
			_bar = new Image(bar);
			_bar.width = _base.width * 0.95;
			_bar.height = _base.height * 0.7;
			_bar.x = _base.width * 0.02;
			_bar.y = _base.height * 0.15;
			_bar.scaleX = 0.01;
			addChild(_bar);
			
			_total = total;
			_current = 0;
		}

		public function update(current:int):void
		{
			if (!_bar || current < 0)
			{
				return;
			}
			
			_current = current;
			
			if (current != 0)
			{
				_bar.scaleX = _current / _total;
			}
		}
	}
}