package gameObjects;


//i wanted a few things -data
//also srs moment fuck hxcodec its given me so many headaches. you was good in the past but we moved on bud!
class PsychVideoSprite extends FlxVideoSprite
{
    public static var heldVideos:Array<PsychVideoSprite> = [];

    //these are loading options that are just easier to understand lol
    public static final looping:String = ':input-repeat=65535';
    public static final muted:String = ':no-audio';

    public var onStartCallback:Void->Void = null;
	public var onFormatCallback:Void->Void = null;
	public var onEndCallback:Void->Void = null;

    public var destroyOnUse:Bool = false;

    var _heldVideoPath:String = '';

    public function new(destroyOnUse = true) {
        super();
        heldVideos.push(this);

	autoPause = false;

        this.destroyOnUse = destroyOnUse;
        if (destroyOnUse) bitmap.onEndReached.add(() -> destroy());
    }

    public override function load(location:String, ?options:Array<String>):Bool
    {
        var b:Bool = super.load(location, options);
        if (!b) return b;

        _heldVideoPath = location;

        return b;
    }

    //maybe temp?
    public function addCallback(vidCallBack:String,func:Void->Void) {
        switch (vidCallBack) {
            case 'onEnd':
                if (func != null) bitmap.onEndReached.add(func);
            case 'onStart':
                if (func != null) bitmap.onOpening.add(func);
            case 'onFormat':
                if (func != null) bitmap.onFormatSetup.add(func);
        }
    }

    public override function destroy() {

        if (destroyOnUse && onEndCallback != null) onEndCallback(); 
        
        heldVideos.remove(this);
        super.destroy();
    }

    public function restart(?options:Array<String>) 
    {
        load(_heldVideoPath, options == null ? [] : options);
        play();
    }

    public static function globalPause() {
        for (i in heldVideos) i.pause();
    }

    public static function globalResume() {
        for (i in heldVideos) i.resume();
    }

}


enum abstract VidCallbacks(String) to String from String {
    public var ONEND:String = 'onEnd';
    public var ONSTART:String = 'onStart';
    public var ONFORMAT:String = 'onFormat';
}
