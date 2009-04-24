package org.axiis.layouts.scale
{
	/**
	 * The base class for scales that deal with numerical data.
	 */
	public class ContinuousScale extends AbstractScale
	{
		/**
		 * Updates the computed minimum and maximum values if the user
		 * has not already set them.  
		 */
		override public function validate():void
		{
			super.validate();
			if(userMinValue == null)
				computedMinValue = computeMin();
			
			if(userMaxValue == null)
				computedMaxValue = computeMax();
		}
		
		/**
		 * Returns the minimum value from the dataProvider. 
		 */
		protected function computeMin():Object
		{
			var newMin:Object;
			for each(var o:Object in dataProvider)
			{
				var currValue:Object = dataField == null ? o : o[dataField];
				if(newMin == null)
					newMin = currValue;
				else
					newMin = currValue < newMin ? currValue : newMin;
			}
			return newMin;
		}
		
		/**
		 * Returns the maximum value from the dataProvider. 
		 */
		protected function computeMax():Object
		{
			var newMax:Object;
			for each(var o:Object in dataProvider)
			{
				var currValue:Object = dataField == null ? o : o[dataField];
				if(newMax == null)
					newMax = currValue;
				else
					newMax = currValue > newMax ? currValue : newMax;
			}
			return newMax;
		}
	}
}