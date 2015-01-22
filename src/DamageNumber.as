package  
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public final class DamageNumber extends Sprite
	{
		//{ Vars
		public var myGrid:Grid;
		
		public var txt:TextField;
		public var format:TextFormat;
		
		public var target:Enemy;
		public var damage:Number;
		public var color:uint;
		
		public var time:int;
		//}
		
		public function DamageNumber(grid:Grid, en:Enemy, num:Number, col:uint, crit:Boolean = false) {
			myGrid = grid;
			
			format = new TextFormat(new MainFontFNT().fontName, myGrid.getScale() * 14, "center");
			
			target = en;
			damage = num;
			color = col;
			time = 0;
			
			if (crit){
				format.size = grid.getScale() * 16;
			}
			
			txt = new TextField();
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.embedFonts = true;
			txt.antiAliasType = "NORMAL";
			txt.defaultTextFormat = format;
			txt.text = String(damage);
			txt.textColor = color;
			addChild(txt);
			
			x = target.x - (target.gfx.width / 2);
			y = target.y - target.gfx.height;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function tick():void {
			time++;
			y-= 2;
			alpha -= 0.05;
		}
		
	}

}