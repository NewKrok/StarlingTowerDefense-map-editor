/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.display.Sprite;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.starlingtdleveleditor.component.DisplayObjectTransformTool;

	public class StaticElementView extends Sprite
	{
		private var _elementName:String;

		private var _displayObjectTransformTool:DisplayObjectTransformTool;

		public function StaticElementView( elementName:String )
		{
			this._elementName = elementName;

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._elementName ) );

			this._displayObjectTransformTool = new DisplayObjectTransformTool( this );

			this.buttonMode = true;
		}

		public function get elementName():String
		{
			return this._elementName;
		}
	}
}