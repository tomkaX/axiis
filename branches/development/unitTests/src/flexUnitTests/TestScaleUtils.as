package flexUnitTests
{
	import flexunit.framework.TestCase;
	
	import org.axiis.layouts.scale.ScaleUtils;
	
	public class TestScaleUtils extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		// Reference declaration for class to test
		private var classToTestRef : org.axiis.layouts.scale.ScaleUtils;
		
		public function TestScaleUtils(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		
		//This method will be called before every test function
		override public function setUp():void
		{
			//TODO: implement function
			super.setUp();
		}
		
		//This method will be called after every test function
		override public function tearDown():void
		{
			//TODO: implement function
			super.tearDown();
		}
		
		public function testInverseLerp():void
		{
			assertEquals(ScaleUtils.inverseLerp(15,10,20),.5);
			
			assertEquals(ScaleUtils.inverseLerp(-15,-20,-10),.5);
			
			assertEquals(ScaleUtils.inverseLerp(0,-20,20),.5);
		}
		
		public function testLerp():void
		{
			assertEquals(ScaleUtils.lerp(.5,10,20),15);
			
			assertEquals(ScaleUtils.lerp(.5,-20,-10),-15);
			
			assertEquals(ScaleUtils.lerp(.5,-20,20),0);
		}
	}
}