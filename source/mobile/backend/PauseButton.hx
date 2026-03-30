package mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

/**
 * Pause? PAUSE!!
 *
 * @author StarNova (Cream.BR)
 */
class PauseButton extends FlxSprite
{
	public var onClick:Void->Void;

	public function new(x:Float = 0, y:Float = 0, ?onClick:Void->Void)
	{
		var posX:Float = (x == 0) ? FlxG.width - 130 : x;
		var posY:Float = (y == 0) ? 25 : y;

		super(posX, posY);

		#if mobile
		var bitmap:BitmapData = null;
		var path:String = 'assets/mobile/pauseButton.png';

		try
		{
			bitmap = BitmapData.fromFile(path);
		}
		catch(e:Dynamic)
		{
			trace("Error loading pause button image: " + e);
		}

		if (bitmap != null)
		{
			loadGraphic(FlxGraphic.fromBitmapData(bitmap));
		}

		antialiasing = true;
		scrollFactor.set();
		alpha = 0.7;
		scale.set(0.8, 0.8);
		updateHitbox();

		var padding:Float = 50; 

		this.width += padding * 2;
		this.height += padding * 2;
		
		this.offset.set(-padding, -padding);

		this.x -= padding;
		this.y -= padding;

		this.onClick = onClick;
		#else
		trace('PauseButton only Avaliable for Mobile Targets!');
		visible = false;
		active = false;
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if mobile
		if (!visible || !active || onClick == null)
			return;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed && touch.overlaps(this, camera))
			{
				onClick();
				break;
			}
		}
		#end
	}

	/**
	 * A function to create
	 */
	public static function create(camera:FlxCamera, ?onClick:Void->Void):PauseButton
	{
		var button = new PauseButton(0, 0, onClick);
		button.cameras = [camera];
		return button;
	}
}