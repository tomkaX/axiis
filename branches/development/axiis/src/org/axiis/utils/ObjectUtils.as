package org.axiis.utils
{
	import mx.collections.ArrayCollection;
	
	public class ObjectUtils {
	
	 /**
	 * This Object Utility class is primarily used to extract property values from dynamic objects
	 */
		public function ObjectUtils()
		{
		}
		
		 /**
	 	 * Extracts @param propertyName from @param obj
	 	 * @param propertyName supports a dot.dot syntax as well as Arrays 
	 	 * i.e propertyName="myObject.myArray[3].myOtherProperty" is a valid syntax
	 	 */
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
				if (chain[0].charAt(0)=="[") {
					if(obj is Array) {
						return obj[chain[0].substr(1,chain[0].length-1)];
					}
					else if (obj is ArrayCollection) {
						return obj.getItemAt(int(chain[0].substr(1,chain[0].length-1)));
					}
				}
				else if (chain[0].indexOf("[")<0)  //If we have an array return the array element
					return obj[chain[0]];
					else {
						var element:Object= obj[chain[0].substr(0, chain[0].indexOf("["))];
						return element[chain[0].substr(chain[0].indexOf("[")+1,chain[0].indexOf("]")-chain[0].indexOf("[")-1)];
					}
			}
				
			else {
				if (chain[0].charAt(0)=="[") {
					if(obj is Array && obj.length > 0) {
						return getProperty(caller, obj[chain[0].substr(1,chain[0].length-1)],chain.slice(1,chain.length).join("."));
					}
					else if (obj is ArrayCollection && obj.length > 0) {
						return getProperty(caller, obj.getItemAt(int(chain[0].substr(1,chain[0].length-1))),chain.slice(1,chain.length).join("."));
					}
					else
						return null;
				}
				else if (chain[0].indexOf("[")<0)  //If we have an array return the array element
					return getProperty(caller, obj[chain[0]],chain.slice(1,chain.length).join("."));
				else
				{
						var element:Object= obj[chain[0].substr(0, chain[0].indexOf("["))];
						var index:String= (chain[0].substr(chain[0].indexOf("[")+1,chain[0].indexOf("]")-chain[0].indexOf("[")-1));
						return getProperty(caller, element[index],chain.slice(1,chain.length).join("."));
					}
					
			}
				
		}

	}
}