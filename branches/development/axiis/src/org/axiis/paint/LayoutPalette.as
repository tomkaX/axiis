package org.axiis.paint
{
	import com.degrafa.paint.palette.InterpolatedColorPalette;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.axiis.core.ILayout;

	/**
	 * LayoutPalette will generate an Array of colors based on a Layout. The
	 * produced colors will be equally distributed between two given anchor
	 * colors and will contain <code>x</code> values where <code>x</code> is
	 * the number of objects in the Layout's <code>dataProvider</code>. As the
	 * Layout renders and its <code>currentIndex</code> property is incremented,
	 * the LayoutPalette's <code>currentColor</code> will be incremented as
	 * well.  Binding on the <code>currentColor</code> allows you vary the color
	 * of a fill or stroke used in the Layout's <code>drawingGeometries</code>
	 * as the Layout renders.
	 */
	public class LayoutPalette extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function LayoutPalette()
		{
			super();
		}
		
		/**
		 * The InterpolatedColorPalette use behind the scene to distribute the 
		 * colors in the palette evenly.
		 */
		private var palette:InterpolatedColorPalette = new InterpolatedColorPalette();

		public var autoInterpolate:Boolean = true;

		[Bindable]
		/**
		 * The Layout this LayoutPalette should use to determine how many colors
		 * to produce and to determine which color is the "current" one.
		 */
		public function get target():ILayout
		{
			return _target
		}
		private function set target(value:ILayout):void
		{
			if (_target)
				_target.removeEventListener("currentIndexChange", onIndexChanged);
			_target = value;
			if (_target)
				_target.addEventListener("currentIndexChange", onIndexChanged);
			generatePalette();			
		}
		private var _target:ILayout;

		/**
		 * The first color in the palette.
		 */
		public function set colorFrom(value:Number):void
		{
			if (!isNaN(value))
				_colorFrom = value;
			generatePalette();
		}
		private var _colorFrom:Number = 0;

		/**
		 * The last color in the palette.
		 */
		public function set colorTo(value:Number):void
		{
			if (!isNaN(value))
				_colorTo = value;
			generatePalette();
		}
		private var _colorTo:Number = 0xFFFFFF;

		[Bindable]
		/**
		 * The gradient of colors produced by this LayoutPalette.
		 */
		public function get colors():Array
		{
			return _colors;
		}
		public function set colors(value:Array):void
		{
			_colors = value;
		}
		private var _colors:Array = [];

		[Bindable(event="currentColorChange")]
		/**
		 * The color at index target.currentIndex in the colors Array.
		 */
		public function get currentColor():Number
		{
			return _currentColor;
		}
		private function set _currentColor(value:Number):void
		{
			if (value != _currentColor)
			{
				__currentColor = value;
				dispatchEvent(new Event("currentColorChange"));
			}
		}
		private function get _currentColor():Number
		{
			return __currentColor;
		}
		private var __currentColor:Number;

		private function generatePalette():void
		{
			if (_target == null)
				return;

			palette.colors = [_colorFrom, _colorTo];
			palette.requestedSize = _target.itemCount;

			if (autoInterpolate)
			{
				_colors = new Array();
				for (var i:int = 0; i < palette.requestedSize; i++)
				{
					_colors.push(palette.paletteEntries["pal_" + i].value);
				}
			}
			colors = _colors;
		}

		private function onIndexChanged(e:Event):void
		{
			if (!_colors || colors.length != _target.itemCount)
				generatePalette();
			_currentColor = _colors[_target.currentIndex];
		}
	}
}