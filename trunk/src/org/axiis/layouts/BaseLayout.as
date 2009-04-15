package org.axiis.layouts
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.axiis.core.AbstractLayout;
	import org.axiis.core.AxiisSprite;
	import org.axiis.core.ILayout;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	[Event(name="preRender", type="flash.events.Event")]
	[Event(name="itemPreDraw", type="flash.events.Event")]
	public class BaseLayout extends AbstractLayout
	{
		
		public function BaseLayout()
		{
			super();
		}
		
		private var _currentChild:AxiisSprite;
		
		private var activeStates:Array = [];

		[Bindable(event="scaleFillChange")]
		/**
		 * Set to TRUE - this will use a common bounds to fill all layout items being drawn
		 * Set to FALSE - each layout item will have its own fill bounds 
		 */
		public function set scaleFill(value:Boolean):void
		{
			if(value != _scaleFill)
			{
				_scaleFill = value;
				invalidate();
				dispatchEvent(new Event("scaleFillChange"));
			}
		}
	
		public function get scaleFill():Boolean
		{
			return _scaleFill;
		}
		private var _scaleFill:Boolean;
		
		/**
		 * Set to TRUE - drawing geometries will have their intial bounds set to 
		 * that of the currentReference of the PARENT LAYOUT.  This directly positions child drawing sprites on x/y according to
		 * currentReference x/y of parent layout.
		 * 
		 * Set to FALSE - sprite gets the x/y of the current Layout
		 */
		public var inheritParentBounds:Boolean = true;
		
	
		override public function render(newSprite:AxiisSprite = null):void 
		{
			//trace(name + " render " +currentIndex)
			var t:Number=flash.utils.getTimer();
			
			this.dispatchEvent(new Event("preRender"));
			
			if(newSprite)
				this.sprite = newSprite;
			
				
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
			
			_referenceGeometryRepeater.dataProvider=_dataItems;
			if (_dataItems)
				_itemCount=_dataItems.length;
			
			if (_dataItems && _dataItems.length > 0)
			{
				_currentIndex=-1;
				_referenceGeometryRepeater.repeat(preIteration, postIteration);
			}
		}
		
		protected function preIteration():void
		{
			_currentIndex++;
			_currentDatum = dataItems[_currentIndex];
			if (dataField)
				_currentValue = getProperty(_currentDatum,dataField);
			else
				_currentValue=_currentDatum;
			if (labelField)
				_currentLabel = getProperty(_currentDatum,labelField).toString();
		}
		
		private function getProperty(obj:Object, propertyName:String):Object {
			var chain:Array=propertyName.split(".");
			if (chain.length<2) {
				return obj[chain[0]];
			}
			else {
				return getProperty(obj[chain[0]],chain.slice(1,chain.length).join("."));
			}
		}
		/**
		 * TODO we need to handle removing sprites when data is removed from the dataProvider
		 *  including removing listeneners so they can be garbage collected.
		 */
		protected function postIteration():void
		{
			_currentReference = referenceRepeater.geometry;
			
			// Add a new Sprite if there isn't one available on the display list.
			if(_currentIndex > sprite.drawingSprites.length - 1)
			{
				var newChildSprite:AxiisSprite = createChildSprite();
				sprite.name = "drawing" + StringUtil.trim(name) + "" + sprite.drawingSprites.length;
				sprite.addDrawingSprite(newChildSprite);
				childSprites.push(newChildSprite);
			}
			_currentChild = AxiisSprite(sprite.drawingSprites[currentIndex]);
			_currentChild.data = currentDatum;
			
			dispatchEvent(new Event("itemPreDraw"));
			
			_currentChild.bounds = bounds;
			_currentChild.scaleFill = scaleFill;
			_currentChild.geometries = cloneGeometries();
			_currentChild.render();
	
			var i:int=0;
			for each(var layout:ILayout in layouts)
			{
				
				layout.parentLayout = this as ILayout;    //When we have multiple peer layouts the AxiisSprite needs to differentiate between child drawing sprites and child layout sprites
				if (_currentChild.layoutSprites.length-1 < i) {
					var ns:AxiisSprite = createChildSprite();
					ns.name="layout - " + StringUtil.trim(name) + " " + _currentChild.layoutSprites.length;
					_currentChild.addLayoutSprite(ns);
				}
				layout.render(_currentChild.layoutSprites[i]);
				i++;
			}
		}
		
		
		private function createChildSprite():AxiisSprite
		{
			var newChildSprite:AxiisSprite = new AxiisSprite();
			newChildSprite.doubleClickEnabled=true;
			newChildSprite.layout = this;
			newChildSprite.states = states;
			return newChildSprite;
		}

		
		private function cloneGeometries():Array
		{
			var toReturn:Array = new Array();
			for each(var geometry:Geometry in drawingGeometries)
			{
				//if(geometry is ICloneable)
				//	toReturn.push(ICloneable(geometry).clone());
				//else
					//trace("error: geometry is not cloneable");
					toReturn.push(geometry)
			}
			return toReturn;
		}
		
		override protected function invalidateDataProvider(previousCount:int):void {
			trimChildSprites(previousCount-_dataItems.length);
		}
		
		private function trimChildSprites(trim:Number):void {
			if (!sprite || sprite.drawingSprites.length<trim) return;
			for (var i:int=0; i<=trim;i++) {
				var s:AxiisSprite=AxiisSprite(sprite.removeChild(sprite.drawingSprites[sprite.drawingSprites.length-1]));
				s.dispose();
			}
		}
			
	
	}
}