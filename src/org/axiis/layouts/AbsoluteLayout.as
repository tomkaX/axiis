package org.axiis.layouts
{
	import org.axiis.core.BaseLayout;
	import org.axiis.core.ILayout;

	/*
		This started out as an MXML Layout with a reference repeater that
		positioned GraphicPoints absolutely, but I realized that that wasn't necessary.
		Since AbsoluteLayout is a more intuitive name for what this layout
		does, we might want to make BaseLayout no longer implement the ILayout
		interface even though it has all of the necessary methods. Proper ILayouts
		could extend BaseLayout and implement ILayout, like this class does.
	*/ 
	public class AbsoluteLayout extends BaseLayout implements ILayout
	{
		public function AbsoluteLayout()
		{
			super();
		}
		
	}
}