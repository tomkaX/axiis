package org.axiis.core
{
	public interface IRepeaterModifier
	{
		function set targets(value:Array):void;
		function get targets():Array;
		
		function get iteration():Number;
		
		function beginModify(sourceObject:Object):void
		
		function apply():void
		
		function end():void
		
		function applyCachedIteration(iteration:int):void;
	}
}