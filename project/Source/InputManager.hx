package;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.media.Sound;
import openfl.Assets;

class InputManager {
	public var pushedKey(default,null) : Map<Input,Void>;
	private var pushedKeyOnce : Map<Input,Void>;

	private var pushedChar : Map<Int,Void>;
	private var fu : Sound;
	private var me : Sound;
	private var ku : Sound;
	private var ri : Sound;

	public function new () {
		reset ();
		fu = Assets.getSound ("assets/voice1_fu.wav");
		me = Assets.getSound ("assets/voice2_me.wav");
		ku = Assets.getSound ("assets/voice3_ku.wav");
		ri = Assets.getSound ("assets/voice4_ri.wav");
	}

	public function reset () {
		pushedKey = new Map ();
		pushedKeyOnce = new Map ();
		pushedChar = new Map ();
	}

	private function fromKeyCode (keyCode : UInt) : Null<Input> {
		var result = null;
		switch (keyCode) {
			case Keyboard.LEFT:
				result = Input.Left;
			case Keyboard.RIGHT:
				result = Input.Right;
			case Keyboard.SPACE:
				result = Input.Enter;
		}
		return result;
	}

	private function setOnce (key : Input) {
		if (!pushedKey.exists (key)) {
			pushedKeyOnce.set (key, null);
		}
	}

	public function keyDown (e : KeyboardEvent) {
		var key = fromKeyCode (e.keyCode);
		if (key != null) {
			setOnce (key);
			pushedKey.set (key, null);
		} else {
			if (!pushedChar.exists (e.keyCode)) {
				execKeyCode (e.keyCode);
			}
			pushedChar.set (e.keyCode, null);
		}
	}

	public function keyUp (e : KeyboardEvent) {
		var key = fromKeyCode (e.keyCode);
		if (key != null) {
			pushedKey.remove (key);
			pushedKeyOnce.remove (key);
		} else {
			pushedChar.remove (e.keyCode);
		}
	}

	public function isKeyDown (k : Input) {
		return pushedKey.exists (k);
	}

	public function getKeyOnce (k : Input) {
		return pushedKeyOnce.remove (k);
	}

	private function execKeyCode (keyCode) {
		if (keyCode == 'F'.charCodeAt (0)) {
			fu.play ();
		}
		if (keyCode == 'M'.charCodeAt (0)) {
			me.play ();
		}
		if (keyCode == 'K'.charCodeAt (0)) {
			ku.play ();
		}
		if (keyCode == 'R'.charCodeAt (0)) {
			ri.play ();
		}
	}
}
