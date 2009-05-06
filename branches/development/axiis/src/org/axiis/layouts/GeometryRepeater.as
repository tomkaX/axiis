package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.core.Application;

	public class GeometryRepeater extends EventDispatcher
	{
		public function GeometryRepeater()
		{
			super();
		}
		
		public var iterationLoopComplete:Boolean=true;  //Used by base layout to stop propogating propertychange events when everything gets returned to original state
		
		public var geometry:Geometry;
		
		[Inspectable(category="General", arrayType="org.axiis.core.PropertyModifier")]
		[ArrayElementType("org.axiis.core.PropertyModifier")]
		public var modifiers:Array;
		
		public var dataProvider:Array;
		
		public function get currentDatum():Object
		{
			return _currentDatum;
		}
		private var _currentDatum:Object;
		
		public function get currentIteration():int
		{
			return _currentIteration;
		}
		private var _currentIteration:int;
		
		private var timerID:int;
		
		public function repeat(preIterationCallback:Function = null, postIterationCallback:Function=null, completeCallback:Function = null):void
		{
			iterationLoopComplete=false;
			clearTimeout(timerID);
			_currentIteration = 0;
			repeatHelper(preIterationCallback,postIterationCallback,completeCallback);
		}
		
		protected function repeatHelper(preIterationCallback:Function = null, postIterationCallback:Function=null, completeCallback:Function = null):void
		{
			if(!dataProvider)
				return;
			
			var len:int = dataProvider.length;
			var app:Application = Application(Application.application);
			var millisecondsPerFrame:Number = app.stage ? 1000 / app.stage.frameRate : 50;
			var startTime:int = getTimer();
			var totalTime:int = 0;
			while(totalTime < millisecondsPerFrame && currentIteration < len)
			{
				if(preIterationCallback != null)
					preIterationCallback.call(this);
				
				_currentDatum = dataProvider[currentIteration];
				
				if(geometry)
				{
					for each (var modifier:PropertyModifier in modifiers)
					{ 
						if(currentIteration == 0)
							modifier.beginModify(geometry);
						modifier.apply();
					}
				}
				_currentIteration++;
				
				if (postIterationCallback != null)
					postIterationCallback.call(this);
			
				totalTime = getTimer() - startTime;
			}
		
			
			// We've finished looping before time ran out. Tear down and call completeCallback
			if(currentIteration == len)
			{
					
				iterationLoopComplete=true;
				for each (modifier in modifiers)
				{
					modifier.end();
				}
				_currentIteration = -1;
				completeCallback.call(this); //Call back now, before we set all our properties back to the original values
				
			}
			// The loop took too long and we had to break out. Give the player 10ms to render and, and try again
			else
			{
				timerID = setTimeout(repeatHelper,1,preIterationCallback,postIterationCallback,completeCallback);
			}
		}
	}
}