package
{
	import data.DataManager;
	
	import scene.SceneManager;
	
	import starling.display.Sprite;

	public class Main extends Sprite
	{
		private static var _current:Main;

		public static function get current():Main
		{
			return _current;
		}
		
		
		public function Main()
		{
			_current = this;
			
			// load resources
			// when completed loading resources,
			DataManager.initialize();
			SceneManager.initialize();
		}
		
		public override function dispose():void
		{
			_current = null;
			SceneManager.dispose();
			
			super.dispose();
		}
	}
}