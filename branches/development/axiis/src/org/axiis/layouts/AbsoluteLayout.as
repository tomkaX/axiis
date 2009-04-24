package org.axiis.layouts
{
	import org.axiis.layouts.BaseLayout;
	import org.axiis.core.ILayout;

	/*
		This started out as an MXML Layout with a reference repeater that
		positioned GraphicPoints absolutely, but I realized that that wasn't necessary.
		Since AbsoluteLayout is a more intuitive name for what this layout
		does, it might be worth keeping this around and using it instead of BaseLayout.
	*/ 
	public class AbsoluteLayout extends BaseLayout implements ILayout
	{
		public function AbsoluteLayout()
		{
			super();
		}
		
	}
}