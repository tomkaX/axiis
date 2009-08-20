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
	import flash.geom.Point;
	
	import mx.core.IFactory;
	
	import org.axiis.DataCanvas;
	import org.axiis.layouts.utils.GeometryRepeater;
	import org.axiis.managers.IDataTipManager;
	
	[Bindable]
	/**
	 * ILayout is an interface that all layouts must implement.
	 */
	public interface ILayout extends IEventDispatcher
	{
		/**
		 * Whether or not this layout is currently in a render cycle. Rendering
		 * can take place over several frames. By watching this property you
		 * can take an appropriate action handle artifacts for multiframe
		 * rendering, such as hiding the layout entirely.
		 */
		function get rendering():Boolean;
		
		/**
		 * Whether or not this layout is visible. Layouts that are not visible
		 * will return from their render methods immediately after they are
		 * called without making any changes to the display list.
		 */
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		/**
		 * A flag that indicates to DataCanvas that it should listen for mouse
		 * events that signal the need to create a data tip.
		 */
		function get emitDataTips():Boolean;
		function set emitDataTips(value:Boolean):void;
		
		/**
		 * A method used to determine the text that appears in the data tip for
		 * an item rendered by this layout.
		 * 
		 * <p>
		 * This method takes one argument, the item to determine the label for,
		 * and returns a String, the text to show in the data tip.
		 * </p>
		 */
		function get dataTipLabelFunction():Function;
		function set dataTipLabelFunction(value:Function):void;
		
		/**
		 * A method that determines the desired position for a data tip.
		 * 
		 * <p>
		 * This function takes two arguments: The AxiisSprite to display the
		 * data tip for and data tip itself, which is an IToolTip. It should
		 * return a Point that represents the ideal position for the data tip.
		 * </p>
		 * 
		 * <p>
		 * This function is called by DataCanvas when placing data tips. The
		 * tip will be placed at the point specified by the function unless it
		 * overlaps other data tips.
		 * </p>
		 */
		function get dataTipPositionFunction():Function;
		function set dataTipPositionFunction(value:Function):void;
		
		/**
		 * The number of items in the dataProvider.
		 */
		function get itemCount():int;

		// TOOD Determine if we really need to expose this property. Currently DataCanvas only uses it in one place.
		/**
		 * The AxiisSprites this layout has created to render each item in its dataProvider.
		 */
		function get childSprites():Array;
		
		// TODO It would be great if we could somehow get rid of the setter for this parentLayout.
		/**
		 * A reference to the layout that contains this layout.
		 */
		function get parentLayout():ILayout;
		function set parentLayout(value:ILayout):void;
		
		/**
		 * An Array, ArrayCollection, or Object containing the data this layout
		 * should render.
		 * 
		 * <p>
		 * If this property is Array or ArrayCollection the layout should render
		 * each item. If this property is an Object, it should use an array of
		 * the object's properties as they are exposed in a for..each loop.
		 * </p> 
		 */
		function get dataProvider():Object;
		function set dataProvider(value:Object):void;
		
		// TODO this doesn't feel like it is necessary on the interface level
		/**
		 * The property within each item in the dataProvider that contains the
		 * field used to determine the value of the item.
		 * 
		 * This can also be a Function call that dynamically returns the value for each iteration
		 */
		function get dataField():Object;
		function set dataField(value:Object):void;
		
		// TODO this doesn't feel like it is necessary on the interface level
		/**
		 * The property within each item in the dataProvider that contains the
		 * field used to determine the label for the item. 
		 */
		function get labelField():String;
		function set labelField(value:String):void;
		
		// TODO If we do plan on supporting FXG or UIComponents there is no reason this property needs to be at the interface level
		/**
		 * An array of geometries that should be drawn for each item in the data
		 * provider. You can modify these items by using GeometryRepeaters
		 * and PropertyModifiers.
		 * 
		 * @see GeometryRepeater
		 * @see PropertyModifier
		 */
		function get drawingGeometries():Array;
		function set drawingGeometries(value:Array):void;
		
		/**
		 * The layouts that should be displayed within this layout. 
		 */
		function get layouts():Array;
		function set layouts(value:Array):void;
		
		/**
		 * The horizontal position of the top left corner of this layout within
		 * its parent.
		 */
		function get x():Number;
		function set x(value:Number):void;
		
		/**
		 * The vertical position of the top left corner of this layout within
		 * its parent.
		 */
		function get y():Number;
		function set y(value:Number):void;
		
		// TODO It is possible to draw outside the bounds of the layout. Perhaps an optional clipping mask is in order
		/**
		 * The width of the layout.
		 */
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * The height of the layout.
		 */
		function get height():Number;
		function set height(value:Number):void;
		
		// TODO Determine if this needs to be in the interface
		/**
		 * A GeometryRepeater that will be applied to the drawingGeometries once
		 * for each item in the dataProvider.
		 */
		function get referenceRepeater():GeometryRepeater;
		function set referenceRepeater(value:GeometryRepeater):void;
		
		/**
		 * The index of the item in the dataProvider that the layout is
		 * currently rendering.
		 */
		function get currentIndex():int;
		
		/**
		 * The item in the dataProvider that the layout is currently rendering.
		 */
		function get currentDatum():Object
		
		/**
		 * The value of the item in the dataProvider that the layout is
		 * currently rendering, as determined by taking currentDatum[dataField],
		 * if a dataField is defined.
		 */
		function get currentValue():Object;
		
		/**
		 * The label of the item in the dataProvider that the layout is
		 * currently rendering, as determine by taking currentDatum[labelField],
		 * if a labelField is defined.
		 */
		function get currentLabel():String;
		
		/**
		 * The geometry that is being used to render the current data item as it
		 * appears after the necessary iterations of the referenceRepeater have
		 * been executed. 
		 */
		function get currentReference():Geometry;
		
		// TOOD This method and getSprite make calling render awkward (introduces the need for an optional parameter). Can DataCanvas create AxiisSprites to feed to the layouts the way it does with the foregrounds and backgrounds?
		/**
		 * Registers a DisplayObject as the owner of this ILayout.
		 * Throws an error if the ILayout already has an owner.
		 */
		function registerOwner(dataCanvas:DataCanvas):void;
		
		// TODO this should return an AxiisSprite
		/**
		 * Returns the Sprite associated with this ILayout if owner is
		 * in fact the owner of this ILayout.
		 */
		function getSprite(owner:DataCanvas):Sprite;
		
		/**
		 * Draws this layout to the specified AxiisSprite.
		 * 
		 * <p>
		 * If no sprite is provided this layout will use the last AxiisSprite
		 * it rendered to, if such an AxiisSprite exists. Otherwise this returns
		 * immediately.
		 * </p> 
		 * 
		 * @param sprite The AxiisSprite this layout should render to.
		 */
		function render(sprite:AxiisSprite = null):void;
		
		function set dataTipAnchorPoint(value:Point):void;
		function get dataTipAnchorPoint():Point;
		function set dataTipContentClass(value:IFactory):void;
		function get dataTipContentClass():IFactory
		
		function set dataTipManager(value:IDataTipManager):void;
		function get dataTipManager():IDataTipManager;
		
		function get states():Array;
	}
}