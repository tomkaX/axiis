package org.axiis.paint
{
	import com.degrafa.paint.palette.InterpolatedColorPalette;
	
	import flash.events.Event;
	
	import org.axiis.core.ILayout;
	
	public class LayoutPalette
	{
		
		public function LayoutPalette()
		{	
			
		}
		
		public var autoInterpolate:Boolean=true;
		
		private function set target(value:ILayout):void {
			removeListeners();
			_target=value;
			addListeners();
		}
		
		[Bindable]
		public function get target():ILayout {
			return _target
		}
		
		[Bindable]
		private var _target:ILayout;

		private var palette:InterpolatedColorPalette=new InterpolatedColorPalette();

		public function set colorFrom(value:Number):void {
			if (!isNaN(value))
				_colorFrom=value;
			generatePalette();
		}
		
		private var _colorFrom:Number=0;
		
		public function set colorTo(value:Number):void {
			if (!isNaN(value))
				_colorTo=value;
			generatePalette();
		}
		
		private var _colorTo:Number=0xFFFFFF;
		
		
		public function set colors(value:Array):void {
			_colors=value;
		}
		
		[Bindable]
		public function get colors():Array {
			return _colors;
		}
				
		[Bindable]
		private var _colors:Array=new Array;
		
		[Bindable(event="currentColorChange")]
		public function get currentColor():Number {
			if (_currentColor==0) {
				trace("it is zero");
			}
			return _currentColor;
		}	

		protected function set _currentColor(value:Number):void {
			if(value != _currentColor)
			{
				__currentColor = value;
				dispatchEvent(new Event("currentColorChange"));
			}
		}

		protected function get _currentColor():Number {
			return __currentColor;
		}
		
		private var __currentColor:Number;

		private function generatePalette():void {
			if ( _target==null) return;
			
			//palette.colorFrom=_colorFrom;
			//palette.colorTo=_colorTo;
			palette.colors=[_colorFrom,_colorTo];
			palette.requestedSize=_target.itemCount;
		
			
			if (autoInterpolate) {
				_colors=new Array();
				for (var i:int=0;i<palette.requestedSize; i++) {
					_colors.push(palette.paletteEntries["pal_"+i].value);
				}
			}
			colors=_colors;
		}
		
		private function removeListeners():void {
			if (_target) {
				_target.removeEventListener("currentIndexChange",onIndexChanged);
			}
		}
		private function addListeners():void {
			if (_target) {
				_target.addEventListener("currentIndexChange",onIndexChanged);
				generatePalette();
			}
		}
		
		private function onIndexChanged(e:Event):void {
			if (!_colors || colors.length!=_target.itemCount) {
				generatePalette();
			}
			_currentColor=_colors[_target.currentIndex];
			

		}
	}
}