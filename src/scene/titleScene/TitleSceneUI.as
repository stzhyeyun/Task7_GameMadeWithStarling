package scene.titleScene
{
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class TitleSceneUI extends Sprite
	{
		public function TitleSceneUI()
		{
			var screen:Rectangle = Screen.mainScreen.bounds;
			
			// Background - background
			var background:Image = new Image(Resources.getTexture(ResourcesName.ATLAS, ResourcesName.BACKGROUND_TITLE));
			background.width = screen.width;
			background.height = screen.height;
			addChild(background);
			
			// Background - bottom / top
			
			
			
			// Title (TextField)
			
			// Facebook Login (Button)

			// Rank (Button)
			
			// Setting (Button)
		}
	}
}