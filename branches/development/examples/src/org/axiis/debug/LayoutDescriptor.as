package org.axiis.debug
{
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	
	import org.axiis.core.AxiisSprite;
	import org.axiis.core.ILayout;
	import org.axiis.core.PropertySetter;
	
	public class LayoutDescriptor implements ITreeDataDescriptor
	{
		public function LayoutDescriptor()
		{
			super();
		}
		
		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			if(node is ILayout)
			{
				var childSprites:ArrayCollection = new ArrayCollection(ILayout(node).childSprites);
				var layouts:ArrayCollection = new ArrayCollection(ILayout(node).layouts);
				var r:ArrayCollection = new ArrayCollection();
				r.addAll(layouts);
				r.addAll(childSprites);
				return r;
			}
			if(node is AxiisSprite)
			{
				var layoutChildren:ArrayCollection = new ArrayCollection(AxiisSprite(node).layoutSprites);
				var drawingChildren:ArrayCollection = new ArrayCollection(AxiisSprite(node).drawingSprites);
				var revertingModifications:ArrayCollection = new ArrayCollection(AxiisSprite(node).revertingModifications);
				var r:ArrayCollection = new ArrayCollection();
				r.addAll(layoutChildren);
				r.addAll(drawingChildren);
				r.addAll(revertingModifications);
				return r; 
			}
			return null;
		}
		
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			if(node is ILayout)
			{
				if(ILayout(node).layouts.length > 0)
					return true;
				if(ILayout(node).childSprites.length > 0)
					return true;
			}
			if(node is AxiisSprite)
			{
				if(AxiisSprite(node).drawingSprites.length > 0)
					return true;
				if(AxiisSprite(node).layoutSprites.length > 0)
					return true;
				if(AxiisSprite(node).revertingModifications.length > 0)
					return true;
			}
			return false;
		}
		
		public function isBranch(node:Object, model:Object=null):Boolean
		{
			return hasChildren(node,model);
		}
		
		public function getData(node:Object, model:Object=null):Object
		{
			trace(node);
			return null;
		}
		
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
	}
}