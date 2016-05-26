package scene.titleScene
{
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	import resources.Resources;
	import resources.ResourcesName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;

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
			
			// Title (TextField)
			var format:TextFormat = new TextFormat("carterOne", 50);
			var titleTop:TextField = new TextField(stageWidth / 3, stageHeight / 3, "100", format);
			titleTop.pivotX = titleTop.width / 2;
			titleTop.pivotY = titleTop.height / 2;
			titleTop.x = stageWidth / 2;
			titleTop.y = stageHeight / 5;
			addChild(titleTop);
			
			var titleBottom:TextField = new TextField(stageWidth / 3, stageHeight / 3, "blocks", format);
			titleBottom.pivotX = titleTop.width / 2;
			titleBottom.pivotY = titleTop.height / 2;
			titleBottom.x = stageWidth / 2;
			titleBottom.y = stageHeight / 4;
			addChild(titleTop);
			
			// Facebook Login (Button)
			
			// Rank (Button)
			
			// Setting (Button)
		}
	}
}