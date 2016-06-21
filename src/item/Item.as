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
		
		/**
		 * Item을 생성합니다. 
		 * @param data ItemData입니다.
		 * @param onUse Item 기능이 구현된 함수입니다. Item 사용(클릭) 시 호출됩니다.
		 * 
		 */
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
			
			// 수량 표시
			_quantity = new SpriteNumber(_data.num.toString(), Color.ITEM);
			var scale:Number = this.height * 0.3 / _quantity.height;
			_quantity.width *= scale;
			_quantity.height *= scale;
			_quantity.x = (this.width / 2);
			_quantity.y = this.height;
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
		
		/**
		 * Item의 개수를 조절하고 남은 개수에 따라 버튼 활성화 여부를 제어합니다. 
		 * @param quantity Item의 개수입니다.
		 * 
		 */
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
			_quantity.x = (this.width / 2);
			
			// UserInfo & DB 업데이트
			UserManager.instance.updateItemData(UserManager.SET_ITEM, _data.id, _data.num, true);
		}
		
		protected virtual function onEnded(event:TouchEvent):void
		{
			// Empty
		}
	}
}