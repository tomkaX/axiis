package org.axiis.managers
{
	import mx.core.UIComponent;
	
	import org.axiis.core.AxiisSprite;
	
	public interface IDataTipManager
	{
		function createDataTip(dataTips:Array,context:UIComponent,axiisSprite:AxiisSprite):void;
		
		function destroyAllDataTips():void;
		
		function get dataTips():Array;
	}
}