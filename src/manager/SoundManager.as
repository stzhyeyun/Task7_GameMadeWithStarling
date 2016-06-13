package manager
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import media.Sound;
	
	public class SoundManager
	{
		private static const TAG:String = "[SoundManager]";
		private static const MAX_CHANNEL:int = 32; 
		
		private static var _channels:Vector.<SoundChannel>; // 동시에 32개까지 사용 가능
		private static var _bgm:Sound;
		
		private static var _isBgmActive:Boolean = true;
		private static var _isSoundEffectActive:Boolean = true;
		
		public static function get isBgmActive():Boolean
		{
			return _isBgmActive;
		}
		
		public static function set isBgmActive(value:Boolean):void
		{
			_isBgmActive = value; 
		}
		
		public static function get isSoundEffectActive():Boolean
		{
			return _isSoundEffectActive;
		}
		
		public static function set isSoundEffectActive(value:Boolean):void
		{
			_isSoundEffectActive = value;
		}
		
		
		public function SoundManager()
		{
			 
		}
		
		public static function dispose():void
		{
			stopAll();
			
			if (_channels)
			{
				for (var i:int = 0; i < _channels.length; i++)
				{
					_channels[i] = null;
				}
				_channels.splice(0, _channels.length);
			}
			_channels = null;
			
			_bgm = null;
		}
		
		/**
		 * 지정한 Sound를 재생합니다. 재생하고자 하는 Sound가 BGM(무한반봅 설정된 Sound)일 경우 현재 재생 중인 BGM은 정지됩니다. isBgmActive가 false일 경우 BGM, isSoundEffectActive가 false일 경우 사운드 이펙트의 재생 명령을 무시합니다.
		 * @param name 재생하고자 하는 Sound의 이름입니다.
		 * 
		 */
		public static function play(sound:Sound):void
		{
			if (!sound)
			{
				trace(TAG + " play : No sound.");
				return;
			}
			
			if (_channels && _channels.length == MAX_CHANNEL)
			{
				trace(TAG + " play : Cannot add channel.");
				return;
			}
			
			var loops:int = sound.loops;
			var isInfinite:Boolean = false;
			if (loops == Sound.INFINITE)
			{
				if (!isBgmActive) return;
				
				loops = 0;
				isInfinite = true;
				stopBgm();				
			}
			else
			{
				if (!isSoundEffectActive) return;
			}
			
			var channel:SoundChannel =
				sound.play(sound.startTime, loops, new SoundTransform(sound.volume, sound.panning));
			
			// Channel 저장			
			if (!_channels)
			{
				_channels = new Vector.<SoundChannel>();
			}
			
			var pushed:Boolean = false;
			for (var i:int = 0; i < _channels.length; i++)
			{
				if (_channels[i] == null)
				{
					_channels[i] = channel;
					pushed = true;
					break;
				}
			}
			
			if (!pushed)
			{
				_channels.push(channel);
			}
			sound.channelIndex = _channels.indexOf(channel);
			
			// addEventListener
			if (!isInfinite)
			{
				channel.addEventListener(Event.SOUND_COMPLETE, onEnd);
			}
			else
			{
				channel.addEventListener(Event.SOUND_COMPLETE, onEndBgm);
				_bgm = sound;
			}
		}
		
		/**
		 * 현재 재생 중인 모든 Sound를 정지합니다. 
		 * 
		 */
		public static function stopAll():void
		{
			SoundMixer.stopAll();
			
			var index:int = -1;
			if (_bgm)
			{
				index = _bgm.channelIndex;
			}
			
			if (_channels)
			{
				for (var i:int = 0; i < _channels.length; i++)
				{
					if (_channels[i])
					{
						// BGM 중단 위치 저장
						if (i == index)
						{
							//_bgm.startTime = _channels[i].position;
							_channels[i].removeEventListener(Event.SOUND_COMPLETE, onEndBgm);
						}
						else
						{
							_channels[i].removeEventListener(Event.SOUND_COMPLETE, onEnd);
						}
					} 
					_channels[i] = null;
				}
			}
			_channels = null;
		}
		
		/**
		 * 현재 재생 중인 모든 사운드 이펙트를 정지합니다. 
		 * 
		 */
		public static function stopSoundEffect():void
		{
			var index:int = -1;
			if (_bgm)
			{
				index = _bgm.channelIndex;
			}
			
			if (_channels)
			{
				for (var i:int = 0; i < _channels.length; i++)
				{
					if (_channels[i] && i != index)
					{
						_channels[i].removeEventListener(Event.SOUND_COMPLETE, onEnd);
						_channels[i].stop();
						_channels[i] = null;
					}
				}
			}
		}
		
		/**
		 * 현재 재생 중인 BGM(무한반봅 설정된 Sound)을 정지합니다. 
		 * 
		 */
		public static function stopBgm():void
		{
			var index:int = -1;
			if (_bgm)
			{
				index = _bgm.channelIndex;
			}
			
			if (_channels && _channels[index])
			{
				//_bgm.startTime = _channels[index].position;
				
				_channels[index].removeEventListener(Event.SOUND_COMPLETE, onEndBgm);
				_channels[index].stop();
				_channels[index] = null;
			}
		}
		
		/**
		 * 가장 최근에 정지한 BGM(무한반봅 설정된 Sound)을 다시 재생합니다. 
		 * 
		 */
		public static function wakeBgm():void
		{
			if (!_bgm || !_isBgmActive)
			{
				if (!_bgm) trace(TAG + " wakeBgm : No BGM.");
				if (!_isBgmActive) trace(TAG + " wakeBgm : BGM is inactive.");
				return;
			}
			
			var channel:SoundChannel =
				_bgm.play(_bgm.startTime, 0, new SoundTransform(_bgm.volume, _bgm.panning));
			
			// Channel 저장			
			if (!_channels)
			{
				_channels = new Vector.<SoundChannel>();
			}
			
			var pushed:Boolean = false;
			for (var i:int = 0; i < _channels.length; i++)
			{
				if (_channels[i] == null)
				{
					_channels[i] = channel;
					pushed = true;
					break;
				}
			}
			
			if (!pushed)
			{
				_channels.push(channel);
			}
			_bgm.channelIndex = _channels.indexOf(channel);
			
			// addEventListener
			channel.addEventListener(Event.SOUND_COMPLETE, onEndBgm);
		}
				
		/**
		 * Sound의 재생이 끝나면 해당 SoundChannel의 인덱스를 null 처리합니다. 
		 * @param event Event.SOUND_COMPLETE
		 * 
		 */
		private static function onEnd(event:Event):void
		{
			var channel:SoundChannel = event.target as SoundChannel;
			
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, onEnd);
				
				if (_channels)
				{
					var index:int = _channels.indexOf(channel);
					if (index != -1)
					{
						_channels[index] = null;
					}
				}
			}
		}
		
		/**
		 * BGM(무한반복되도록 설정된 Sound)의 재생이 끝나면 다시 재생을 시작합니다.
		 * @param event Event.SOUND_COMPLETE
		 * 
		 */
		private static function onEndBgm(event:Event):void
		{
			var channel:SoundChannel = event.target as SoundChannel;
			
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, onEndBgm);
				
				_bgm.startTime = 0;
				channel = _bgm.play(_bgm.startTime, 0, channel.soundTransform);
				channel.addEventListener(Event.SOUND_COMPLETE, onEndBgm);
			}
		}
	}
}
