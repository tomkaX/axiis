package org.axiis.transitions
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.effects.AnimateProperty;
	
	import org.axiis.core.AxiisSprite;
	import org.axiis.core.BaseLayout;
	import org.axiis.events.LayoutItemEvent;


	public class Transition
	{
		public function Transition()
		{
		}

		/**
		 * An array of Animated Properties that will be applied to the layouts sprites.
		 *
		 */
		public function get animations():Array
		{
			return _animations;
		}

		public function set animations(value:Array):void
		{
			if (_animations != value)
			{
				_animations=value;
			}
		}

		public var playDelay:Number=0;

		private var _animations:Array=[];

		//Array of arrays
		private var _storedFromValues:Array=[];

		private var _storedToValues:Array=[];

		private var _playIndex:int=0;

		//Plays the transition
		public function play():void
		{
			_playIndex=0;
			animate();
		}

		private function animate():void
		{
			if (_playIndex < _layout.childSprites.length)
			{
				if (_playIndex < _layout.childSprites.length)
				{
					trace("animating at index=" + _playIndex);
					var s:AxiisSprite=_layout.childSprites[_playIndex];
					for (var i:int=0;i<_animations.length; i++)
					{
						var a:mx.effects.AnimateProperty=_animations[i];
						a.toValue=_storedToValues[_playIndex][i];
						a.fromValue=_storedFromValues[_playIndex][i];
						a.target=s;
						a.play();
					}
					_playIndex++; 
					if (playDelay > 0) 
						setTimeout(animate, this.playDelay);
					else
						animate();
				}
			}
		}



		//Used to assign the parent layout - should only be called by parent layout
		public function assignLayout(layout:BaseLayout):void
		{
			if (_layout) {
				_layout.removeEventListener("preRender",layoutOnPreRender);
				_layout.removeEventListener("itemPreDraw", layoutOnItemPreDraw);
				_storedToValues=[];
				_storedFromValues=[];
			}
			_layout=layout;
			_layout.addEventListener("itemPreDraw", layoutOnItemPreDraw);
			_layout.addEventListener("itemPreRender", layoutOnPreRender);
		}

		private var _layout:BaseLayout;

		//Setup our stored properties
		private function layoutOnPreRender(e:Event):void
		{
			_storedFromValues=new Array();
			_storedToValues=new Array();

		}

		//Capture our stored properties for later
		private function layoutOnItemPreDraw(e:Event):void
		{
			var fromValues:Array=new Array();
			var toValues:Array=new Array();
			for (var i:int=0; i < _animations.length; i++)
			{
				fromValues.push(_animations[i].fromValue);
				toValues.push(_animations[i].toValue);
			}

			_storedFromValues.push(fromValues);
			_storedToValues.push(toValues);
		}

	}
}