package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="720", height="960", frameRate="60")]
	
	public class HundredBlocks extends Sprite
	{
		private var _starling:Starling;
		
		public function HundredBlocks()
		{
			super();
		
			_starling = new Starling(Main, stage);
			_starling.start();
			
			_starling.showStats = true; // debug
		}
	}
}