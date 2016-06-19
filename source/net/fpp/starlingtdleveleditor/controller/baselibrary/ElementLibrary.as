/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.baselibrary
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIGrid;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.controller.baselibrary.events.BaseLibraryEvent;

	public class ElementLibrary extends Sprite
	{
		private const _padding:Number = 5;

		private var _library:UIGrid;

		private var _background:DisplayObject;

		public function ElementLibrary( elementList:Vector.<String> )
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._library = new UIGrid( 4, new SimplePoint( 75, 75 ) );
			this._library.gap = 5;
			this._library.isBorderEnabled = true;
			this._library.childAutoScale = true;

			for ( var i:int = 0; i < elementList.length; i++ )
			{
				this.addElement( elementList[i] );
			}

			this._library.x = this._padding;
			this._library.y = this._padding;

			this.addChild( this._library );

			this.resize();
		}

		private function addElement( elementName:String ):void
		{
			var elementLibraryItem:ElementLibraryItem = new ElementLibraryItem( elementName );

			elementLibraryItem.addEventListener( MouseEvent.CLICK, this.toogleElementSelection );

			this._library.addChild( elementLibraryItem );
		}

		private function toogleElementSelection( e:MouseEvent ):void
		{
			var elementLibraryItem:ElementLibraryItem = e.currentTarget as ElementLibraryItem;

			var isElementLibraryItemSelected:Boolean = elementLibraryItem.isSelected;

			this.deselectAllElement();

			elementLibraryItem.isSelected = !isElementLibraryItemSelected;

			if( elementLibraryItem.isSelected )
			{
				this.dispatchEvent( new BaseLibraryEvent( BaseLibraryEvent.ELEMENT_SELECTED, elementLibraryItem.elementName ) );
			}
			else
			{
				this.dispatchEvent( new BaseLibraryEvent( BaseLibraryEvent.ELEMENT_DESELECTED ) );
			}
		}

		public function deselectAllElement():void
		{
			var length:int = this._library.numChildren;

			for( var i:int = 0; i < length; i++ )
			{
				var elementLibraryItem:ElementLibraryItem = this._library.getChildAt( i ) as ElementLibraryItem;

				elementLibraryItem.isSelected = false;
			}
		}

		public function resize():void
		{
			this._background.width = this._library.width + this._padding * 2;
			this._background.height = this._library.height + this._padding * 2;
		}
	}
}