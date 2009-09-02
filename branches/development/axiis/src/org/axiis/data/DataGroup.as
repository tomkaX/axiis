package org.axiis.data
{
	import mx.collections.ArrayCollection;
	
	public class DataGroup extends ArrayCollection
	{
		public function DataGroup()
		{
		}
		
		public var name:String;
		public var groupName:String;
		public var sourceData:Object;
		public var groupedData:DataGroup;
		public var parent:Object;
		public var sums:Object=new Object(); 


	}
}