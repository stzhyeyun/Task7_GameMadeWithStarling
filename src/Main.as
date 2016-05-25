package
{
	import flash.filesystem.File;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	
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
			
			Resources.onReadyToUseResources = onCompleteLoad;
			Resources.load(File.applicationDirectory.resolvePath("resources/res"));
		}
		
		public override function dispose():void
		{
			_current = null;
			SceneManager.dispose();
			
			super.dispose();
		}
		
		private function onCompleteLoad():void
		{
			DataManager.initialize();
			SceneManager.initialize();
		}
	}
}