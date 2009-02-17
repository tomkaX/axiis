package org.axiis.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	public interface ILayout extends IEventDispatcher
	{
		function set dataProvider(value:Object):void;
		function get dataProvider():Object;
		
		function set dataField(value:String):void;
		function get dataField():String;
		
		function set geometries(value:Array):void;
		function get geometries():Array;
		
		function set layouts(value:Array):void;
		function get layouts():Array;
		
		function set x(value:Number):void;
		function get x():Number;
		
		function set y(value:Number):void;
		function get y():Number;
		
		function set width(value:Number):void;
		function get width():Number;
		
		function set height(value:Number):void;
		function get height():Number;
		
		function set scale(value:String):void
		function get scale():String;
		
		function get currentIndex():int;
		
		function get currentItem():Sprite;
		
		function get currentDatum():Object
		
		function set selectedIndex(value:int):void;
		function get selectedIndex():int;
		
		function set selectedItem(value:Sprite):void;
		function get selectedItem():Sprite;
		
		function set selectedDatum(value:Object):void;
		function get selectedDatum():Object;
		
		/**
		 * Registers a DisplayObject as the owner of this ILayout.
		 * Throws an error if the ILayout already has an owner.
		 */
		function registerOwner(displayObject:DisplayObject):void;
		
		
		// hasOwner??
		
		/**
		 * Returns the Sprite associated with this ILayout if owner is
		 * in fact the owner of this ILayout.
		 * 
		 * This can be more secure if we look at the call stack to determine
		 * ownership.
		 */
		function getSprite(owner:DisplayObject):Sprite;
		
		function initialize():void;
		
		function initializeGeometry():void;
		
		function measure():void;
		
		function render():void;
		
		function renderDatum(datum:Object,targetSprite:Sprite,rectange:Rectangle):void; 
	}
}