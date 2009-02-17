package org.axiis.core
{
	public interface IRepeaterModifier
	{
		function beginModify(sourceObject:Object):void
		function apply():void
		function end():void
		function set targets(value:Array):void;
		function get targets():Array;
		
	//	function get properties():Array;
	//	function set properties(value:Array):void;
		
		function get iteration():Number;
	}
}