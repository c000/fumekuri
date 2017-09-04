package;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

using Lambda;

class ManagedMusic {
	private var sound : Sound;
	public var channel(default,null) : Null<SoundChannel>;
	public var bpm(default,null) : Float;

	private var lastPos : Float;
	private var posHistory : Array<Float>;
	private var soundTransform : Null<SoundTransform>;

	private static inline var offset : Float = 2000.0 / Config.fps;

	public function new (music : Sound, bpm : Float, ?transform : SoundTransform) {
		this.sound = music;
		this.bpm = bpm;
		soundTransform = transform;
	}

	public function play () {
		stop ();
		channel = sound.play (0, 1, soundTransform);
		posHistory = new Array ();
	}

	public function stop () {
		if (channel != null) {
			channel.stop ();
		}
		channel = null;
	}

	public function getRelativePos () {
		return channel.position / sound.length;
	}

	public function getBeatPos () {
		var beat = 60000 / bpm;
		return (channel.position + offset) / beat;
	}

	public function getBeatMax () {
		var beat = 60000 / bpm;
		return sound.length / beat;
	}

	public function getBeat () : Bool {
		var beatPos = getBeatPos ();
		var result = false;
		if (Math.floor (lastPos) != Math.floor (beatPos)) {
			result = true;
		}
		lastPos = beatPos;
		return result;
	}

	public function isPlaying () : Bool {
		if (channel == null) {
			return false;
		}

		if (sound.length < channel.position + 1000) {
			posHistory.push (channel.position);
			if (posHistory.length > 3) {
				posHistory.shift ();
				for (i in 1...posHistory.length) {
					if (posHistory[0] != posHistory[i]) {
						return true;
					}
				}
				return false;
			}
			return true;
		} else {
			return true;
		}
	}
}
