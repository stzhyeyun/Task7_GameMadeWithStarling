package scene.titleScene
{
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class TitleSceneUI extends Sprite
	{
		public function TitleSceneUI()
		{
			var screen:Rectangle = Screen.mainScreen.bounds;
			
			// Background
			var background:Image = new Image(Resources.getTexture(ResourcesName.ATLAS, ResourcesName.BACKGROUND_TITLE));
			background.width = screen.width;
			background.height = screen.height;
			addChild(background);
			
			// Title (TextField)
			var format:TextFormat = new TextFormat("carterOne", 50);
			var titleTop:TextField = new TextField(screen.width / 3, screen.height / 3, "100", format);
			titleTop.pivotX = titleTop.width / 2;
			titleTop.pivotY = titleTop.height / 2;
			titleTop.x = screen.width / 2;
			titleTop.y = screen.height / 5;
			addChild(titleTop);
			
			var titleBottom:TextField = new TextField(screen.width / 3, screen.height / 3, "blocks", format);
			titleBottom.pivotX = titleTop.width / 2;
			titleBottom.pivotY = titleTop.height / 2;
			titleBottom.x = screen.width / 2;
			titleBottom.y = screen.height / 4;
			addChild(titleTop);
			
			// Facebook Login (Button)

			// Rank (Button)
			
			// Setting (Button)
		}
	}
}