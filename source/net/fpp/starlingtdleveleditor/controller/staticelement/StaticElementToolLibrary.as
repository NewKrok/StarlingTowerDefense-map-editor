/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIGrid;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.controller.staticelement.events.StaticElementToolLibraryEvent;

	public class StaticElementToolLibrary extends Sprite
	{
		private const _padding:Number = 5;

		private var _library:UIGrid;

		private var _background:DisplayObject;

		public function StaticElementToolLibrary()
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._library = new UIGrid( 4, new SimplePoint( 75, 75 ) );
			this._library.gap = 5;
			this._library.isBorderEnabled = true;

			this.addElement( 'crater_0' );
			this.addElement( 'crater_1' );
			this.addElement( 'crater_2' );
			this.addElement( 'crater_3' );
			this.addElement( 'crater_4' );

			this._library.x = this._padding;
			this._library.y = this._padding;

			this.addChild( this._library );

			this.resize();
		}

		private function addElement( elementName:String ):void
		{
			var staticElementMenuItem:StaticElementMenuItem = new StaticElementMenuItem( elementName );

			staticElementMenuItem.addEventListener( MouseEvent.CLICK, this.toogleElementSelection );

			this._library.addChild( staticElementMenuItem );
		}

		private function toogleElementSelection( e:MouseEvent ):void
		{
			var staticElementMenuItem:StaticElementMenuItem = e.currentTarget as StaticElementMenuItem;

			var isStaticElementMenuItemSelected:Boolean = staticElementMenuItem.isSelected;

			this.deselectAllElement();

			staticElementMenuItem.isSelected = !isStaticElementMenuItemSelected;

			if( staticElementMenuItem.isSelected )
			{
				this.dispatchEvent( new StaticElementToolLibraryEvent( StaticElementToolLibraryEvent.ELEMENT_SELECTED, staticElementMenuItem.elementName ) );
			}
			else
			{
				this.dispatchEvent( new StaticElementToolLibraryEvent( StaticElementToolLibraryEvent.ELEMENT_DESELECTED ) );
			}
		}

		public function deselectAllElement():void
		{
			var length:int = this._library.numChildren;

			for( var i:int = 0; i < length; i++ )
			{
				var staticElementMenuItem:StaticElementMenuItem = this._library.getChildAt( i ) as StaticElementMenuItem;

				staticElementMenuItem.isSelected = false;
			}
		}

		public function resize():void
		{
			this._background.width = this._library.width + this._padding * 2;
			this._background.height = this._library.height + this._padding * 2;
		}
	}
}