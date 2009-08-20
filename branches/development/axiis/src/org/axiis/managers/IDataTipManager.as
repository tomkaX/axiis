package org.axiis.managers
{
	import mx.core.UIComponent;
	
	import org.axiis.core.AxiisSprite;
	
	public interface IDataTipManager
	{
		function createDataTip(dataTip:UIComponent,context:UIComponent,axiisSprite:AxiisSprite):void;
		
		function destroyAllDataTips():void;
	}
}