package org.axiis.core
{
	import mx.core.FlexSprite;

	public class AxiisSprite extends FlexSprite
	{
		private var _eventListeners:Array;
		
		override public function AxiisSprite()
		{
			super();
			_eventListeners=new Array();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			var obj:Object=new Object();
			obj.type=type;
			obj.listener=listener;
			obj.useCapture=useCapture;
			
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			for (var i:int=0;i<_eventListeners.length;i++) {
				if (_eventListeners[i].type==type && _eventListeners.listener==listener) {
					_eventListeners.splice(i,1);
					i=_eventListeners.length;
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function dispose():void {
			graphics.clear();
			for each (var obj:Object in _eventListeners) {
				super.removeEventListener(obj.type, obj.listener,obj.useCapture);
			}
		}
		
		public var data:Object;
	}
}