package item
{
	import resources.TextureName;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Undo extends Item
	{
		public function Undo(onUse:Function)
		{
			super(
				new ItemData(ItemID.UNDO, 0, TextureName.ITEM_UNDO),
				onUse);
		}
		
		protected override function onEnded(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (!touch || _data.num <= 0)
			{
				return;
			}
			
			if (_onUse)
			{
				if (_onUse())
				{
					setQuantity(--_data.num);
				}
			}
		}
	}
}