package ui
{
	import resources.Resources;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class SpriteNumber extends Sprite
	{
		//private var _numbers:Vector.<Image>;
		private var _color:uint;
		
		public function set color(value:uint):void
		{
			_color = value;
		}

		
		public function SpriteNumber(num:int, color:uint = 0xffffff)
		{
			//_numbers = new Vector.<Image>();
			_color = color;
			
			update(num);
		}
		
		public override function dispose():void
		{
			// to do
			
			super.dispose();
		}

		public function update(num:int):void
		{
			// 자릿수가 늘어날 때만 new 하도록 변경할 것
			
			removeChildren();
			
			var numStr:String = num.toString();
			var numbers:Vector.<Image> = new Vector.<Image>();
			var number:Image;
			var numWidth:Number = 0;
			for (var i:int = 0; i < numStr.length; i++)
			{
				number = new Image(Resources.getTexture(numStr.charAt(i)));
				numbers.push(number);
				
				numWidth += number.width;
			}
			
			var left:Number = -(numWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < numbers.length; i++)
			{
				numbers[i].pivotX = numbers[i].width / 2;
				numbers[i].pivotY = numbers[i].height / 2;
				numbers[i].x = left + widthSoFar + numbers[i].width / 2;
				numbers[i].color = _color;
				addChild(numbers[i]);
				
				widthSoFar += numbers[i].width;
			}
			
			numStr = null;
			numbers.splice(0, numbers.length); 
			numbers = null;
			number = null;
		}
	}
}