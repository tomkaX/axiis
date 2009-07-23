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
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;
	
	// TODO This event should be moved to AbstractLayout
	/**
	 * Dispatched when invalidate is called so the DataCanvas that owns this
	 * layout can being the process of redrawing the layout.
	 */
	[Event(name="invalidateLayout", type="flash.events.Event")]
	
	/**
	 * Dispatched at the beginning of the render method. This event allowing
	 * listening objects the chance to perform any computations that will
	 * affect the layout's render process.
	 */
	[Event(name="preRender", type="flash.events.Event")]
	
	/**
	 * Dispatched before each individual child is rendered.
	 */
	[Event(name="itemPreDraw", type="flash.events.Event")]
	
	// TODO Is "AxiisLayout" a better name for BaseLayout 
	/**
	 * BaseLayout is a data driven layout engine that uses GeometryRepeaters
	 * and PropertyModifiers to transform geometries before drawing them to
	 * the screen.
	 */
	public class BaseLayout extends AbstractLayout
	{
		/**
		 * Constructor.
		 */
		public function BaseLayout()
		{
			super();
		}
		
		private var t:Number;
		
		private var propertySettersArrays:Array = [];
		
		private var currentPropertySetters:Array = [];
		
		private var originalPropertySetters:Array = [];

		[Bindable(event="scaleFillChange")]
		/**
		 * Whether or not the fills in this geometry should be scaled within the
		 * bounds rectangle.
		 */
		public function get scaleFill():Boolean
		{
			return _scaleFill;
		}
		public function set scaleFill(value:Boolean):void
		{
			if(value != _scaleFill)
			{
				_scaleFill = value;
				this.invalidate();
				dispatchEvent(new Event("scaleFillChange"));
			}
		}	
		private var _scaleFill:Boolean;
		
		/**
		 * Whether or not the drawingGeometries should should have their initial
		 * bounds set to the currentReference of the parent layout.
		 */
		public var inheritParentBounds:Boolean = true;
		
		override public function set dataTipContentClass(value:IFactory) : void
		{
			super.dataTipContentClass = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(sprite)
				sprite.visible = visible;
		}
		
		/** 
		 * Draws this layout to the specified AxiisSprite, tracking all changes
		 * made by data binding or the referenceRepeater. 
		 * 
		 * <p>
		 * If no sprite is provided this layout will use the last AxiisSprite
		 * it rendered to, if such an AxiisSprite exists. Otherwise this returns
		 * immediately.
		 * </p>
		 * 
		 * <p>
		 * The render cycle occurs in several stages. By watching for these
		 * events or by binding onto the currentReference, currentIndex, or the
		 * currentDatum properties, you can inject your own logic into the
		 * render cycle.  For example, if you bind a drawingGeometry's x
		 * position to currentReference.x and use a GeometryRepeater that
		 * adds 5 to the x property of the reference, the layout will render
		 * one geometry for each item in the dataProvider at every 5 pixels. 
		 * </p>
		 * 
		 * @param sprite The AxiisSprite this layout should render to.
		 */
		override public function render(newSprite:AxiisSprite = null):void 
		{
			if (!visible || !this.dataItems || itemCount==0) {
				if (newSprite) newSprite.visible=false;
				return;
			}
			
			if (newSprite) newSprite.visible=true;
			
			t=flash.utils.getTimer();
			
			trimChildSprites();
			
			dispatchEvent(new Event("preRender"));
			
			if(newSprite)
				this.sprite = newSprite;
			_rendering = true;

			if(!sprite || !_referenceGeometryRepeater)
				return;			
			
			if (inheritParentBounds && parentLayout)
			{
				bounds = new Rectangle(parentLayout.currentReference.x + (isNaN(x) ? 0 : x),
									parentLayout.currentReference.y + (isNaN(y) ? 0 : y),
									parentLayout.currentReference.width,
									parentLayout.currentReference.height);
			}
			else
			{
				bounds = new Rectangle((isNaN(x) ? 0:x),(isNaN(y) ? 0:y),width,height);
			}
			sprite.x = isNaN(_bounds.x) ? 0 :_bounds.x;
			sprite.y = isNaN(_bounds.y) ? 0 :_bounds.y;
			
			if (_dataItems)
			{
				_itemCount = _dataItems.length;
				if(_itemCount > 0 )
				{
					_currentDatum = null;
					_currentValue = null;
					_currentLabel = null;
					_currentReference = null;
					_currentIndex = -1;
					
					if(parentLayout == null)
						clearPropertySetterArrays();
					addModificationListeners();
					
					_referenceGeometryRepeater.repeat(itemCount, preIteration, postIteration, repeatComplete);
				}
			}
		}
		
		/**
		 * The callback method called by the referenceRepeater before it applies
		 * the PropertyModifiers on each iteration. This method updates the
		 * currentIndex, currentDatum, currentValue, and currentLabel
		 * properties.  It is recommended that subclasses override this method
		 * to perform any custom data-driven computations that affect the
		 * drawingGeometries.
		 */
		protected function preIteration():void
		{
			currentPropertySetters = clonePropertySetterArray(currentPropertySetters);
			
			_currentIndex = referenceRepeater.currentIteration;
			_currentDatum = dataItems[_currentIndex];
			if (dataField)
				_currentValue = getProperty(_currentDatum,dataField);
			else
				_currentValue= _currentDatum;
				
			if (labelField)
				_currentLabel = getProperty(_currentDatum,labelField).toString();
		}
		
		/**
		 * The callback method called by the referenceRepeater after it applies
		 * the PropertyModifiers on each iteration. This method updates the
		 * currentReference property and creates or updates the AxiisSprite that
		 * renders the currentDatum.  It is recommended that subclasses
		 * override this method to perform any computations that affect the
		 * drawingGeometries that are based on the drawingGeometries themselves.
		 */
		protected function postIteration():void
		{ 
			_currentReference = referenceRepeater.geometry;
			
			// Add a new Sprite if there isn't one available on the display list.
			if(_currentIndex > sprite.drawingSprites.length - 1)
			{
				var newChildSprite:AxiisSprite = createChildSprite(this);				
				sprite.addDrawingSprite(newChildSprite);
				childSprites.push(newChildSprite);
			}
			var currentChild:AxiisSprite = AxiisSprite(sprite.drawingSprites[currentIndex]);
			currentChild.data = currentDatum;
			currentChild.label = currentLabel;
			currentChild.value = currentValue;
			currentChild.index = currentIndex;
			
			dispatchEvent(new Event("itemPreDraw"));
			
			propertySettersArrays.push(currentPropertySetters);
			
			currentChild.bounds = bounds;
			currentChild.scaleFill = scaleFill;
			currentChild.geometries = drawingGeometries;
			currentChild.states = states;
			currentChild.revertingModifications = [];
			currentChild.dataTipAnchorPoint = dataTipAnchorPoint == null ? null : dataTipAnchorPoint.clone();
			currentChild.dataTipContentClass = dataTipContentClass;
			currentChild.render();
			
			renderChildLayouts(currentChild);
		}
		
		/**
		 * Calls the render method on all child layouts. 
		 */
		protected function renderChildLayouts(child:AxiisSprite):void
		{
			var i:int=0;
			for each(var layout:ILayout in layouts)
			{
				// When we have multiple peer layouts the AxiisSprite needs to
				// differentiate between child drawing sprites and child layout sprites
				layout.parentLayout = this as ILayout;
				if (child.layoutSprites.length-1 < i)
				{
					var ns:AxiisSprite = createChildSprite(this);
					child.addLayoutSprite(ns);
				}
				layout.render(child.layoutSprites[i]);
				i++;
			}
		}
		
		/**
		 * The callback method called by the referenceRepeater after it finishes
		 * its final iteration. Stop tracking changes to the drawingGeometries
		 * properties.
		 */
		protected function repeatComplete():void
		{
			sprite.visible = visible;
			_rendering = false;
			
			removeModificationListeners();
			
			if(parentLayout == null)
				updateSpritePropertySetters();
		}
		
		/**
		 * Removes the records of any property change events recorded thus far
		 * for this layout and all nested layouts.
		 */
		protected function clearPropertySetterArrays():void
		{
			propertySettersArrays = [];
			currentPropertySetters = [];
			originalPropertySetters = [];
			
			for each(var layout:BaseLayout in layouts)
			{
				layout.clearPropertySetterArrays();
			}
		}
		
		private function clonePropertySetterArray(arr:Array):Array
		{
			var toReturn:Array = [];
			for each(var propertySetter:PropertySetter in arr)
			{
				toReturn.push(propertySetter.clone());
			}
			return toReturn;
		}
		
		/**
		 * Passes the recorded property changes to the AxiisSprites.
		 */
		protected function updateSpritePropertySetters():void
		{
			for(var a:int = 0; a < childSprites.length; a++)
			{
				AxiisSprite(childSprites[a]).revertingModifications = propertySettersArrays[a];
			}
			for each(var layout:BaseLayout in layouts)
			{
				layout.updateSpritePropertySetters();
			}
		}
		
		private function addModificationListeners():void
		{
			for each(var geometry:Geometry in drawingGeometries)
			{
				geometry.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,handleGeometryPropertyChange);
			}
		}
		
		private function removeModificationListeners():void
		{
			for each(var geometry:Geometry in drawingGeometries)
			{
				geometry.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,handleGeometryPropertyChange);
			}
		}
		
		private function handleGeometryPropertyChange(event:PropertyChangeEvent):void
		{
			if (currentIndex==itemCount-1 && this.referenceRepeater.iterationLoopComplete)
			{
				currentPropertySetters = propertySettersArrays[0]; //Grab the first one
				if(hasModificationForProperty(currentPropertySetters,event.source,event.property))
				{
					//trace("returning")
					return;
				}
			}
			
			if(!hasModificationForProperty(originalPropertySetters,event.source,event.property))
			{
				var oldPropertySetter:PropertySetter = new PropertySetter(event.source,event.property,event.oldValue);
				originalPropertySetters.push(oldPropertySetter);
				for each(var arr:Array in propertySettersArrays)
				{
					arr.push(oldPropertySetter.clone());
				}
			}
			
			var found:Boolean = false;
			for each(var propertySetter:PropertySetter in currentPropertySetters)
			{
				if(propertySetter.target == event.source
					&& propertySetter.property == event.property)
				{
					//if(currentIndex == 2)
					//	trace(currentIndex,"OLD",event.property,event.newValue)
					propertySetter.value = event.newValue;
					found = true;
					break;
				}
			}
			if(!found)
			{
				//if(currentIndex == 2)
				//	trace(currentIndex,"OLD",event.property,event.newValue)
				var newPropertySetter:PropertySetter = new PropertySetter(event.source,event.property,event.newValue);
				currentPropertySetters.push(newPropertySetter);
			}
		}
		
		private function hasModificationForProperty(propertySetters:Array,target:Object,property:Object):Boolean
		{
			for each(var propertySetter:PropertySetter in propertySetters)
			{
				if(propertySetter.target == target && propertySetter.property == property)
					return true;
			}
			return false;
		}
		
		private function createChildSprite(layout:ILayout):AxiisSprite
		{
			var newChildSprite:AxiisSprite = new AxiisSprite();
			newChildSprite.doubleClickEnabled=true;
			newChildSprite.layout = layout;
			return newChildSprite;
		}

		private function trimChildSprites():void
		{
			if (!sprite || _itemCount < 1)
				return;
			var trim:int = sprite.drawingSprites.length-_itemCount;
			for (var i:int=0; i <trim;i++)
			{
				var s:AxiisSprite = AxiisSprite(sprite.removeChild(sprite.drawingSprites[sprite.drawingSprites.length-1]));
				s.dispose();
			}
		}
		
		private function getProperty(obj:Object, propertyName:String):Object
		{
			if(obj == null)
				return null;
				
			var chain:Array=propertyName.split(".");
			if (chain.length < 2)
				return obj[chain[0]];
			else
				return getProperty(obj[chain[0]],chain.slice(1,chain.length).join("."));
		}
	}
}