/**
 * Created by Maikel Sibbald
 * info@flexcoders.nl
 * http://labs.flexcoders.nl
 */
package org.axiis.core
{
	import mx.controls.ToolTip;
	import mx.core.UITextField;
	import mx.skins.halo.ToolTipBorder;

	public class HTMLToolTip extends ToolTipBorder
	{
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            var toolTip:ToolTip = (this.parent as ToolTip);
            var textField:UITextField = toolTip.getChildAt(1) as UITextField;
            textField.htmlText = toolTip.text;
            
            var calHeight:Number = textField.height;
            calHeight += this.parent["getStyle"]("borderThickness")*2;
            calHeight += (textField.y*2);
            
            var calWidth:Number = textField.textWidth;
            calWidth += textField.x*2;
            calWidth += toolTip.getStyle("paddingLeft");
            calWidth += toolTip.getStyle("paddingRight");
             
            super.updateDisplayList(Math.ceil(calWidth), Math.ceil(calHeight));
        }
	}
}