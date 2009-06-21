package org.axiis.extras.charts.axis
{
	import com.degrafa.core.DegrafaObject;
	import com.degrafa.repeaters.IRepeaterModifier;

	public class SmithArcModifier extends DegrafaObject implements IRepeaterModifier
	{
		private var _sourceObject:Object = null;

		private var _modifyInProgress:Boolean=false;
		
		private var _modifier:Function;
		/**
		* This represents how we will be modifying the property.
		*/ 
		public function set modifier(value:Function):void {
			var oldValue:Function=_modifier;
			_modifier=value;
			initChange("modifier",oldValue,_modifier,this);
		}
		public function get modifier():Function { return _modifier };
		
		public function SmithArcModifier()
		{
			super();
		}

		public function beginModify(sourceObject:Object):void
		{
			if (_modifyInProgress) return;
			_sourceObject=sourceObject;
			_iteration=0;
			_modifyInProgress=true;
			this.suppressEventProcessing=true;
		}
		
		public function apply():void
		{
			//call the function to handle doing the modifier
			_modifier(_iteration, _sourceObject.items[0]);
			_iteration++;
		}
		
		public function end():void
		{
			if (!_modifyInProgress) return;
			_iteration=0;
			_modifyInProgress=false;
			this.suppressEventProcessing=false;
		}
		
		private var _iteration:Number = 0;
		public function get iteration():Number
		{
			return _iteration;
		}
	}
}