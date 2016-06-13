package ui
{
	import resources.Resources;
	import resources.TextureAtlasName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class SpriteNumber extends Sprite
	{
		private var _numbers:Vector.<Image>;
		private var _color:uint;

		public function set color(value:uint):void
		{
			_color = value;
		}
		
		
		public function SpriteNumber(num:String, color:uint = Color.BLACK)
		{
			_numbers = new Vector.<Image>();
			_color = color;
			
			update(num);
		}
		
		public override function dispose():void
		{
			if (_numbers)
			{
				for (var i:int = 0; i < _numbers.length; i++)
				{
					_numbers[i].dispose();
					_numbers[i] = null;
				}
			}
			_numbers = null;
			
			super.dispose();
		}

		public function update(num:String):void
		{
			var image:Image;
			
			if (num.length > _numbers.length)
			{
				var diff:int = num.length - _numbers.length;
				
				for (var i:int = 0; i < diff; i++)
				{
					image = new Image(null);
					_numbers.push(image);
					addChild(image);
				}
			}
			else if (num.length < _numbers.length)
			{
				for (i = num.length; i < _numbers.length; i++)
				{
					_numbers[i].visible = false;
				}
			}
			
			var texture:Texture;
			var totalWidth:Number = 0;
			for (i = 0; i < num.length; i++)
			{
				texture = Resources.instance.getTexture(TextureAtlasName.MAIN, num.charAt(i));
				_numbers[i].width = texture.width;
				_numbers[i].height = texture.height;
				_numbers[i].texture = texture;
				
				totalWidth += _numbers[i].width;
			}
			
			var left:Number = -(totalWidth / 2);
			var widthSoFar:Number = 0;
			for (i = 0; i < num.length; i++)
			{
				_numbers[i].pivotX = _numbers[i].width / 2;
				_numbers[i].pivotY = _numbers[i].height / 2;
				_numbers[i].x = left + widthSoFar + _numbers[i].width / 2;
				_numbers[i].color = _color;
				_numbers[i].visible = true;
				
				widthSoFar += _numbers[i].width;
			}
		}
	}
}