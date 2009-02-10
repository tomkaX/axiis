package org.axiis.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * An abstract super class for HorizontalLayout and VerticalLayout
	 */
	public class BoxLayout extends AbstractLayout
	{
		public function BoxLayout()
		{
			super();
		}
		
		protected var currPos:Number;
		
		[Bindable(event="gapChange")]
		public function set gap(value:Number):void
		{
			if(value != _gap)
			{
				_gap = value;
				invalidate();
				dispatchEvent(new Event("gapChange"));
			}
		}
		public function get gap():Number
		{
			return _gap;
		}
		private var _gap:Number = 5;
		
		override public function render():void
		{
			if(!sprite)
				return;
			
			currPos = 0;
			
			// The rectangle needed by degrafa to draw geometry
			var rectangle:Rectangle = new Rectangle(x,y,width,height);
			
			// Loop through the dataProvider, updating all the "current" properties
			// Call renderDatum at each iteration.
			_currentIndex = 0;
			for each(var o:Object in dataProvider)
			{
				// Create a Sprite if there isn't one already available
				if(currentIndex > sprite.numChildren - 1)
				{
					var newChildSprite:Sprite = new Sprite();
					sprite.addEventListener(MouseEvent.CLICK,handleSpriteClick);
					sprite.addChild(newChildSprite);
				}
				_currentItem = Sprite(sprite.getChildAt(currentIndex));
				_currentDatum = o;
				renderDatum(_currentDatum,_currentItem,rectangle);
				_currentIndex++;
			}
		}
		
		protected function handleSpriteClick(event:MouseEvent):void
		{
			selectedItem = event.target as Sprite;
			selectedIndex = sprite.getChildIndex(selectedItem);
			selectedDatum = dataProvider[selectedIndex];
		}
	}
}