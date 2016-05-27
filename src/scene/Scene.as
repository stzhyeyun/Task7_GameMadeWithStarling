package scene
{
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;

	public class Scene extends Sprite
	{
		private var _nativeStageWidth:Number;
		private var _nativeStageHeight:Number;
		
		public function get nativeStageWidth():Number
		{
			return _nativeStageWidth;
		}
		
		public function set nativeStageWidth(value:Number):void
		{
			_nativeStageWidth = value;
		}

		public function get nativeStageHeight():Number
		{
			return _nativeStageHeight;
		}
		
		public function set nativeStageHeight(value:Number):void
		{
			_nativeStageHeight = value;
		}
		
		
		public function Scene()
		{
			_nativeStageWidth = Starling.current.nativeStage.stageWidth;
			_nativeStageHeight = Starling.current.nativeStage.stageHeight;
			
			addEventListener(Event.ACTIVATE, onActivate);
			addEventListener(Event.DEACTIVATE, onDeactivate);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public virtual function initialize():void
		{
			// Empty
		}
		
		protected virtual function onActivate(event:Event):void
		{
			// Empty
		}
		
		protected virtual function onDeactivate(event:Event):void
		{
			// Empty
		}
		
		protected virtual function onKeyDown(event:KeyboardEvent):void
		{
			// Empty
		}
	}
}