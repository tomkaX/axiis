package org.axiis.utils
{
	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		
		public static  function getProperty(caller:Object, obj:Object, propertyName:Object):*
		{
			if(obj == null)
				return null;
				
			if (propertyName) {
				if (propertyName is Function) {
					return propertyName.call(caller,obj);
				}
			}	
			else
				return obj;
				
			var chain:Array=propertyName.split(".");
			if (chain.length == 1) {
				if (chain[0].indexOf("[")<0)  //If we have an array return the array element
					return obj[chain[0]];
					else {
						var element:Object= obj[chain[0].substr(0, chain[0].indexOf("["))];
						return element[chain[0].substr(chain[0].indexOf("[")+1,chain[0].indexOf("]")-chain[0].indexOf("[")-1)];
					}
			}
				
			else {
				if (chain[0].indexOf("[")<0)  //If we have an array return the array element
					return getProperty(caller, obj[chain[0]],chain.slice(1,chain.length).join("."));
				else
				{
						var element:Object= obj[chain[0].substr(0, chain[0].indexOf("["))];
						var index:String= (chain[0].substr(chain[0].indexOf("[")+1,chain[0].indexOf("]")-chain[0].indexOf("[")-1));
						trace("index=" + index);
						return getProperty(caller, element[index],chain.slice(1,chain.length).join("."));
					}
					
			}
				
		}

	}
}