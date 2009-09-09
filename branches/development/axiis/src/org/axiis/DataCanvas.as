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

package org.axiis
{
	import com.degrafa.IGeometryComposition;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.IFactory;
	
	import org.axiis.core.AbstractLayout;
	import org.axiis.core.AxiisSprite;
	import org.axiis.events.LayoutItemEvent;
	import org.axiis.managers.IDataTipManager;
	import org.axiis.ui.DataTip2;
	
	/**
	 * DataCanvas manages the placement and the rendering of layouts.
	 */
	public class DataCanvas extends Canvas
	{
		[Bindable]
		/**
		 * A placeholder for fills. Modifying this property has no
		 * effect on the rendering of the DataCanvas.
		 */
		public var fills:Array = [];
		
		[Bindable]
		/**
		 * A placeholder for strokes. Modifying this property has no
		 * effect on the rendering of the DataCanvas.
		 */
		public var strokes:Array = [];
		
		[Bindable]
		/**
		 * A placeholder for palettes. Modifying this property has no
		 * effect on the rendering of the DataCanvas.
		 */
		public var palettes:Array = [];
		
		/**
		 * Constructor.
		 */
		public function DataCanvas()
		{
			super();
		}
		
		//TODO Do we need this on the DataCanvas level
		/**
		 * @private
		 */
		public var labelFunction:Function;
		
		//TODO Do we need this on the DataCanvas level
		/**
		 * @private
		 */
		public var dataFunction:Function;
		
		/**
		 * Whether or not data tips should be shown when rolling the mouse over
		 * items in the DataCanvas's layouts
		 */
		public var showDataTips:Boolean = true;
		
		// TODO This is currently unused
		/**
		 * @private
		 */
		public var toolTipClass:IFactory;
		
		/**
		 * @private
		 */
		public var hitRadius:Number = 0;
		
		private var toolTips:Array = [];
		
		// TODO This isn't doing anything.  We should cut it.
		[Bindable(event="dataProviderChange")]
		/**
		 * A placeholder for data used by layouts managed by this DataCanvas.
		 * Setting this value re-renders the layouts.
		 */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				invalidateDisplayList();
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		private var _dataProvider:Object;
		
		/**
		 * An Array of ILayouts that this DataCanvas should render. Layouts
		 * appearing later in the array will render on top of earlier layouts.
		 */
		public var layouts:Array;
		
		/**
		 * An array of geometries that should be rendered behind the layouts.
		 */
		public var backgroundGeometries:Array;
		
		/**
		 * An array of geometries that should be rendered in front of the
		 * layouts.
		 */
		public var foregroundGeometries:Array;
		
		private var invalidatedLayouts:Array = [];
		
		private var _backgroundSprites:Array = [];
		
		private var _foregroundSprites:Array = [];
		
		private var _background:AxiisSprite;
		
		private var _foreground:AxiisSprite;
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_background=new AxiisSprite();
			this.rawChildren.addChild(_background);

			for each(var layout:AbstractLayout in layouts)
			{
				layout.registerOwner(this);
				var sprite:Sprite = layout.getSprite(this);
				this.rawChildren.addChild(sprite);
				
				layout.addEventListener("layoutInvalidate",handleLayoutInvalidate);
				layout.addEventListener("itemDataTip",onItemDataTip);

			
				invalidatedLayouts.push(layout);
			}
			
			_foreground=new AxiisSprite();
			this.rawChildren.addChild(_foreground);
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			var s:AxiisSprite;
			var i:int;
			if (backgroundGeometries && _backgroundSprites.length < backgroundGeometries.length) {
				for (i = _backgroundSprites.length-1; i<backgroundGeometries.length; i++) {
					s=new AxiisSprite();
					_backgroundSprites.push(s);
					_background.addChild(s);
				}
			}
			
			if (foregroundGeometries && _foregroundSprites.length < foregroundGeometries.length ) {
				for (i=_foregroundSprites.length-1; i<foregroundGeometries.length; i++) {
					s=new AxiisSprite();
					_foregroundSprites.push(s);
					_foreground.addChild(s);
				}
			}
		}
		
		private var _invalidated:Boolean=false;
		
		/**
		 * @private
		 */
		override public function invalidateDisplayList():void
		{
			if (!_invalidated)
				invalidateAllLayouts();
			
			_invalidated = true;
		} 
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
	
			//Render layouts first, as they may autoadjust Scales, etc that the background/foreground rely upon
			while(invalidatedLayouts.length > 0)
			{
				var layout:AbstractLayout = AbstractLayout(invalidatedLayouts.pop());
				layout.render();
			}
			
			
			_background.graphics.clear();
			
			var i:int=0;
			for each (var bg:Object in backgroundGeometries) {
				_backgroundSprites[i].graphics.clear();
				if (bg is AbstractLayout) {
					AbstractLayout(bg).render(_backgroundSprites[i])
				}
				else if (bg is IGeometryComposition) {
					bg.preDraw();
					bg.draw(_backgroundSprites[i].graphics,bg.bounds);
				}
				i++;
			}
			
			
			i=0;
			_foreground.graphics.clear();
			for each (var fg:Object in foregroundGeometries) {
				_foregroundSprites[i].graphics.clear();
				if (fg is AbstractLayout) {
					AbstractLayout(fg).render(_foregroundSprites[i])
				}
				else if (fg is IGeometryComposition) {
					fg.preDraw();
					fg.draw(_foregroundSprites[i].graphics,fg.bounds);
				}
				i++;
			}
			
			
			/* this.graphics.clear();
			this.graphics.beginFill(0xff,.1);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill(); */
			
			_invalidated = false;
		}
		
		/**
		 * Handler for when a layout's layoutInvalidated event has been caught.
		 * Invalidates the display list so the layout can be re-rendered. 
		 */
		protected function handleLayoutInvalidate(event:Event):void
		{
			var layout:AbstractLayout = event.target as AbstractLayout;
			if(invalidatedLayouts.indexOf(layout) == -1)
			{
				invalidatedLayouts.push(layout);
				super.invalidateDisplayList();
			}
		}
		
		/**
		 * Invalidates all layouts that this DataCanvas managers. 
		 */
		protected function invalidateAllLayouts():void
		{
			for each(var layout:AbstractLayout in layouts)
			{
				invalidatedLayouts.push(layout);
			}
			super.invalidateDisplayList();
		}
		
		// TODO This should be private
		/**
		 * @private
		 */
		public function onItemDataTip(e:LayoutItemEvent):void
		{
			
			
			/*
			var targetObject:DisplayObject = e.item as DisplayObject;
			
			while(!(targetObject is AxiisSprite))
			{
				targetObject = targetObject.parent;
				if(targetObject == this)
					return;
			}
			*/
			var dataTips:Array=new Array();
			
		
			//var axiisSprite:AxiisSprite = AxiisSprite(targetObject);
			
			var axiisSprite:AxiisSprite = e.item;
			
			if(axiisSprite.layout == null)
				return;
				
			var axiisSprites:Array=getHitSiblings(axiisSprite);
			
			for each (var a:AxiisSprite in axiisSprites) {
			
			var dataTip:DataTip2 = new DataTip2();

				dataTip.data = axiisSprite.data;
				if(axiisSprite.layout.dataTipLabelFunction != null)
					dataTip.label = axiisSprite.layout.dataTipLabelFunction(axiisSprite);
				else
					dataTip.label = axiisSprite.label;
				dataTip.value = axiisSprite.value;
				dataTip.index = axiisSprite.index;
				dataTip.contentFactory = axiisSprite.dataTipContentClass;
				dataTips.push(dataTip);
			}
			
			var dataTipManager:IDataTipManager=axiisSprite.layout.dataTipManager;
			
			dataTipManager.createDataTip(dataTips,this,axiisSprite);

		}
		
		/**
		 * @private
		 */
		public function onItemMouseOut(e:MouseEvent):void
		{
			var axiisSprite:AxiisSprite = e.target as AxiisSprite;
			if(!axiisSprite)
				return;
			
		}
		
		
		
		private function getHitSiblings(axiisSprite:AxiisSprite):Array
		{
			/*
			var s:Sprite = new Sprite();
			s.graphics.clear();
			s.graphics.beginFill(0,0);
			s.graphics.drawCircle(mouseX,mouseY,hitRadius);
			s.graphics.endFill();
			addChild(s);
			*/
			var toReturn:Array = [];
			toReturn.push(axiisSprite);
			
			/*var siblings:Array = axiisSprite.layout.childSprites;
			for each(var sibling:AxiisSprite in siblings)
			{
				if(sibling.hitTestObject(s))
				{
					toReturn.push(sibling);
				}
			}*/
			
		//	removeChild(s);
			
			return toReturn;
		}
		
		/*
		private function showToolTip(axiisSprite:AxiisSprite):void
		{
			var text:String = axiisSprite.layout.dataTipLabelFunction.call(this,axiisSprite.data);
			if(text != null && text != "")
			{
				//var tt:IToolTip = ToolTipManager.createToolTip(text,stage.mouseX + 10,stage.mouseY + 10);
				var tt:IToolTip = createToolTip(text,stage.mouseX + 10,stage.mouseY + 10);
				if(axiisSprite.layout.dataTipPositionFunction != null)
				{
					var position:Point = axiisSprite.layout.dataTipPositionFunction.call(this,axiisSprite,tt);
					tt.x = position.x;
					tt.y = position.y;
				}
				toolTips.push(tt); 
			}
		}
		*/
		/**
		 * Reposition the tool tips by laying them out in four columns around the cursor.
		 * The first column starts down and to the right of the cursor, the second
		 * starts down and to the left, the third is above and to the left, and the
		 * last column starts above and to the right. Each column grows vertically
		 * away from the cursor.
		 * 
		 * This method needs to be adjusted to account for tool tips that end up offscreen.
		 */
		 
		 /*
		private function repositionToolTips():void
		{
			var startX:Number = stage.mouseX;
			var startY:Number = stage.mouseY;
			var gapX:Number = 10;
			var gapY:Number = 10;
			var offsetYs:Array = [0,0,0,0];
			for(var a:int = 0; a < toolTips.length; a++)
			{
				var tt:DataTip = toolTips[a] as DataTip;
				var offsetY:Number = offsetYs[a % 4];
				if(a % 4 == 0)
				{
					tt.x = startX + gapX;
					tt.y = startY + gapY + offsetY;
				}
				else if(a % 4 == 1)
				{
					tt.x = startX - gapX - tt.width;
					tt.y = startY + gapY + offsetY;
				}
				else if(a % 4 == 2)
				{
					tt.x = startX - gapX - tt.width;
					tt.y = startY - gapY - tt.height - offsetY;
				}
				else
				{
					tt.x = startX + gapX;
					tt.y = startY - gapY - tt.height - offsetY;
				}
				offsetYs[a % 4] += tt.height;
				tt.calloutX=startX-tt.x;
				tt.calloutY=startY-tt.y;
			}
		}
		
		private function doToolTipsOverlap():Boolean 	
		{
			if(toolTips.length < 1)
				return false;
				
			var toolTipsOverlap:Boolean = false;
			for(var a:int = 0; a < toolTips.length - 1; a++)
			{
				var toolTip1:IToolTip = toolTips[a];
				for(var b:int = a + 1; b < toolTips.length; b++)
				{
					var toolTip2:IToolTip = toolTips[b];
					if(toolTip1.hitTestObject(toolTip2 as DisplayObject))
						return true;
				}
			}
			return false;
		}
		
		
		    private function createToolTip(text:String, x:Number, y:Number,
                                         errorTipBorderStyle:String = null,
                                         context:IUIComponent = null):IToolTip
		    {
		        var toolTip:DataTip=new DataTip;
		
		        var sm:ISystemManager = context ?
		                                          context.systemManager as ISystemManager:
		                                          ApplicationGlobals.application.systemManager as ISystemManager;
		       	//sm.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", toolTip as DisplayObject);
		
		        if (errorTipBorderStyle)
		        {
		            toolTip.setStyle("styleName", "errorTip");
		            toolTip.setStyle("borderStyle", errorTipBorderStyle);
		        }
				
				toolTip.width=100;
				toolTip.height=100;
		        toolTip.text = text;
				toolTip.calloutX=-10;
				toolTip.calloutY=-10;
				toolTip.calloutWidthRatio=.3;
		        toolTip.move(x, y);
		        // Ensure that tip is on screen?
		        // Should x and y for error tip be tip of pointy border?
		
		        // show effect?
		
		        return toolTip as IToolTip;
		    }
		    
		    private function destroyAllToolTips():void {
				while(toolTips.length > 0)
				{
					var tt:IToolTip = IToolTip(toolTips.pop());
					destroyToolTip(tt);
					tt = null;
				}	
			}
				*/
		    /**
		     *  Destroys a specified ToolTip that was created by the <code>createToolTip()</code> method.
		     *
		     *  <p>This method calls the <code>removeChild()</code> method to remove the specified
		     *  ToolTip from the SystemManager's ToolTips layer.
		     *  It will then be garbage-collected unless you keep a
		     *  reference to it.</p>
		     *
		     *  <p>You should not call this method on the ToolTipManager's
		     *  <code>currentToolTip</code>.</p>
		     *
		     *  @param toolTip The ToolTip instance to destroy.
		     
		    private function destroyToolTip(toolTip:IToolTip):void
		    {
		        var sm:ISystemManager = toolTip.systemManager as ISystemManager;
		       	//sm.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", DisplayObject(toolTip));
		
		        // hide effect?
		    }*/
	}
}