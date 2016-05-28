/**
 * Created by newkrok on 28/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.fpp.common.display.UIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;

	public class EnemyPathToolMenu extends Sprite
	{
		private const _padding:Number = 5;

		private var _background:DisplayObject;
		private var _container:UIBox;

		public function EnemyPathToolMenu()
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._container = new UIBox();
			this._container.gap = 5;
			this.addChild( this._container );

			this.createTitle();

			this._background.width = this.width + _padding * 2;
			this._background.height = this.height + _padding * 2;

			this._container.x = _padding;
			this._container.y = _padding;
		}

		private function createTitle():void
		{
			var textField:TextField = new TextField();

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 11;
			textFormat.color = 0x0;
			textFormat.font = 'Verdana';

			textField.defaultTextFormat = textFormat;

			textField.mouseEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = 'Enemy Paths';

			this._container.addChild( textField );
		}

		public function enable():void
		{
		}

		public function disable():void
		{
		}

		public function setEnemyPaths( enemyPaths:Vector.<EnemyPathVO> ):void
		{
			this.clearEnemyPaths();

			for ( var i:int = 0; i < enemyPaths.length; i++ )
			{
				this._container.addChild( new EnemyPathEntryView( enemyPaths[i] ) );
			}

			this._background.width = this._container.width + _padding * 2;
			this._background.height = this._container.height + _padding * 2;
		}

		private function clearEnemyPaths():void
		{
			while ( this._container.numChildren > 1 )
			{
				this._container.removeChildAt( 1 );
			}
		}
	}
}