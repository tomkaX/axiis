package org.axiis.states
{
	import com.degrafa.geometry.Geometry;
	
	public class State implements IState
	{

		public function State()
		{
		}
		
		public var targets:Array=new Array();
		public var properties:Array=new Array();
		public var values:Array=new Array();
		public var enterStateEvent:String;
		public var exitStateEvent:String;
		
		private var propertyValues:Array=new Array();

		public function apply():void {
			if (targets.length!=properties.length) return;
			propertyValues=new Array();
			
			for (var i:int=0;i<targets.length;i++) {
				var obj:Object=targets[i];
				propertyValues.push(obj[properties[i]]);
				obj[properties[i]]=values[i];
				//trace(" applying " + properties[i] + " = " + values[i]);
			}
			
		}
		
		public function remove():void {
			if (targets.length!=properties.length || properties.length!=propertyValues.length) return;
			for (var i:int=0;i<targets.length;i++) {
				var obj:Object=targets[i];
				if (propertyValues[i])
					obj[properties[i]]=propertyValues[i];
			}
			
		}
	}
}