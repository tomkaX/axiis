package org.axiis.data
{
	import flash.events.Event;

	[Bindable]	
	public class MinAggregator implements IAggregator
	{
		public function MinAggregator()
		{
			super();
		}

		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name = value;
		}
		private var _name:String;
		
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
		}
		private var _dataField:String;
		
		public function aggregate(source:Array):*
		{
			var min:Number = Number.MAX_VALUE;
			for each(var o:Object in source)
			{
				var dataValue:Number;
				if(dataField)
				{
					dataValue = o[dataField];
				}
				else
				{
					dataValue = Number(o);
				}
				min = Math.min(min,dataValue);
			}
			return min;
		}
	}
}