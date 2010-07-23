package flexUnitTests
{
	import flexunit.framework.TestCase;
	
	import org.axiis.layouts.scale.AbstractScale;
	
	public class TestAbstractScale extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		// Reference declaration for class to test
		private var classToTestRef : org.axiis.layouts.scale.AbstractScale;
		
		private var scale:AbstractScale;
		
		public function TestAbstractScale(methodName:String=null)
		{
			super(methodName);
		}
		
		//This method will be called before every test function
		override public function setUp():void
		{
			super.setUp();
			
			scale = new AbstractScale();
		}
		
		//This method will be called after every test function
		override public function tearDown():void
		{
			super.tearDown();
			
			scale = null;
		}
		
		public function testSetDataProviderCausesInvalidate():void
		{
			// Add your test logic here
			assertFalse(scale.invalidated);
			scale.dataProvider = [1,2,3];
			assertTrue(scale.invalidated);
		}
		
		public function testInvalidateAndValidate():void
		{
			scale.invalidate();
			assertTrue(scale.invalidated);
			scale.validate();
			assertFalse(scale.invalidated);
		}
	}
}