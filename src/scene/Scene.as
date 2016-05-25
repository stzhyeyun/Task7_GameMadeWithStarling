package scene
{
	import starling.core.Starling;
	import starling.display.Sprite;

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
		
		
		public function Scene(name:String)
		{
			if (!name)
			{
				trace("Scene : No name."); 
				return;
			}
			
			this.name = name;
			_nativeStageWidth = Starling.current.nativeStage.stageWidth;
			_nativeStageHeight = Starling.current.nativeStage.stageHeight;
		}

		public virtual function initialize():void
		{
			// Empty
		}
	}
}