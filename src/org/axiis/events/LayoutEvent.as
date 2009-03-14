package org.axiis.events
{
	import flash.events.Event;
	
	import org.axiis.core.ILayout;

	public class LayoutEvent extends Event
	{
		public static const INVALIDATE:String = "org.axiis.events.LayoutEvent.INVALIDATE";
		
		public static const STATE_CHANGE:String = "org.axiis.events.StateEvent.STATE_CHANGE";
		
		public var layout:ILayout;
		
		public function LayoutEvent(type:String, layout:ILayout, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.layout = layout;
		}
		
	}
}