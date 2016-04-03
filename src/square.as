package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Sebastiano Morando
	 */
	public class square extends Sprite
	{
		public var right:Boolean = false;
		public var left:Boolean = false;
		public var up:Boolean = false;
		public var down:Boolean = false;
		
		public function square() //da rinominare in camera
		{
			graphics.beginFill(0xAAAAAA);
			graphics.drawRect(0,0,16,16);
			graphics.endFill();
			
			x = 400;
			y = 400;
			
			addEventListener(MouseEvent.MOUSE_DOWN, function ():void { startDrag(); } );
			addEventListener(MouseEvent.MOUSE_UP, function ():void { stopDrag(); } ); 
		}
		
	}

}