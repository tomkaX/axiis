package flexUnitTests
{
	import flexunit.framework.TestSuite;
	
	public class TestScales extends TestSuite
	{
		public function TestScales(param:Object=null)
		{
			super(param);
		}
		
		// this method shall be called when this suite is selected for running.
		public static function suite():TestSuite
		{
			var newTestSuite:TestSuite = new TestSuite();
			newTestSuite.addTest(new TestScaleUtils());
			newTestSuite.addTest(new TestAbstractScale());
			newTestSuite.addTest(new TestLinearScale());
			return newTestSuite;
		}
	}
}