package system
{
	import starling.events.EventDispatcher;

	public class Manager extends EventDispatcher
	{
		public static const INITIALIZED:String = "initialized";
		
		
		public function Manager()
		{
			
		}
		
		public virtual function dispose():void
		{
			// Empty
		}
		
		public virtual function initialize():void
		{
			// Empty
		}
	}
}