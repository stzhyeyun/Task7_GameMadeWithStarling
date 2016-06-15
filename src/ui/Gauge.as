package ui
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Gauge extends Sprite
	{
		private const TAG:String = "[Gauge]";
		
		private var _total:int;
		private var _current:int;
		private var _bar:Image;
		private var _progress:Image;

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
		
		public function get bar():Image
		{
			return _bar;
		}
		
		public function set bar(value:Image):void
		{
			_bar = value;
		}
		
		public function get progress():Image
		{
			return _progress;
		}
		
		public function set progress(value:Image):void
		{
			_progress = value;
		}
		
		
		public function Gauge(bar:Image, progress:Image, total:int = 0)
		{
			if (!bar || !progress)
			{
				if (!bar || !progress) trace(TAG, " ctor : Bar and Progress can't be null.");
				return;
			}
			
			_bar = bar;
			_progress = progress;
			
			_progress.scaleX = 0.01;
			addChild(_bar);
			addChild(_progress);
			
			_total = total;
			_current = 0;
		}

		public function update(current:int):void
		{
			if (!_progress || current < 0)
			{
				return;
			}
			
			_current = current;
			
			if (current != 0)
			{
				_progress.scaleX = _current / _total;
			}
		}
	}
}