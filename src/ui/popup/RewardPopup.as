package ui.popup
{
	import com.bamkie.ToastExtension;
	
	import media.SoundManager;
	
	import resources.Resources;
	import resources.SoundName;
	import resources.TextureAtlasName;
	import resources.TextureName;
	
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	
	import system.AttendanceManager;
	
	import util.Color;

	public class RewardPopup extends Popup
	{
		private const TAG:String = "[RewardPopup]";
		
		private var _days:Vector.<Image>;
		private var _checks:Vector.<Image>;
		
		private var _panelWidth:Number;
		private var _panelHeight:Number;
		
		private var _day:int;
		
		// for Check animation
		private const ANIM_SPEED:Number = 0.05;
		private var _maximized:Boolean;
		
		private var _toaster:ToastExtension;	
		
		
		public function RewardPopup()
		{
			
		}
		
		public override function initialize():void
		{
			var panel:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.POPUP));
			var title:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.TITLE_REWARD));
			
			_panelWidth = panel.width;
			_panelHeight = panel.height;
			
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.x = _panelWidth / 2;
			
			// 출석 보상 내용
			var day1:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_REWARD_DAY1));
			var scale:Number = _panelWidth * 0.7 / day1.width;
			day1.width *= scale;
			day1.height *= scale;
			day1.pivotY = day1.height / 2;
			day1.x = (_panelWidth / 2) - (day1.width / 2);
			day1.y = _panelHeight * 0.28;
			
			var day2:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_REWARD_DAY2));
			day2.width *= scale;
			day2.height *= scale;
			day2.pivotY = day2.height / 2;
			day2.x = (_panelWidth / 2) - (day2.width / 2);
			day2.y = _panelHeight * 0.43;

			var day3:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_REWARD_DAY3));
			day3.width *= scale;
			day3.height *= scale;
			day3.pivotY = day3.height / 2;
			day3.x = (_panelWidth / 2) - (day3.width / 2);
			day3.y = _panelHeight * 0.58;
			
			var day4:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_REWARD_DAY4));
			day4.width *= scale;
			day4.height *= scale;
			day4.pivotY = day4.height / 2;
			day4.x = (_panelWidth / 2) - (day4.width / 2);
			day4.y = _panelHeight * 0.73;
			
			var day5:Image = new Image(
				Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_REWARD_DAY5));
			day5.width *= scale;
			day5.height *= scale;
			day5.pivotY = day5.height / 2;
			day5.x = (_panelWidth / 2) - (day5.width / 2);
			day5.y = _panelHeight * 0.88;
			
			_days = new Vector.<Image>();
			_days.push(day1);
			_days.push(day2);
			_days.push(day3);
			_days.push(day4);
			_days.push(day5);
			
			addChild(panel);
			addChild(title);
			addChild(day1);
			addChild(day2);
			addChild(day3);
			addChild(day4);
			addChild(day5);
			
			// Checks
			_checks = new Vector.<Image>();
			var check:Image;
			for (var i:int = 0; i < _days.length; i++)
			{
				check = new Image(
					Resources.instance.getTexture(TextureAtlasName.MAIN, TextureName.IMG_CHECK));
				check.pivotX = check.width / 2;
				check.pivotY = check.height / 2;
				check.x = _panelWidth * 0.77;
				check.y = _days[i].y - check.height / 2;
				
				_checks.push(check);
				addChild(check);
			}
			
			_day = 0;
			_maximized = false;
			_toaster = new ToastExtension();
			
			super.initialize();
		}
		
		public override function dispose():void
		{
			_toaster = null;
			
			super.dispose();
		}
		
		public override function show():void
		{
			super.show();
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			SoundManager.play(Resources.instance.getSound(SoundName.CLEAR));
			
			AttendanceManager.instance.reward();
			_toaster.toast("You've got REWARDS for Day " + _day.toString() + "!");
		}
		
		/**
		 * 유저의 출석 일수 기준으로 팝업을 세팅합니다. 
		 * @param day 연속 출석한 일수입니다.
		 * 
		 */
		public function setDay(day:int):void
		{
			_day = day;
			
			day = day - 1;
			if (day < 0 || day >= _days.length)
			{
				trace(TAG + " setDay : Invalid day.");
				return;
			}
			
			for (var i:int = 0; i < _days.length; i++)
			{
				if (i == day)
				{
					_days[i].color = Color.ACTIVE;
					_checks[i].color = Color.ACTIVE;
					_checks[i].scale = 0.01;
					_checks[i].visible = true;
				}
				else if (i < day)
				{
					_days[i].color = Color.INACTIVE;
					_checks[i].color = Color.INACTIVE;
					_checks[i].scale = 1;
					_checks[i].visible = true;
				}
				else if (i > day)
				{
					_days[i].color = Color.ACTIVE;
					_checks[i].visible = false;
				}
			}
			
			_maximized = false;
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			// 체크 표시 애니메이션
			var index:int = _day - 1;
			if (index < 0 || index >= _days.length)
			{
				return;
			}
						
			if (_maximized)
			{
				_checks[index].scale -= ANIM_SPEED;
			}
			else
			{
				_checks[index].scale += ANIM_SPEED;	
			}
			
			if (_maximized && _checks[index].scale <= 1)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				_maximized = false;
			}
			
			if (_checks[index].scale >= 2)
			{
				_maximized = true;
			}
		}
	}
}