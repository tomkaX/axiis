package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import org.axiis.DataCanvas;
	
	[Bindable]
	/**
	 * ILayout is an interface that all layouts must implement.
	 */
	public interface ILayout extends IEventDispatcher
	{
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		
		function get emitDataTips():Boolean;
		function set emitDataTips(value:Boolean):void;
		
		function get itemCount():int;

		function get dataTipLabelFunction():Function;
		function set dataTipLabelFunction(value:Function):void;
		
		function get dataTipPositionFunction():Function;
		function set dataTipPositionFunction(value:Function):void;
		
		function get childSprites():Array;
		
		function set parentLayout(value:ILayout):void;
		function get parentLayout():ILayout;
		
		function set bounds(value:Rectangle):void; 
		function get bounds():Rectangle;
		
		function set dataProvider(value:Object):void;
		function get dataProvider():Object;
		
		function set dataField(value:String):void;
		function get dataField():String;
		
		function set labelField(value:String):void;
		function get labelField():String;
		
		function set drawingGeometries(value:Array):void;
		function get drawingGeometries():Array;
		
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
		
		function set referenceRepeater(value:GeometryRepeater):void;
		function get referenceRepeater():GeometryRepeater;
		
		function get currentIndex():int;
		
		function get currentDatum():Object
		
		function get currentValue():Object;
		
		function get currentLabel():String;
		
		function get currentReference():Geometry;
		
		/**
		 * Registers a DisplayObject as the owner of this ILayout.
		 * Throws an error if the ILayout already has an owner.
		 */
		function registerOwner(dataCanvas:DataCanvas):void;
		
		/**
		 * Returns the Sprite associated with this ILayout if owner is
		 * in fact the owner of this ILayout.
		 * 
		 * This can be more secure if we look at the call stack to determine
		 * ownership.
		 */
		function getSprite(owner:DataCanvas):Sprite;
		
		function render(sprite:AxiisSprite = null):void;
	}
}