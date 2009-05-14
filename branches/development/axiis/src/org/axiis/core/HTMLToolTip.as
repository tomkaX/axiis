///////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2009 Team Axiis
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////

/*
 * Created by Maikel Sibbald
 * info@flexcoders.nl
 * http://labs.flexcoders.nl
 */
 
/**
 * An extension of ToolTipBorder that allows ToolTips to use HTML.
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
            
            toolTip.width = calWidth;
            toolTip.height = calHeight;
            
            super.updateDisplayList(Math.ceil(calWidth), Math.ceil(calHeight));
        }
	}
}