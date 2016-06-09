/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;

	import net.fpp.common.display.UIGrid;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;

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

			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_0' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_1' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_2' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_3' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_4' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_0' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_1' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_2' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_3' ) );
			this._library.addChild( StaticBitmapAssetManager.instance.getBitmap( 'crater_4' ) );

			this._library.x = this._padding;
			this._library.y = this._padding;

			this.addChild( this._library );

			this.resize();
		}

		public function resize():void
		{
			this._background.width = this._library.width + this._padding * 2;
			this._background.height = this._library.height + this._padding * 2;
		}
	}
}