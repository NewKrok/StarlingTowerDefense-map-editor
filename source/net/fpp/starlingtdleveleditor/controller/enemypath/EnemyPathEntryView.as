/**
 * Created by newkrok on 28/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.fpp.common.display.UIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.component.Button;

	public class EnemyPathEntryView extends UIBox
	{
		private var _enemyPathVO:EnemyPathVO;

		private var _textField:TextField;
		private var _renameButton:Button;
		private var _removeButton:Button;

		public function EnemyPathEntryView( enemyPathVO:EnemyPathVO )
		{
			this._enemyPathVO = enemyPathVO;

			this.orderType = HORIZONTAL_ORDER;
			this.gap = 5;

			this.createTitle();
			this.createRenameButton();
			this.createRemoveButton();
		}

		private function createTitle():void
		{
			this._textField = new TextField();

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 11;
			textFormat.color = 0x0;
			textFormat.font = 'Verdana';

			this._textField.defaultTextFormat = textFormat;

			this._textField.mouseEnabled = false;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.text = this._enemyPathVO.name;

			this.addChild( this._textField );
		}

		private function createRenameButton():void
		{
			this._renameButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'RENAME'
			);
			this._renameButton.width = 75;
			this.addChild( this._renameButton );
		}

		private function createRemoveButton():void
		{
			this._removeButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'X'
			);
			this._removeButton.width = 20;
			this.addChild( this._removeButton );
		}
	}
}