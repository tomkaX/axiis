package org.axiis.utils
{			
import com.degrafa.geometry.segment.LineTo;
import com.degrafa.geometry.segment.QuadraticBezierTo;

import flash.geom.Point;

	public class GraphicUtils
	{
		public function GraphicUtils()
		{
		}

	    
	    public static function buildSegmentsFromCurvePoints(pts:Array, tension:Number=.25):Array
		{
		 var incr=1;
	     var start:int = 0;
	     var end:int=pts.length;
		 var innerEnd:int = pts.length - incr;
		 var segments:Array=new Array();
		 var reverse:Boolean=false;
		 var len:Number;
	
			while (start != end)
			{
				if (pts[start + incr].x != pts[start].x ||
					pts[start + incr].y != pts[start].y)
				{
					break;
				}
				start += incr;
			}
			if (start == end || start + incr == end)
				return null;
				
			if (Math.abs(end - start) == 2)
			{
				segments.push(new LineTo(pts[start + incr].x, pts[start + incr].y));
				return null;
			}

			var tanLeft:Point = new Point();
			var tanRight:Point = new Point();
			var tangentLengthPercent:Number = tension;
			
			if (reverse)
				tangentLengthPercent *= -1;
			
			var j:int= start; 

			var v1:Point = new Point();
			var v2:Point = new Point(pts[j + incr].x - pts[j].x,
									 pts[j + incr].y - pts[j].y);
			var tan:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var mp:Point = new Point();
			
			len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
			v2.x /= len;
			v2.y /= len;
			
			var tanLenFactor:Number = pts[j + incr].x - pts[j].x;
			
			var prevNonCoincidentPt:Object = pts[j];
			
			for (j += incr; j != innerEnd; j += incr)
			{

				if (pts[j + incr].x == pts[j].x &&
				    pts[j + incr].y == pts[j].y)
				{
					continue;
				}
					 
				v1.x = -v2.x
				v1.y = -v2.y;
				
				v2.x = pts[j + incr].x - pts[j].x;
				v2.y = pts[j + incr].y - pts[j].y;
				
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

					segments.push(new QuadraticBezierTo(pts[j].x + tanLeft.x,
							  pts[j].y + tanLeft.y,
							  pts[j].x,
							  pts[j].y));
				}
				else
				{
					// Determine the two control points...
					p1.x = prevNonCoincidentPt.x + tanRight.x;
					p1.y = prevNonCoincidentPt.y + tanRight.y;
					
					p2.x = pts[j].x + tanLeft.x;
					p2.y = pts[j].y + tanLeft.y;
					
					// and the midpoint of the line between them.
					mp.x = (p1.x+p2.x)/2
					mp.y = (p1.y+p2.y)/2;
					
					// Now draw our two quadratics.
					segments.push(new QuadraticBezierTo(p1.x, p1.y, mp.x, mp.y));
					segments.push(new QuadraticBezierTo(p2.x, p2.y, pts[j].x, pts[j].y));
					
				}

				tanLenFactor = pts[j + incr].x - pts[j].x;
				tanRight.x = tan.x * tanLenFactor * tangentLengthPercent;
				tanRight.y = tan.y * tanLenFactor * tangentLengthPercent;
				prevNonCoincidentPt = pts[j];
			}

					segments.push(new QuadraticBezierTo(prevNonCoincidentPt.x + tanRight.x,
				  prevNonCoincidentPt.y + tanRight.y,
				  pts[j].x, pts[j].y));

		return segments;
		
	
	    }

	}
}