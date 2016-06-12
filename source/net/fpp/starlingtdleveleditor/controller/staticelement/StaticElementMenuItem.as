/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;

	public class StaticElementMenuItem extends Sprite
	{
		private var _isSelected:Boolean;
		private var _elementName:String;

		public function StaticElementMenuItem( elementName:String )
		{
			this._elementName = elementName;

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._elementName ) );

			this.buttonMode = true;
		}

		public function set isSelected( isSelected:Boolean ):void
		{
			this._isSelected = isSelected;

			if ( this._isSelected )
			{
				this.filters = [ new GlowFilter( 0xFFFF00, 1, 6, 6, 10 ) ];
			}
			else
			{
				this.filters = [];
			}
		}

		public function get isSelected():Boolean
		{
			return this._isSelected;
		}

		public function get elementName():String
		{
			return this._elementName;
		}
	}
}