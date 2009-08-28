package org.axiis.data
{
	import flash.events.Event;
	import flash.utils.flash_proxy;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.XMLListCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.ObjectProxy;

	use namespace flash_proxy;

	[DefaultProperty("source")]

	public dynamic class AggregatedCollection extends ListCollectionView
	{
		public function AggregatedCollection()
		{
			super();
		}
		
		[Bindable(event="aggregatesChange")]
		/**
		 * TODO Document aggregates
		 */
		public function get aggregates():Array
		{
			return _aggregates;
		}
		public function set aggregates(value:Array):void
		{
			if(value != _aggregates)
			{
				_aggregates = value;
				runAggregations();
				dispatchEvent(new Event("aggregatesChange"));
			}
		}
		private var _aggregates:Array = [];
		
		protected var resultCollection:ArrayCollection = new ArrayCollection();
		
		protected var aggregatedProperties:ObjectProxy = new ObjectProxy();
		
		protected var collection:IList;
		
		public function get source():Object
	    {
	        return collection;
	    }
	
	    /**
	     *  @private
	     */
	    public function set source(value:Object):void
	    {
	        if (collection)
	        {
	            collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
	        }
	
	        if (value is Array)
	        {
	            collection = new ArrayCollection(value as Array);
	        }
	        else if (value is IList)
	        {
	            collection = new ListCollectionView(IList(value));
	        }
	        else if (value is XMLList)
	        {
	            collection = new XMLListCollection(value as XMLList);
	        }
	        else if (value is XML)
	        {
	            var xl:XMLList = new XMLList();
	            xl += value;
	            collection = new XMLListCollection(xl);
	        }
	        else
	        {
	            // convert it to an array containing this one item
	            var tmp:Array = [];
	            if (value != null)
	                tmp.push(value);
	            collection = new ArrayCollection(tmp);
	        }
	        collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);

			list = collection;
			//resultCollection.source = collection.toArray();

	        var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
	        event.kind = CollectionEventKind.RESET;
	        collectionChangeHandler(event);
	        dispatchEvent(event);
	    }
	    
	    protected function collectionChangeHandler(event:Event):void
	    {
	    	//runAggregations();
	    }
	    
	    public function runAggregations():void
	    {
	    	trace()
	    	if(collection == null)
	    		return;
	    	
	    	for each(var aggregate:IAggregator in aggregates)
	    	{
	    		var rawArray:Array = collection.toArray();
	    		var aggregationResult:* = aggregate.aggregate(rawArray);
	    		trace(aggregate)
	    		if(aggregationResult is Array)
	    		{
	    			resultCollection.source = aggregationResult as Array;
	    		}
	    		else
	    		{
	    			trace(aggregate.name)
	    			aggregatedProperties[aggregate.name] = aggregationResult;
	    		}
	    	}
	    }

		override public function get length():int
		{
			return resultCollection.length;
		}
		
		override public function get filterFunction():Function
		{
			return resultCollection.filterFunction;
		}
		
		override public function set filterFunction(value:Function):void
		{
			resultCollection.filterFunction = value;
		}
		
		override public function get sort():Sort
		{
			return resultCollection.sort;
		}
		
		override public function set sort(value:Sort):void
		{
			resultCollection.sort = value;
		}
		
		override public function createCursor():IViewCursor
		{
			return resultCollection.createCursor();
		}
		
		override public function contains(item:Object):Boolean
		{
			return resultCollection.contains(item);
		}
		
		override public function disableAutoUpdate():void
		{
			resultCollection.disableAutoUpdate();
		}
		
		override public function enableAutoUpdate():void
		{
			resultCollection.enableAutoUpdate();
		}
		
		override public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			resultCollection.itemUpdated(item,property,oldValue,newValue);
		}
		
		override public function refresh():Boolean
		{
			return resultCollection.refresh();
		}
		
		override public function toArray():Array
		{
			if(resultCollection)
				return resultCollection.toArray();
			else
				return collection.toArray();
		}
		
		/**
	     *  @private
	     *  Attempts to call getItemAt(), converting the property name into an int.
	     */
	    override flash_proxy function getProperty(name:*):*
	    {
	    	return aggregatedProperties.getProperty(name);
	    }
	    
	    /**
	     *  @private
	     *  Attempts to call setItemAt(), converting the property name into an int.
	     */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			aggregatedProperties.setProperty(name, value);
	    }
	    
	    /**
	     *  @private
	     *  This is an internal function.
	     *  The VM will call this method for code like <code>"foo" in bar</code>
	     *  
	     *  @param name The property name that should be tested for existence.
	     */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return aggregatedProperties.hasOwnProperty(name);	
	    }
	
	    /**
	     *  @private
	     */
	    override flash_proxy function nextNameIndex(index:int):int
	    {
	        return resultCollection.nextNameIndex(index);
	    }
	    
	    /**
	     *  @private
	     */
	    override flash_proxy function nextName(index:int):String
	    {
	        return resultCollection.toString();
	    }
	    
	    /**
	     *  @private
	     */
	    override flash_proxy function nextValue(index:int):*
	    {
	        return resultCollection.getItemAt(index - 1);
	    }
	
	    /**
	     *  @private
	     *  Any methods that can't be found on this class shouldn't be called,
	     *  so return null
	     */
	    override flash_proxy function callProperty(name:*, ... rest):*
	    {
	        return null;
	    }
	}
}