package  
{
	/**
	 * ...
	 * @author Sebastiano Morando
	 */
	public class ray 
	{
		public static var distance:Number = 0;
		public static var floor_dist:Number = 0;
		public static var x:int = 0;
		public static var y:int = 0;
		public static var hor:Boolean; //horizontal or vertical
		public static var facingUp:Boolean = true;
		public static var facingLeft:Boolean = true;
		public static var collY:int = 0;
		public static var collX:int = 0;
		
		public static function cast(alpha:Number):void
		{
			distance = 0;
			
			//evaluate the direction of the ray
			if ((alpha > 90) && (alpha <= 270)) facingLeft = false;  
			if ((alpha > 270) && (alpha <= 360)) facingLeft = true;
			if ( (alpha >= 0) && (alpha <= 90)) facingLeft = true; 
			if ((alpha >= 180) && (alpha <= 360)) facingUp = true; 
			if ((alpha >= 0) && (alpha < 180)) facingUp = false;
			
			playState.instance.graphics.beginFill(0xFFFFFF);
			playState.instance.graphics.moveTo(playState.instance.player.x + 8, playState.instance.player.y);
		
			var px:int = playState.instance.player.x + 8;
			var py:int = playState.instance.player.y;
			
			//find the first horizontal intersection
			var hy:int = Math.floor(py / 64) * 64 + ((facingUp)?-1:64);
			var hx:int = px + (py - hy)/ Math.tan(alpha * Math.PI / 180);
			
			var Xa:int = ((facingUp)?1:-1)*64 / Math.tan(alpha * Math.PI / 180);
			var Ya:int = ((facingUp)?-64:64);
			
			//CHECK HORIZONTAL INTERSECTIONS
			while ((hx < 512 && hx > 0) && (hy > 0 && hy < 512) && (playState.instance.actual_level.v[Math.floor(hy / 64)][Math.floor(hx / 64)] != 1)  )
			{
			hx += Xa;
			hy += Ya;
			}
			
			//find the first vertical intersection
			var vx:int = Math.floor(px / 64) * 64 +((facingLeft)?-1:64) ;
			var vy:int = py + (px - vx) *  Math.tan(alpha * Math.PI / 180);
			Xa = ((facingLeft)?-64:64);
			Ya = ((facingLeft)?1:-1)*64 * Math.tan(alpha * Math.PI / 180);
			//CHECK VERTICAL INTERSECTIONS
			while ((vx < 512 && vx > 0) && (vy > 0 && vy < 512) && (playState.instance.actual_level.v[Math.floor(vy / 64)][Math.floor(vx / 64)] != 1)  )
			{
			vx += Xa;
			vy += Ya;
			}
			//CALCULATE DISTANCES
			var hd:int = Math.sqrt(Math.pow(px - hx, 2) +  Math.pow(py - hy, 2));//Math.abs(px - hx) / Math.cos(alpha * Math.PI / 180);
			var vd:int = Math.sqrt(Math.pow(px - vx, 2) +  Math.pow(py - vy, 2));//int(Math.abs(px - vx) / Math.cos(alpha * Math.PI / 180));
			
			//DRAW RAY
			//graphics.moveTo(px, py);
			//if (alpha >= 270)
			//{
				if (hd <= vd){
					playState.instance.graphics.lineTo(hx, hy);
					distance = hd;
					hor = true;
					x = hx;
					y = hy;
					}
				else {
					playState.instance.graphics.lineTo(vx, vy);
					distance = vd;
					hor = false;
					x = vx;
					y = vy;
					}
			//} else {
				//if (hd > vd) {
					//graphics.lineTo(hx, hy);
					//distance = hd;
				//}
				//else {
					//graphics.lineTo(vx, vy);
					//distance = vd;
					//}
	
		}
		
		public static function floorCast(alpha:Number):void
		{
			alpha = alpha * Math.PI / 180;
			floor_dist = Math.sqrt(Math.pow(512 - (32 / Math.tan(alpha)),2) + 1024 );
		}
		
	}

}