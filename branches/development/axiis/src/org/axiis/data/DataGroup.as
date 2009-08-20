package org.axiis.data
{
	import mx.collections.ArrayCollection;
	
	public class DataGroup extends ArrayCollection
	{
		public function DataGroup()
		{
		}
		
		public var name:String;
		public var sourceData:Object;
		public var groupedData:DataGroup;
		public var sums:Object=new Object(); 


	}
}