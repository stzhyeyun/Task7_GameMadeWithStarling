package item
{
	import resources.TextureName;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class RefreshBlocks extends Item
	{
		public function RefreshBlocks(onUse:Function)
		{
			super(new ItemData(ItemID.REFRESH_BLOCKS, 0,
				TextureName.ITEM_REFRESH, TextureName.ITEM_REFRESH_NONE),
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
				_onUse(true);
				setQuantity(--_data.num);
			}
		}
	}
}