package org.axiis.events
{
	import flash.events.Event;
	
	import org.axiis.core.AxiisSprite;
	
	public class LayoutItemEvent extends Event
	{
		public function get item():AxiisSprite {
			return _item;
		}
		
		private var _item:AxiisSprite;
		
		public function get sourceEvent():Event {
			return _sourceEvent;
		}
		
		private var _sourceEvent:Event;
		
		public function LayoutItemEvent(type:String, item:AxiisSprite, e:Event):void
		{
			
			super(type,false,true);
			_item=item;
			_sourceEvent=e;
		}

	}
}