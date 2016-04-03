package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Sebastiano Morando
	 */
	public class playState extends Sprite
	{
		
		[Embed(source = "../img/misa_stonebrick_red.png")]
		private var wall_texture_class:Class;
		public var wall_texture:Bitmap = new wall_texture_class();
		
		[Embed(source = "../img/floortiles.png")]
		private var floor_texture_class:Class;
		public var floor_texture:Bitmap = new floor_texture_class();
		
		public var player:square = new square();
		
		public var actual_level:level = new level();
		
		public var projection_data:BitmapData = new BitmapData(320, 200, false, 0x000000);
		public var projection:Bitmap = new Bitmap(projection_data);
		
		private var angle:int = 240;
		
		public static var instance:playState;
		
		public var stat:statBox = new statBox();
		
		private var now:uint;
		private var last:uint;
		
		
		public function playState() 
		{
			instance = this;
			
			drawGrid();
			drawLevel();
			addChild(player);
			
			addChild(projection);
			projection.x = 520;
			projection.y = 20;
			
			//addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ADDED_TO_STAGE, stage_added);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			//Statistics text box
			addChild(stat);
			
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ENTER_FRAME, debugUpdate);
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			addEventListener(Event.ENTER_FRAME, update);
			removeEventListener(Event.ENTER_FRAME, debugUpdate);
		}
		
		private function stage_added(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			switch(e.keyCode) {
				case 87:
					player.up = true;
					break;
				case 83:
					player.down = true;
					break;
				case 65:
					player.left = true;
					break;
				case 68:
					player.right = true;
					break;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode) {
				case 87:
					player.up = false;
					break;
				case 83:
					player.down = false;
					break;
				case 65:
					player.left = false;
					break;
				case 68:
					player.right = false;
					break;
			}
		}
		
		private function debugUpdate(e:Event):void 
		{
			graphics.clear();
			projection_data.fillRect(new Rectangle(0, 0, 320, 200), 0x000000);
			drawGrid();
			drawLevel();
			var angle:Number = Math.atan2((mouseY - player.y), -(mouseX - player.x)) * 180 / Math.PI;
			if (angle < 0 ) angle = 360 + angle;
			ray.cast(angle);
			var s:String = "";
			s = "angle: "+angle;
			s += "\nray x:" + ray.x + " y:" + ray.y;
			stat.text = s;
			
		}
		
		private function update(e:Event):void
		{
			last = getTimer();
			update_graphic();
			update_move();
			update_stats();
		}
		
		private function update_stats():void
		{
			var s:String = "";
			s += "angle range: " + angle + "-" + (angle + 60);
			now = getTimer();
			var delta:uint = now - last;
			s += "\nrendering time: " + delta+" ms";
			stat.text = s;
		}
		
		private function update_graphic():void
		{
			graphics.clear();
			projection_data.fillRect(new Rectangle(0, 0, 320, 200), 0x000000);
			drawGrid();
			drawLevel();
			//draw_floor();
			draw_walls();
			
		}
		
		private function draw_walls():void
		{
			var ix:int = 0;
			for (var i:Number = angle; i < angle+60; i = i + .1875)//.1875
			{
				if (i <= 360)
					ray.cast(i);
				else
					ray.cast(i % 360);
				drawSlice(ix, ray.distance);
				ix++;
				//trace(ix);
				
			}
		}
		
		private function draw_floor():void
		{
			var iy:int = 0;
			for (var i:Number = 0; i < 60; i = i + .6)
			{
				ray.floorCast(i);
				draw_floor_slice(iy, ray.floor_dist);
				iy++;
			}
		}
		
		private function draw_floor_slice(slice:int, dist:Number):void
		{
			for (var ix:int = 0; ix < 160; ix++)
			{
				projection_data.setPixel32(ix + 160, 100 + slice, floor_texture.bitmapData.getPixel(ix * (1 / (slice * 0.05)), slice % 64));
				projection_data.setPixel32(160-ix, 100 + slice, floor_texture.bitmapData.getPixel(ix * (1 / (slice * 0.05)), slice % 64));
			}
			
		}
		
		private function update_move():void
		{
			if (player.up){
				player.y += 10 * Math.sin((angle+30)* Math.PI / 180);
				player.x -= 10 * Math.cos((angle+30) * Math.PI / 180);
				}
			if (player.down) {
				player.y -= 10 * Math.sin((angle+30)* Math.PI / 180);
				player.x += 10 * Math.cos((angle+30)* Math.PI / 180);
				}
			if (player.right)
				angle-=5;
			if (player.left)
				angle += 5;
				
			if (angle < 0) angle = 360;
			if (angle > 360) angle = 0;
		}
		
		private function drawSlice(slice:Number,dist:Number):void
		{
			//trace(dist);
			var height:Number = int((64 / dist) * 277);
			var fy:int = 100 - (height / 2);
			var i:int = 0;
			for (var iy:int = fy; iy < fy + height; iy++)
			{	
				i++;
				//if (fy > 0)
				//{
					if (ray.hor)
						projection_data.setPixel32(320 - slice, iy, wall_texture.bitmapData.getPixel(ray.x % 64, i / (height / 64)));
					else
						projection_data.setPixel32(320 - slice, iy, wall_texture.bitmapData.getPixel(ray.y % 64, i / (height / 64)));
					//projection_data.setPixel(320 - slice, iy, (ray.hor?0x004080:0x000040));
				//}
				if ((iy-fy) > 320) break;
			}
		}
		
		private function testAngle(alpha:Number):void
		{
			graphics.beginFill(0xFFFFFF);
			
			var px:int = player.x + 8;
			var py:int = player.y;
			
			graphics.moveTo(px, py);
			graphics.lineTo(px + 64 * (Math.cos(alpha * Math.PI / 180)), py + 64 * (Math.sin(alpha * Math.PI / 180)));
			
		}
		
		private function drawGrid():void
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,512,512);
			graphics.endFill();
			
			var ix:int = 0;
			var iy:int = 0;
			
			graphics.lineStyle(1, 0xAAAAAA);
			
			
			for (iy = 0; iy <= 512; iy += 64)
					{
						graphics.moveTo(0, iy); 
						graphics.lineTo(512, iy);
					}
						
			for (ix = 0; ix <= 512; ix += 64)
			{
				graphics.moveTo(ix, 0);
				graphics.lineTo(ix,512);
			}
				
		}
		
		private function drawLevel():void
		{
			for (var ix:int = 0; ix < 8; ix++)
			{
				for (var iy:int = 0; iy < 8; iy++)
				{
					if (actual_level.v[iy][ix] == 1)
					{
						graphics.beginFill(0x004080);
						graphics.drawRect(ix * 64, iy * 64, 64, 64);
						graphics.endFill();
					}
				}
			}
		}
		
	}

}