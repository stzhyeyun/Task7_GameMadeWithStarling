package ui.popup
{
	import starling.display.Sprite;

	public class Popup extends Sprite
	{
		public function Popup()
		{

		}
		
		public function initialize():void
		{
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
		}
		
		public function show():void
		{
			this.visible = true;
			this.touchable = true;
		}
		
		public function close():void
		{
			this.visible = false;
		}
	}
}