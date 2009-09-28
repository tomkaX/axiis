package org.axiis.experimental.data
{
	public interface IAggregator
	{
		function get name():String;
		function set name(value:String):void;
		
		function get dataField():String;
		function set dataField(value:String):void;
		
		function aggregate(source:Array):*;
	}
}