package org.axiis.experimental.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class GroupingAggregator extends EventDispatcher implements IAggregator
	{
		public function GroupingAggregator()
		{
			super();
		}

		[Bindable(event="nameChange")]
		/**
		 * TODO Document name
		 */
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			if(value != _name)
			{
				_name = value;
				dispatchEvent(new Event("nameChange"));
			}
		}
		private var _name:String;
		
		[Bindable(event="dataFieldChange")]
		/**
		 * TODO Document dataField
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			if(value != _dataField)
			{
				_dataField = value;
				dispatchEvent(new Event("dataFieldChange"));
			}
		}
		private var _dataField:String;
		
		public function aggregate(source:Array):*
		{
			var groupNames:Dictionary = new Dictionary();			
			for each(var o:Object in source)
			{
				var dataValue:* = dataField ? o[dataField] : o;
				if(!groupNames[dataValue])
					groupNames[dataValue] = [];
				groupNames[dataValue].push(o);
			}
			
			var groups:Array = [];
			for(var groupName:String in groupNames)
			{
				var group:Object = new Object();
				if(dataField)
					group[dataField] = groupName;
				else
					group["group"] = groupName;
				group.contents = groupNames[groupName];
				groups.push(group);
			}
			return groups;
		}
	}
}