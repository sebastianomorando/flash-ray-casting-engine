package  
{
	/**
	 * ...
	 * @author Sebastiano Morando
	 */
	public class level 
	{
		
		public var v:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(8);
		
		public function level() 
		{
			v[0] = new <int>[0,0,1,1,1,1,1,0];
			v[1] = new <int>[0,0,1,0,0,0,1,0];
			v[2] = new <int>[0,0,1,0,1,0,1,0];
			v[3] = new <int>[0,0,1,0,1,0,1,0];
			v[4] = new <int>[0,0,1,0,1,0,1,0];
			v[5] = new <int>[1,1,1,0,1,0,1,0];
			v[6] = new <int>[0,0,0,0,0,0,1,0];
			v[7] = new <int>[1,1,1,1,1,0,1,0];
		}
		
	}

}