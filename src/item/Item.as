package item
{
	import resources.Resources;
	import resources.TextureAtlasName;
	
	import starling.display.Button;
	import starling.events.TouchEvent;
	
	import ui.SpriteNumber;
	
	import user.UserManager;
	
	import util.Color;

	public class Item extends Button
	{
		private const TAG:String = "[Item]";
		
		protected var _data:ItemData;
		protected var _quantity:SpriteNumber;
		protected var _onUse:Function;
		
		public function Item(data:ItemData, onUse:Function)
		{
			_data = data;
			_onUse = onUse;
			
			super(Resources.instance.getTexture(TextureAtlasName.MAIN, _data.imgName));
			
			if (_data.num == 0)
			{
				this.color = Color.INACTIVE;
				this.touchable = false;
			}
			
			// Quantity indicator
			_quantity = new SpriteNumber(_data.num.toString(), Color.ITEM);
			var scale:Number = this.height * 0.3 / _quantity.height;
			_quantity.width *= scale;
			_quantity.height *= scale;
			_quantity.x = (this.width / 2) - (_quantity.width / 2);
			_quantity.y = this.height * 0.85;
			addChild(_quantity);
			
			addEventListener(TouchEvent.TOUCH, onEnded);
		}
		
		public override function dispose():void
		{
			if (_data)
			{
				_data.dispose();
			}
			_data = null;
			
			super.dispose();
		}
		
		public function setQuantity(quantity:int):void
		{
			if (quantity < 0)
			{
				trace(TAG + " setQuantity : Invalid quantity.");
				return;
			}
			
			_data.num = quantity;
			if (_data.num == 0)
			{
				this.color = Color.INACTIVE;
				this.touchable = false;	
			}
			else
			{
				this.color = Color.ACTIVE;
				this.touchable = true;
			}
			
			_quantity.update(_data.num.toString());
			
			// Update UserInfo & DB
			UserManager.instance.updateItemData(UserManager.SET_ITEM, _data.id, _data.num, true);
		}
		
		protected virtual function onEnded(event:TouchEvent):void
		{
			// Empty
		}
	}
}