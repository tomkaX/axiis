///////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2009 Team Axiis
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////

package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import org.axiis.DataCanvas;
	import org.axiis.layouts.utils.GeometryRepeater;
	
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
		
		function get rendering():Boolean;
	}
}