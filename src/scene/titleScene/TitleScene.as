package scene.titleScene
{
	import scene.Scene;
	import scene.SceneManager;
	import scene.SceneName;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TitleScene extends Scene
	{
		public function TitleScene(name:String)
		{
			super(name);
		}
		
		public override function initialize():void
		{
			var ui:TitleSceneUI = new TitleSceneUI();
			addChild(ui);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public override function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			super.dispose();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (!touch)
			{
				return;
			}
			
			SceneManager.switchScene(SceneName.GAME);
		}
	}
}