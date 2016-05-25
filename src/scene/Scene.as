package scene
{
	import starling.display.Sprite;

	public class Scene extends Sprite
	{
		public function Scene(name:String)
		{
			if (!name)
			{
				trace("Scene : No name."); 
				return;
			}
			
			this.name = name;
		}
		
		public virtual function initialize():void
		{
			// Empty
		}
	}
}