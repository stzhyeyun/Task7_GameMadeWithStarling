package scene
{
	import starling.display.Sprite;

	public class Scene extends Sprite
	{
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		public function Scene(name:String)
		{
			if (!name)
			{
				trace("Scene : No name."); 
				return;
			}
			
			this.name = name;
			_data = null;
		}
		
		public virtual function initialize():void
		{
			// Empty
		}
		
		public override function dispose():void
		{
			_data = null;
			
			super.dispose();
		}
	}
}