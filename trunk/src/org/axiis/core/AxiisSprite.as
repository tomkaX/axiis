package org.axiis.core
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.FlexSprite;

	public class AxiisSprite extends FlexSprite
	{
		private var _eventListeners:Array;
		
		private var _layoutSprites:Array=new Array();
		
		private var _drawingSprites:Array=new Array();
		
		public function get layoutSprites():Array {
			return _layoutSprites;
		}
		
		public function get drawingSprites():Array {
			return _drawingSprites;
		}
		
		public function addLayoutSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_layoutSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
		public function addDrawingSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_drawingSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
		override public function AxiisSprite()
		{
			super();
			_eventListeners=new Array();
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			for (var i:int=0;i<_layoutSprites.length;i++) {
				if (child==_layoutSprites[i]) {
					_layoutSprites.splice(i,1);
					continue;
				}
			}
			for (var i:int=0;i<_drawingSprites.length;i++) {
				if (child==_drawingSprites[i]) {
					_drawingSprites.splice(i,1);
					continue;
				}
			}
			super.removeChild(child);
			return child;
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
		
		public var layout:ILayout;
		
		public var bounds:Rectangle;
	}
}