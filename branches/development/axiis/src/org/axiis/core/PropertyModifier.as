package  org.axiis.core
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	* PropertyModifier is used to specify changes that should 
	* occur on the geometry or subsequent objects being repeated.
	**/
	public class PropertyModifier extends EventDispatcher
	{
		/**
		* The PropertyModifier constructor.
		*/
		public function PropertyModifier()
		{
			super();
		}
		
		private var target:Object;
		
		private var originalValue:Object;
		
		public var property:String;
		
		public var modifier:Object;
		
		/**
		* The current iteration of an active modification.
		*/
	   	public function get iteration():Number
	   	{
	   		return _iteration;
	   	}
	   	private var _iteration:Number = -1;
			
		[Inspectable(category="General", enumeration="add,subtract,multiply,divide,none")]
		[Bindable(event="modifierOperatorChange")]
		/**
		 * How to apply the modifier for each iteration.
		 */
		public function set modifierOperator(value:String):void
		{
			if(value != "add" &&
				value != "subtract" &&
				value != "multiply" &&
				value != "divide" &&
				value != "none")
			{
				trace('warning: attempting to set modifierOperator to ' + value + '.  '
					+ 'The only legal values are add, subtract, multiple, divide, and none.  '
					+ 'modifierOperator will remain as "'+ modifierOperator + '".');
				return;
			}
			if(value != _modifierOperator)
			{
				_modifierOperator = value;
				dispatchEvent(new Event("modifierOperatorChange"));
			}
		}
		public function get modifierOperator():String
		{
			return _modifierOperator;
		}
		private var _modifierOperator:String = "add";
		
		/**
		* This tells the modifier that it will be doing iterations and 
		* modifying the source object.
		*/
		public function beginModify(target:Object):void
		{
			if (iteration != -1)
				end();
			this.target = target;
			originalValue = target[property];
			_iteration = 0;
		}
		
		/**
		* This ends the modification loop and we need to set 
		* back our modified property to its original state.
		*/
		public function end():void
		{
			if(!target)
				return;
			target[property] = originalValue;
			_iteration = -1;
		}
		
		/**
		* This applies our numeric modifier or array of modifiers to 
		* the property of our geometryObject.
		*/
		public function apply():void
		{
			if (modifier)
			{
				if(_modifierOperator == "none")
				{
					var temp:Object;
					if (modifier is Array)
						temp = modifier[iteration % modifier.length];
					else if (modifier is Function)
						temp = modifier(iteration,target[property]);
					else
						temp = Number(modifier);
					target[property] = temp;
				}
				else if(_iteration > 0)
				{
					var tempNumber:Number;
					if (modifier is Array)
						tempNumber = Number(modifier[iteration % modifier.length]);
					else if (modifier is Function)
						tempNumber = Number(modifier(iteration,target[property]));
					else
						tempNumber = Number(modifier);
					
					if (_modifierOperator == "add")  
						target[property] += tempNumber;
					else if (_modifierOperator == "subtract")
						target[property] -= tempNumber;
					else if (_modifierOperator == "multiply")
						target[property] *= tempNumber;
					else if (_modifierOperator == "divide")
						target[property] /= tempNumber;
				}
			}
			_iteration++;
		}
	}
}