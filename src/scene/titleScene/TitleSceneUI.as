package scene.titleScene
{
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class TitleSceneUI extends Sprite
	{
		public function TitleSceneUI()
		{

		}
		
		public function initialize(stageWidth:Number, stageHeight:Number):void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(ResourcesName.BACKGROUND_TITLE));
			background.width = stageWidth;
			background.height = stageHeight;
			addChild(background);
			
			// Title

			
			// Facebook Login
			
			
			// Rank
			
			
			// Setting
			
			
		}
	}
}