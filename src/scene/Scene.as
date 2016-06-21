package scene
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Scene extends Sprite
	{
		public static const START_SCENE:String = "startScene";
		public static const RESTART_SCENE:String = "restartScene";
		public static const END_SCENE:String = "endScene";
		
		private var _nativeStageWidth:Number;
		private var _nativeStageHeight:Number;
		
		public function get nativeStageWidth():Number
		{
			return _nativeStageWidth;
		}

		public function get nativeStageHeight():Number
		{
			return _nativeStageHeight;
		}
		
		
		public function Scene()
		{
			_nativeStageWidth = Starling.current.nativeStage.stageWidth;
			_nativeStageHeight = Starling.current.nativeStage.stageHeight;
			
			addEventListener(START_SCENE, onStartScene);
			addEventListener(RESTART_SCENE, onRestartScene);
			addEventListener(END_SCENE, onEndScene);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public override function dispose():void
		{
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			super.dispose();
		}

		public virtual function initialize():void
		{
			// Empty
		}
		
		protected virtual function onStartScene(event:Event):void
		{
			// Empty
		}
		
		protected virtual function onRestartScene(event:Event):void
		{
			// Empty
		}
		
		protected virtual function onEndScene(event:Event):void
		{
			// Empty
		}
		
		protected virtual function onKeyDown(event:KeyboardEvent):void
		{
			// Empty
		}
	}
}