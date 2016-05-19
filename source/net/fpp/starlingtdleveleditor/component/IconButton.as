/**
 * Created by newkrok on 19/05/16.
 */
package net.fpp.starlingtdleveleditor.component
{
	import flash.display.DisplayObject;

	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;

	public class IconButton extends Button
	{
		private var _iconSrc:String;
		private var _icon:DisplayObject;

		public function IconButton( upSkin:DisplayObject, downSkin:DisplayObject, iconSrc:String = '', width:Number = 100, height:Number = 25 )
		{
			super( upSkin, downSkin, '', width, height );

			this._iconSrc = iconSrc;

			this.createIcon();
			this.setPosition();
		}

		private function createIcon():void
		{
			this._icon = SkinManager.getSkin( this._iconSrc );
			this.addChild( this._icon );
		}

		private function setPosition():void
		{
			this._icon.x = this.width / 2 - this._icon.width / 2;
			this._icon.y = this.height / 2 - this._icon.height / 2;
		}
	}
}