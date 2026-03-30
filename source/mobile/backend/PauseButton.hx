package mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.utils.Assets; // Melhor para iOS
import flixel.graphics.FlxGraphic;

/**
 * PauseButton - Versão iOS 
 * Ajustado para Safe Area (Notch) e Hitbox Expandida.
 */
class PauseButton extends FlxSprite
{
	public var onClick:Void->Void;

	public function new(x:Float = 0, y:Float = 0, ?onClick:Void->Void)
	{
		var posX:Float = (x == 0) ? FlxG.width - 150 : x; 
		var posY:Float = (y == 0) ? 35 : y;

		super(posX, posY);

		#if mobile
		var path:String = 'assets/mobile/pauseButton.png';
		
		try {
			if (Assets.exists(path)) {
				loadGraphic(Assets.getBitmapData(path));
			} else {
				loadGraphic(Assets.getBitmapData('mobile/pauseButton.png'));
			}
		} catch(e:Dynamic) {
			trace("Error loading pause button image: " + e);
		}

		antialiasing = true;
		scrollFactor.set();
		alpha = 0.7;
		
		scale.set(0.8, 0.8);
		updateHitbox(); 

		var visualW:Float = width;
		var visualH:Float = height;

		width = 140; 
		height = 140;

		centerOffsets();

		this.x = posX - (width - visualW) / 2;
		this.y = posY - (height - visualH) / 2;

		this.onClick = onClick;
		#else
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

	public static function create(camera:FlxCamera, ?onClick:Void->Void):PauseButton
	{
		var button = new PauseButton(0, 0, onClick);
		button.cameras = [camera];
		return button;
	}
}