package ui.popup
{
	import starling.display.Sprite;

	public class Popup extends Sprite
	{
		public function Popup()
		{
			// panel과 title은 Popup에 종속적으로 수정하고
			// 외부에서도 제어 가능하도록 수정
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