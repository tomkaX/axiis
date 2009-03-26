package org.axiis.events
{
	import flash.events.Event;
	
	import org.axiis.core.ILayout;

	public class StateChangeEvent extends Event
	{
		public static const STATE_CHANGE:String = "org.axiis.events.StateChangeEvent.STATE_CHANGE";
		
		public var layoutChain:Array = new  Array();
		
		public function StateChangeEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function addLayoutToChain(layout:ILayout):void
		{
			layoutChain.push(layout);
		}
		
		/*override public function clone():Event
		{
			var evt:StateChangeEvent = new StateChangeEvent(type,bubbles,cancelable);
			evt.chain = chain;
			return evt;
		}*/  
	}
}