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

package org.axiis.extras.charts.axis
{
	import com.degrafa.paint.SolidStroke;
	import com.vizsage.as3mathlib.math.alg.Complex;
	
	import mx.collections.ArrayCollection;
	
	public class SmithChartAxisData
	{
		public static var majorStroke:SolidStroke = new SolidStroke("#555555", .75, 1);
		public static var minorStroke:SolidStroke = new SolidStroke("#999999", .75, 1);

		//z0  - resistance
		//r   - arc radius for circles radiating out leftward
		//sp0 - start point of the arc in smith chart coordinates (the imaginary part will be inverted to calculate ep0)
		//r1  - radius of arcs radiating upward and downward
		//sp1 - start point of the arcs going upward and downward in smith chart coordinates
		//ep1 - end point of the arcs going upward and downward in smith chart coordinates
		//stroke0 - the stroke to use when drawing this arc
		//note: all radii are scaled for a chart radius of 1000
		public static var arcData:ArrayCollection = new ArrayCollection( [
			{z0:50,  r:19.60784313725486, sp0: new Complex(40,50), r1:20, sp1: new Complex(0,50), ep1: new Complex(Number.MAX_VALUE-1,0), stroke0:majorStroke},
			{z0:40,  r:24.39024390243906, sp0: new Complex(40,50), r1:25, sp1: new Complex(0,40), ep1: new Complex(50,40), stroke0:minorStroke},
			{z0:30,  r:32.25806451612908, sp0: new Complex(30,50), r1:33.333333333333336, sp1: new Complex(0,30), ep1: new Complex(50,30), stroke0:minorStroke},
			{z0:20,  r:47.61904761904759, sp0: new Complex(20,50), r1:50, sp1: new Complex(0,20), ep1: new Complex(50,20), stroke0:majorStroke},
			{z0:18,  r:52.63157894736844, sp0: new Complex(18,20), r1:55.55555555555555, sp1: new Complex(0,18), ep1: new Complex(20,18), stroke0:minorStroke},
			{z0:16,  r:58.82352941176469, sp0: new Complex(16,20), r1:62.5, sp1: new Complex(0,16), ep1: new Complex(20,16), stroke0:minorStroke},
			{z0:14,  r:66.66666666666663, sp0: new Complex(14,20), r1:71.42857142857143, sp1: new Complex(0,14), ep1: new Complex(20,14), stroke0:minorStroke},
			{z0:12,  r:76.9230769230769, sp0: new Complex(12,20), r1:83.33333333333333, sp1: new Complex(0,12), ep1: new Complex(20,12), stroke0:minorStroke},
			{z0:10,  r:90.90909090909088, sp0: new Complex(10,50), r1:100, sp1: new Complex(0,10), ep1: new Complex(50,10), stroke0:majorStroke},
			{z0:9,   r:100, sp0: new Complex(9,10), r1:111.1111111111111, sp1: new Complex(0,9), ep1: new Complex(10,9), stroke0:minorStroke},
			{z0:8,   r:111.1111111111110, sp0: new Complex(8,20), r1:125, sp1: new Complex(0,8), ep1: new Complex(20,8), stroke0:minorStroke},
			{z0:7,   r:125, sp0: new Complex(7,10), r1:142.85714285714286, sp1: new Complex(0,7), ep1: new Complex(10,7), stroke0:minorStroke},
			{z0:6,   r:142.8571428571428, sp0: new Complex(6,20), r1:166.66666666666666, sp1: new Complex(0,6), ep1: new Complex(20,6), stroke0:minorStroke},
			{z0:5,   r:166.6666666666666, sp0: new Complex(5,10), r1:200, sp1: new Complex(0,5), ep1: new Complex(10,5), stroke0:majorStroke},
			{z0:4.8, r:172.4137931034483, sp0: new Complex(4.8,5), r1:208.33333333333334, sp1: new Complex(0,4.8), ep1: new Complex(5,4.8), stroke0:minorStroke},
			{z0:4.6, r:178.5714285714286, sp0: new Complex(4.6,5), r1:217.39130434782612, sp1: new Complex(0,4.6), ep1: new Complex(5,4.6), stroke0:minorStroke},
			{z0:4.4, r:185.1851851851851, sp0: new Complex(4.4,5), r1:227.27272727272725, sp1: new Complex(0,4.4), ep1: new Complex(5,4.4), stroke0:minorStroke},
			{z0:4.2, r:192.3076923076922, sp0: new Complex(4.2,5), r1:238.09523809523807, sp1: new Complex(0,4.2), ep1: new Complex(5,4.2), stroke0:minorStroke},
			{z0:4,   r:200, sp0: new Complex(4,20), r1:250, sp1: new Complex(0,4), ep1: new Complex(20,4), stroke0:majorStroke},
			{z0:3.8, r:208.3333333333333, sp0: new Complex(3.8,5), r1:263.1578947368421, sp1: new Complex(0,3.8), ep1: new Complex(5,3.8), stroke0:minorStroke},
			{z0:3.6, r:217.3913043478260, sp0: new Complex(3.6,5), r1:277.77777777777777, sp1: new Complex(0,3.6), ep1: new Complex(5,3.6), stroke0:minorStroke},
			{z0:3.4, r:227.2727272727273, sp0: new Complex(3.4,5), r1:294.11764705882354, sp1: new Complex(0,3.4), ep1: new Complex(5,3.4), stroke0:minorStroke},
			{z0:3.2, r:238.0952380952380, sp0: new Complex(3.2,5), r1:312.5, sp1: new Complex(0,3.2), ep1: new Complex(5,3.2), stroke0:minorStroke},
			{z0:3,   r:250, sp0: new Complex(3,10), r1:333.3333333333333, sp1: new Complex(0,3), ep1: new Complex(10,3), stroke0:majorStroke},
			{z0:2.8, r:263.1578947368421, sp0: new Complex(2.8,5), r1:357.14285714285717, sp1: new Complex(0,2.8), ep1: new Complex(5,2.8), stroke0:minorStroke},
			{z0:2.6, r:277.7777777777777, sp0: new Complex(2.6,5), r1:384.6153846153846, sp1: new Complex(0,2.6), ep1: new Complex(5,2.6), stroke0:minorStroke},
			{z0:2.4, r:294.1176470588235, sp0: new Complex(2.4,5), r1:416.6666666666667, sp1: new Complex(0,2.4), ep1: new Complex(5,2.4), stroke0:minorStroke},
			{z0:2.2, r:312.5, sp0: new Complex(2.2,5), r1:454.5454545454545, sp1: new Complex(0,2.2), ep1: new Complex(5,2.2), stroke0:minorStroke},
			{z0:2,   r:333.3333333333333, sp0: new Complex(2,20), r1:500, sp1: new Complex(0,2), ep1: new Complex(20,2), stroke0:majorStroke},
			{z0:1.9, r:344.8275862068965, sp0: new Complex(1.9,2), r1:526.3157894736842, sp1: new Complex(0,1.9), ep1: new Complex(2,1.9), stroke0:minorStroke},
			{z0:1.8, r:357.1428571428571, sp0: new Complex(1.8,5), r1:555.5555555555555, sp1: new Complex(0,1.8), ep1: new Complex(5,1.8), stroke0:majorStroke},
			{z0:1.7, r:370.3703703703704, sp0: new Complex(1.7,2), r1:588.2352941176471, sp1: new Complex(0,1.7), ep1: new Complex(2,1.7), stroke0:minorStroke},
			{z0:1.6, r:384.6153846153846, sp0: new Complex(1.6,5), r1:625, sp1: new Complex(0,1.6), ep1: new Complex(5,1.6), stroke0:majorStroke},
			{z0:1.5, r:400, sp0: new Complex(1.5,2), r1:666.6666666666666, sp1: new Complex(0,1.5), ep1: new Complex(2,1.5), stroke0:minorStroke},
			{z0:1.4, r:416.6666666666667, sp0: new Complex(1.4,5), r1:714.2857142857143, sp1: new Complex(0,1.4), ep1: new Complex(5,1.4), stroke0:majorStroke},
			{z0:1.3, r:434.7826086956521, sp0: new Complex(1.3,2), r1:769.2307692307692, sp1: new Complex(0,1.3), ep1: new Complex(2,1.3), stroke0:minorStroke},
			{z0:1.2, r:454.5454545454545, sp0: new Complex(1.2,5), r1:833.3333333333334, sp1: new Complex(0,1.2), ep1: new Complex(5,1.2), stroke0:majorStroke},
			{z0:1.1, r:476.1904761904761, sp0: new Complex(1.1,2), r1:909.090909090909, sp1: new Complex(0,1.1), ep1: new Complex(2,1.1), stroke0:minorStroke},
			{z0:1,   r:500, sp0: new Complex(1,10), r1:1000, sp1: new Complex(0,1), ep1: new Complex(10,1), stroke0:majorStroke},
			{z0:0.95,r:512.8205128205128, sp0: new Complex(.95,1), r1:1052.6315789473683, sp1: new Complex(0,.95), ep1: new Complex(1,.95), stroke0:minorStroke},
			{z0:0.9, r:526.3157894736842, sp0: new Complex(.9,2), r1:1111.111111111111, sp1: new Complex(0,.9), ep1: new Complex(2,.9), stroke0:majorStroke},
			{z0:0.85,r:540.5405405405405, sp0: new Complex(.85,1), r1:1176.4705882352941, sp1: new Complex(0,.85), ep1: new Complex(1,.85), stroke0:minorStroke},
			{z0:0.8, r:555.5555555555555, sp0: new Complex(.8,5), r1:1250, sp1: new Complex(0,.8), ep1: new Complex(5,.8), stroke0:majorStroke},
			{z0:0.75,r:571.4285714285714, sp0: new Complex(.75,1), r1:1333.3333333333333, sp1: new Complex(0,.75), ep1: new Complex(1,.75), stroke0:minorStroke},
			{z0:0.7, r:588.2352941176471, sp0: new Complex(.7,2), r1:1428.5714285714287, sp1: new Complex(0,.7), ep1: new Complex(2,.7), stroke0:majorStroke},
			{z0:0.65,r:606.060606060606, sp0: new Complex(.65,1), r1:1538.4615384615383, sp1: new Complex(0,.65), ep1: new Complex(1,.65), stroke0:minorStroke},
			{z0:0.6, r:625, sp0: new Complex(.6,5), r1:1666.6666666666667, sp1: new Complex(0,.6), ep1: new Complex(5,.6), stroke0:majorStroke},
			{z0:0.55,r:645.1612903225806, sp0: new Complex(.55,1), r1:1818.181818181818, sp1: new Complex(0,.55), ep1: new Complex(1,.55), stroke0:minorStroke},
			{z0:0.5, r:666.6666666666666, sp0: new Complex(.5,2), r1:2000, sp1: new Complex(0,.5), ep1: new Complex(2,.5), stroke0:majorStroke},
			{z0:0.48,r:675.6756756756756, sp0: new Complex(.48,.5), r1:2083.3333333333335, sp1: new Complex(0,.48), ep1: new Complex(.5,.48), stroke0:minorStroke},
			{z0:0.46,r:684.9315068493152, sp0: new Complex(.46,.5), r1:2173.9130434782605, sp1: new Complex(0,.46), ep1: new Complex(.5,.46), stroke0:minorStroke},
			{z0:0.44,r:694.4444444444445, sp0: new Complex(.44,.5), r1:2272.727272727273, sp1: new Complex(0,.44), ep1: new Complex(.5,.44), stroke0:minorStroke},
			{z0:0.42,r:704.2253521126761, sp0: new Complex(.42,.5), r1:2380.9523809523807, sp1: new Complex(0,.42), ep1: new Complex(.5,.42), stroke0:minorStroke},
			{z0:0.4, r:714.2857142857143, sp0: new Complex(.4,5), r1:2500, sp1: new Complex(0,.4), ep1: new Complex(5,.4), stroke0:majorStroke},
			{z0:0.38,r:724.6376811594203, sp0: new Complex(.38,.5), r1:2631.5789473684213, sp1: new Complex(0,.38), ep1: new Complex(.5,.38), stroke0:minorStroke},
			{z0:0.36,r:735.2941176470588, sp0: new Complex(.36,.5), r1:2777.777777777778, sp1: new Complex(0,.36), ep1: new Complex(.5,.36), stroke0:minorStroke},
			{z0:0.34,r:746.2686567164178, sp0: new Complex(.34,.5), r1:2941.176470588235, sp1: new Complex(0,.34), ep1: new Complex(.5,.34), stroke0:minorStroke},
			{z0:0.32,r:757.5757575757575, sp0: new Complex(.32,.5), r1:3125, sp1: new Complex(0,.32), ep1: new Complex(.5,.32), stroke0:minorStroke},
			{z0:0.3, r:769.2307692307693, sp0: new Complex(.3,2), r1:3333.3333333333335, sp1: new Complex(0,.3), ep1: new Complex(2,.3), stroke0:majorStroke},
			{z0:0.28,r:781.25, sp0: new Complex(.28,.5), r1:3571.428571428571, sp1: new Complex(0,.28), ep1: new Complex(.5,.28), stroke0:minorStroke},
			{z0:0.26,r:793.6507936507937, sp0: new Complex(.26,.5), r1:3846.1538461538457, sp1: new Complex(0,.26), ep1: new Complex(.5,.26), stroke0:minorStroke},
			{z0:0.24,r:806.4516129032259, sp0: new Complex(.24,.5), r1:4166.666666666667, sp1: new Complex(0,.24), ep1: new Complex(.5,.24), stroke0:minorStroke},
			{z0:0.22,r:819.672131147541, sp0: new Complex(.22,.5), r1:4545.454545454546, sp1: new Complex(0,.22), ep1: new Complex(.5,.22), stroke0:minorStroke},
			{z0:0.2, r:833.3333333333334, sp0: new Complex(.2,5), r1:5000, sp1: new Complex(0,.2), ep1: new Complex(5,.2), stroke0:majorStroke},
			{z0:0.19,r:840.3361344537816, sp0: new Complex(.19,.2), r1:5263.1578947368425, sp1: new Complex(0,.19), ep1: new Complex(.2,.19), stroke0:minorStroke},
			{z0:0.18,r:847.457627118644, sp0: new Complex(.18,.5), r1:5555.555555555556, sp1: new Complex(0,.18), ep1: new Complex(.5,.18), stroke0:minorStroke},
			{z0:0.17,r:854.7008547008547, sp0: new Complex(.17,.2), r1:5882.35294117647, sp1: new Complex(0,.17), ep1: new Complex(.2,.17), stroke0:minorStroke},
			{z0:0.16,r:862.0689655172414, sp0: new Complex(.16,.5), r1:6250, sp1: new Complex(0,.16), ep1: new Complex(.5,.16), stroke0:minorStroke},
			{z0:0.15,r:869.5652173913044, sp0: new Complex(.15,.2), r1:6666.666666666667, sp1: new Complex(0,.15), ep1: new Complex(.2,.15), stroke0:minorStroke},
			{z0:0.14,r:877.1929824561403, sp0: new Complex(.14,.5), r1:7142.857142857142, sp1: new Complex(0,.14), ep1: new Complex(.5,.14), stroke0:minorStroke},
			{z0:0.13,r:884.9557522123894, sp0: new Complex(.13,.2), r1:7692.3076923076915, sp1: new Complex(0,.13), ep1: new Complex(.2,.13), stroke0:minorStroke},
			{z0:0.12,r:892.8571428571429, sp0: new Complex(.12,.5), r1:8333.333333333334, sp1: new Complex(0,.12), ep1: new Complex(.5,.12), stroke0:minorStroke},
			{z0:0.11,r:900.9009009009009, sp0: new Complex(.11,.2), r1:9090.909090909092, sp1: new Complex(0,.11), ep1: new Complex(.2,.11), stroke0:minorStroke},
			{z0:0.1, r:909.090909090909, sp0: new Complex(.1,2), r1:10000, sp1: new Complex(0,.1), ep1: new Complex(2,.1), stroke0:majorStroke},
			{z0:0.09,r:917.4311926605504, sp0: new Complex(.09,.2), r1:11111.111111111111, sp1: new Complex(0,.09), ep1: new Complex(.2,.09), stroke0:minorStroke},
			{z0:0.08,r:925.9259259259259, sp0: new Complex(.08,.5), r1:12500, sp1: new Complex(0,.08), ep1: new Complex(.5,.08), stroke0:minorStroke},
			{z0:0.07,r:934.5794392523364, sp0: new Complex(.07,.2), r1:14285.714285714284, sp1: new Complex(0,.07), ep1: new Complex(.2,.07), stroke0:minorStroke},
			{z0:0.06,r:943.3962264150944, sp0: new Complex(.06,.5), r1:16666.666666666668, sp1: new Complex(0,.06), ep1: new Complex(.5,.06), stroke0:minorStroke},
			{z0:0.05,r:952.3809523809523, sp0: new Complex(.05,.2), r1:20000, sp1: new Complex(0,.05), ep1: new Complex(.2,.05), stroke0:minorStroke},
			{z0:0.04,r:961.5384615384614, sp0: new Complex(.04,.5), r1:25000, sp1: new Complex(0,.04), ep1: new Complex(.5,.04), stroke0:minorStroke},
			{z0:0.03,r:970.8737864077669, sp0: new Complex(.03,.2), r1:33333.333333333336, sp1: new Complex(0,.03), ep1: new Complex(.2,.03), stroke0:minorStroke},
			{z0:0.02,r:980.3921568627451, sp0: new Complex(.02,.5), r1:50000, sp1: new Complex(0,.02), ep1: new Complex(.5,.02), stroke0:minorStroke},
			{z0:0.01,r:990.09900990099, sp0: new Complex(.01,.2), r1:100000, sp1: new Complex(0,.01), ep1: new Complex(.2,.01), stroke0:minorStroke},]
			);
		
	}
}