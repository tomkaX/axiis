package org.axiis.layouts
{
	import org.axiis.core.BaseLayout;
	import org.axiis.core.ILayout;

	/**
	 * AbsoluteLayout is a layout which does not have reference geometries.
	 * AbsoluteLayouts can be used when you want to produce visualizations that
	 * has its drawingGeometries positioned without respect to an references.
	 */
	public class AbsoluteLayout extends BaseLayout implements ILayout
	{
		/**
		 * Constructor.
		 */
		public function AbsoluteLayout()
		{
			super();
		}
	}
}