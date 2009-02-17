package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	public interface ILayoutRepeater
	{
		
		function get modifiers():Array;
		function set modifiers(value:Array):void;
		function get geometry():Geometry;
		function set geometry(value:Geometry):void;
		
		function set dataProvider(value:Array):void;
	
		function get currentIteration():int;
		
		function repeat():void;
		
	}
}