package org.axiis.events
{
	import flash.events.Event;
	
	import org.axiis.core.AxiisSprite;
	
	public class ItemClickEvent extends Event
	{
		public function get item():AxiisSprite {
			return _item;
		}
		
		private var _item:AxiisSprite;
		
		public function ItemClickEvent(item:AxiisSprite):void
		{
			
			super("itemClick",false,true);
			_item=item;
		}

	}
}