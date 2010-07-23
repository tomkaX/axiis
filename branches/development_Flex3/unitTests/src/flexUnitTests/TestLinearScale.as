package flexUnitTests
{
	import flexunit.framework.TestCase;
	
	import org.axiis.layouts.scale.LinearScale;
	
	public class TestLinearScale extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		// Reference declaration for class to test
		private var classToTestRef : org.axiis.layouts.scale.LinearScale;
		
		private var scale:LinearScale;
		
		public function TestLinearScale(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		
		//This method will be called before every test function
		override public function setUp():void
		{
			//TODO: implement function
			super.setUp();
			
			scale = new LinearScale();
		}
		
		//This method will be called after every test function
		override public function tearDown():void
		{
			//TODO: implement function
			super.tearDown();
			
			scale = null;
		}
		
		public function testComputedValues():void
		{
			scale.dataProvider = [1,2,3,4,5];
			assertEquals(scale.computedMinValue,1);
			assertEquals(scale.computedMaxValue,5);
			assertEquals(scale.computedSum,15);
			assertEquals(scale.computedAverage,3);
			assertEquals(scale.minValue,scale.computedMinValue);
			assertEquals(scale.maxValue,scale.computedMaxValue);
		}
		
		public function testNegativeComputedValues():void
		{
			scale.dataProvider = [-3,-2,-1,0,1,2,3];
			assertEquals(scale.computedMinValue,-3);
			assertEquals(scale.computedMaxValue,3);
			assertEquals(scale.computedSum,0);
			assertEquals(scale.computedAverage,0);
			assertEquals(scale.minValue,scale.computedMinValue);
			assertEquals(scale.maxValue,scale.computedMaxValue);
		}
		
		public function testEmptyDataProviderYieldsNaNComputedValues():void
		{
			scale.dataProvider = [];
			assertTrue(isNaN(scale.computedMinValue));
			assertTrue(isNaN(scale.computedMaxValue));
			assertTrue(isNaN(scale.computedSum));
			assertTrue(isNaN(scale.computedAverage));
			assertTrue(isNaN(scale.minValue));
			assertTrue(isNaN(scale.maxValue));
		}
		
		public function testUserValuesOverwriteComputed():void
		{
			scale.dataProvider = [1,2,3,4,5];
			assertEquals(scale.computedMinValue,1);
			assertEquals(scale.computedMaxValue,5);
			assertEquals(scale.minValue,1);
			assertEquals(scale.maxValue,5);
			scale.minValue = 0;
			scale.maxValue = 10;
			assertEquals(scale.computedMinValue,1);
			assertEquals(scale.computedMaxValue,5);
			assertEquals(scale.minValue,0);
			assertEquals(scale.maxValue,10);
		}
		
		public function testUnsetRangesYieldNaN():void
		{
			assertTrue(isNaN(scale.minValue));
			assertTrue(isNaN(scale.maxValue));
			assertTrue(isNaN(scale.minLayout));
			assertTrue(isNaN(scale.maxLayout));
			assertTrue(isNaN(scale.valueToLayout(5)));
			assertTrue(isNaN(scale.layoutToValue(5)));
			
			scale.minValue = 1;
			assertTrue(isNaN(scale.valueToLayout(5)));
			assertTrue(isNaN(scale.layoutToValue(5)));
			
			scale.maxValue = 5;
			assertTrue(isNaN(scale.valueToLayout(5)));
			assertTrue(isNaN(scale.layoutToValue(5)));
			
			scale.minLayout = 1;
			assertTrue(isNaN(scale.valueToLayout(5)));
			assertTrue(isNaN(scale.layoutToValue(5)));
			
			scale.maxLayout = 5;
			
			// Only once all four values are initialized should the conversion methods work
			assertFalse(isNaN(scale.valueToLayout(5)));
			assertFalse(isNaN(scale.layoutToValue(5)));
		}
		
		public function testClamp():void
		{
			scale.minValue = 1;
			scale.maxValue = 5;
			scale.minLayout = 1;
			scale.maxLayout = 5;
			
			assertTrue(scale.valueToLayout(-1,false,false) < 0);
			assertTrue(scale.valueToLayout(-1,false,true) == 1);
			assertTrue(scale.valueToLayout(6,false,false) > 5);
			assertTrue(scale.valueToLayout(6,false,true) == 5);
			
			assertTrue(scale.layoutToValue(-1,false,false) < 0);
			assertTrue(scale.layoutToValue(-1,false,true) == 1);
			assertTrue(scale.layoutToValue(6,false,false) > 5);
			assertTrue(scale.layoutToValue(6,false,true) == 5);
		}
		
		public function testInvert():void
		{
			scale.minValue = 1;
			scale.maxValue = 5;
			scale.minLayout = 10;
			scale.maxLayout = 50;
			
			assertTrue(scale.valueToLayout(1,false) == 10);
			assertTrue(scale.valueToLayout(1,true) == 50);
			
			assertTrue(scale.layoutToValue(10,false) == 1);
			assertTrue(scale.layoutToValue(10,true) == 5);
		}
		
		public function testInvertClamp():void
		{
			scale.minValue = 0;
			scale.maxValue = 1;
			scale.minLayout = 0;
			scale.maxLayout = 100;
			
			var test:Number = scale.valueToLayout(-1,true,false);
			assertTrue(test == 200);
			test = scale.valueToLayout(-1,true,true);
			assertTrue(test == 100);
			test = scale.valueToLayout(2,true,false);
			assertTrue(test == -100);
			test = scale.valueToLayout(2,true,true);
			assertTrue(test == 0);
		}
	}
}