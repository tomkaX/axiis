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

package org.axiis.utils
{			
	import com.degrafa.geometry.segment.LineTo;
	import com.degrafa.geometry.segment.QuadraticBezierTo;
	
	import flash.geom.Point;

	/**
	 * An all static class containing methods used to create Degrafa geometry.
	 */
	public class GraphicUtils
	{
		/**
		 * Converts an Array of GraphicPoints into a series of curveTo commands
		 * that can then be used to draw a curve to a graphics context.
		 * 
		 * @param graphicPoints The Array of GraphicPoints to draw the curve between.
		 * 
		 * @param tension A value between 0 and 1 representing the rigidity of
		 * the curve. A tension of 1 will produce a straight line while a
		 * tension of 0 will result in a highly curved Bezier curve.
		 */
	    public static function buildSegmentsFromCurvePoints(graphicPoints:Array, tension:Number=.25):Array
		{
			var incr:Number=1;
			var start:int = 0;
			var end:int=graphicPoints.length;
			var innerEnd:int = graphicPoints.length - incr;
			var segments:Array=new Array();
			var reverse:Boolean=false;
			var len:Number;
	
			//This skips coincident points 
			while (start != end)
			{
				if (graphicPoints[start + incr].x != graphicPoints[start].x ||
					graphicPoints[start + incr].y != graphicPoints[start].y)
				{
					break;
				}
				
				start += incr;
			}
			if (start == end || start + incr == end)
				return null;
				
			if (Math.abs(end - start) == 2)
			{
				segments.push(new LineTo(graphicPoints[start + incr].x, graphicPoints[start + incr].y));
				return null;
			}

			var tanLeft:Point = new Point();
			var tanRight:Point = new Point();
			var tangentLengthPercent:Number = tension;
			
			if (reverse)
				tangentLengthPercent *= -1;
			
			var j:int= start; 

			var v1:Point = new Point();
			var v2:Point = new Point(graphicPoints[j + incr].x - graphicPoints[j].x,
									 graphicPoints[j + incr].y - graphicPoints[j].y);
			var tan:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var mp:Point = new Point();
			
			len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
			v2.x /= len;
			v2.y /= len;
			
			var tanLenFactor:Number = graphicPoints[j + incr].x - graphicPoints[j].x;
			
			var prevNonCoincidentPt:Object = graphicPoints[j];
			
			for (j += incr; j != innerEnd; j += incr)
			{

				if (graphicPoints[j + incr].x == graphicPoints[j].x &&
				    graphicPoints[j + incr].y == graphicPoints[j].y)
				{
					continue;
				}
					 
				v1.x = -v2.x
				v1.y = -v2.y;
				
				v2.x = graphicPoints[j + incr].x - graphicPoints[j].x;
				v2.y = graphicPoints[j + incr].y - graphicPoints[j].y;
				
				len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
				v2.x /= len;
				v2.y /= len;
				
				tan.x = v2.x - v1.x;
				tan.y = v2.y - v1.y;
				var tanlen:Number = Math.sqrt(tan.x * tan.x + tan.y * tan.y);
				tan.x /= tanlen;
				tan.y /= tanlen;

				if (v1.y * v2.y >= 0)
					tan = new Point(1, 0);

				tanLeft.x = -tan.x * tanLenFactor * tangentLengthPercent;
				tanLeft.y = -tan.y * tanLenFactor * tangentLengthPercent;

				if (j == (incr+start))
				{

					segments.push(new QuadraticBezierTo(graphicPoints[j].x + tanLeft.x,
							  graphicPoints[j].y + tanLeft.y,
							  graphicPoints[j].x,
							  graphicPoints[j].y));
				}
				else
				{
					// Determine the two control points...
					p1.x = prevNonCoincidentPt.x + tanRight.x;
					p1.y = prevNonCoincidentPt.y + tanRight.y;
					
					p2.x = graphicPoints[j].x + tanLeft.x;
					p2.y = graphicPoints[j].y + tanLeft.y;
					
					// and the midpoint of the line between them.
					mp.x = (p1.x+p2.x)/2
					mp.y = (p1.y+p2.y)/2;
					
					// Now draw our two quadratics.
					segments.push(new QuadraticBezierTo(p1.x, p1.y, mp.x, mp.y));
					segments.push(new QuadraticBezierTo(p2.x, p2.y, graphicPoints[j].x, graphicPoints[j].y));
					
				}

				tanLenFactor = graphicPoints[j + incr].x - graphicPoints[j].x;
				tanRight.x = tan.x * tanLenFactor * tangentLengthPercent;
				tanRight.y = tan.y * tanLenFactor * tangentLengthPercent;
				prevNonCoincidentPt = graphicPoints[j];
			}
			segments.push(new QuadraticBezierTo(prevNonCoincidentPt.x + tanRight.x,
			prevNonCoincidentPt.y + tanRight.y,
			graphicPoints[j].x, graphicPoints[j].y));
			return segments;
	    }
	}
}