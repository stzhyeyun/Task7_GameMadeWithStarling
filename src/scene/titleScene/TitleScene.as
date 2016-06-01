package scene.titleScene
{
	//import com.freshplanet.ane.AirFacebook.Facebook;
	
	import com.facebook.graph.Facebook;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import gamedata.DataManager;
	
	import resources.Resources;
	import resources.TextureName;
	
	import scene.Scene;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import ui.popup.PopupManager;
	import ui.popup.PopupName;

	public class TitleScene extends Scene
	{
		private const FACEBOOK_APP_ID:String = "943928415704678";
		private var _permissions:Array;
		
		public function TitleScene()
		{
			
		}
		
		public override function initialize():void
		{
			// Background
			var background:Image = new Image(Resources.getTexture(TextureName.BACKGROUND_TITLE));
			background.width = this.nativeStageWidth;
			background.height = this.nativeStageHeight;
			addChild(background);
			
			// UI
			var titleUI:TitleSceneUI = new TitleSceneUI();
			titleUI.initialize(this.nativeStageWidth, this.nativeStageHeight);
			addChild(titleUI);
			
	
			
			
			
			
			
			//com.freshplanet.ane.AirFacebook.Facebook//
//			Facebook.getInstance().init(FACEBOOK_APP_ID, false);
//			Facebook.getInstance().logEnabled = true;
//			
//			if (Facebook.getInstance().isSessionOpen)
//			{
//				onSucceedLogin();
//			}
//			else
//			{
//				_permissions = new Array();
//				_permissions.push("public_profile");
//				
//				Facebook.getInstance().openSessionWithReadPermissions(_permissions, onGotLoginResult);
//			}
		}
		
		protected override function onEndScene(event:Event):void
		{
			DataManager.export();
		}
		
		protected override function onKeyDown(event:KeyboardEvent):void
		{
			if (!this.parent)
			{
				return;
			}
			
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopupManager.showPopup(this, PopupName.EXIT);
			}
		}
		
//		private function onGotLoginResult(success:Boolean, userCancelled:Boolean, error:String):void
//		{
//			if (userCancelled)
//			{
//				//onCancelledLogin();
//				function onCancelledLogin():void
//				{
//					trace("onCancelledLogin");
//					
//				}
//				return;
//			}
//			else if (!success)
//			{
//				trace("onGotLoginResult : " + error);
//				//onCatchError();
//				function onCatchError():void
//				{
//					trace("onCatchError");
//					
//				}
//				return;
//			}
//			
//			trace("onGotLoginResult : Init succeeded.");
//			onSucceedLogin();
//		}
//		
//		private function onSucceedLogin():void
//		{
//			trace("onSucceedLogin");
//					
//			Facebook.getInstance().requestWithGraphPath("me", null, "GET",
//				function onGotProfile(data:Object):void
//				{
//					if (data)
//					{
//						var id:String = data.id;
//						var name:String = data.name;
//						var url:String = "https://graph.facebook.com/" + id + "/picture?type=square";
//						//var url:String = "https://graph.facebook.com/" + id + "/picture";
//						var loader:URLLoader = new URLLoader();
//						loader.dataFormat = URLLoaderDataFormat.BINARY;
//						loader.addEventListener(flash.events.Event.COMPLETE,
//							function onLoadedURL(event:flash.events.Event):void
//							{
//								var byteArray:ByteArray = event.currentTarget.data;
//								
//								var loader:Loader = new Loader();
//								loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
//									function onLoadedByteArray(event:flash.events.Event):void
//									{
//										var bitmap:Bitmap = event.currentTarget.loader.content as Bitmap;	
//										var img:Image = new Image(Texture.fromBitmap(bitmap));
//										img.width = 100;
//										img.height = 100;
//										addChild(img);
//									});
//								loader.loadBytes(byteArray);
//							});
//						loader.load(new URLRequest(url));
//					}
//				});
//			
//			// ID
//			// 이름
//			// 프로필 사진
//			
//			// 엑세스 토큰
//			// Facebook.getInstance().accessToken
//		}
		
//		private function onCancelledLogin():void
//		{
//			trace("onCancelledLogin");
//			
//		}
//		
//		private function onCatchError():void
//		{
//			trace("onCatchError");
//			
//		}
	}
}