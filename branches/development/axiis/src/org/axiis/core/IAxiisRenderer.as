package org.axiis.core
{
	import flash.geom.Point;
	
	public interface IAxiisRenderer
	{
		function set label(value:String):void;
		function get label():String;
		
		function set data(value:Object):void;
		function get data():Object;
		
		function set value(value:Object):void;
		function get value():Object;
		
		function set index(value:int):void;
		function get index():int;

	}
}