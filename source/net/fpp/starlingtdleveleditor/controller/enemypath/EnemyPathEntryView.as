/**
 * Created by newkrok on 28/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;

	import net.fpp.common.display.HUIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.component.Button;
	import net.fpp.starlingtdleveleditor.controller.enemypath.events.EnemyPathToolMenuEvent;

	public class EnemyPathEntryView extends HUIBox
	{
		public var enemyPathVO:EnemyPathVO;

		private var _textField:TextField;
		private var _removeButton:Button;

		public function EnemyPathEntryView( enemyPathVO:EnemyPathVO )
		{
			this.enemyPathVO = enemyPathVO;

			this.verticalAlign = VERTICAL_ALIGN_MIDDLE;
			this.gap = 5;

			this.createRemoveButton();
			this._removeButton.addEventListener( MouseEvent.CLICK, this.onClickOnRemoveButtonHandler );

			this.createTitle();
			this._textField.addEventListener( MouseEvent.CLICK, this.onClickOnTextFieldHandler );
			this._textField.addEventListener( Event.CHANGE, this.onChangeOnTextFieldHandler );
			this._textField.addEventListener( FocusEvent.FOCUS_OUT, this.onFocusOutTextFieldHandler );
			this._textField.addEventListener( KeyboardEvent.KEY_UP, this.onKeyUpOnTextFieldHandler );
		}

		private function createRemoveButton():void
		{
			this._removeButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'X'
			);
			this._removeButton.tabEnabled = false;
			this._removeButton.width = 20;
			this.addChild( this._removeButton );
		}

		private function onClickOnRemoveButtonHandler( e:MouseEvent ):void
		{
			this.dispatchEvent( new EnemyPathToolMenuEvent( EnemyPathToolMenuEvent.REMOVE_REQUEST, this.enemyPathVO ) );
		}

		private function createTitle():void
		{
			this._textField = new TextField();

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 11;
			textFormat.color = 0x0;
			textFormat.font = 'Verdana';
			textFormat.align = TextFormatAlign.LEFT;

			this._textField.defaultTextFormat = textFormat;

			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.text = this.enemyPathVO.name;
			this._textField.type = TextFieldType.INPUT;
			this._textField.background = true;
			this._textField.restrict = 'A-Za-z0-9';
			this._textField.maxChars = 20;

			this.addChild( this._textField );
		}

		private function onClickOnTextFieldHandler( e:MouseEvent ):void
		{
			this.selectTextField();
		}

		private function selectTextField():void
		{
			this._textField.setSelection( 0, this._textField.length );
		}

		private function onFocusOutTextFieldHandler( e:FocusEvent ):void
		{
			this.rename();
		}

		private function onChangeOnTextFieldHandler( e:Event ):void
		{
			this.dispatchEvent( new EnemyPathToolMenuEvent( EnemyPathToolMenuEvent.RESIZE_REQUEST ) );
		}

		private function onKeyUpOnTextFieldHandler( e:KeyboardEvent ):void
		{
			if( e.charCode == Keyboard.ENTER )
			{
				this.rename();
			}
		}

		private function rename():void
		{
			this.dispatchEvent( new EnemyPathToolMenuEvent( EnemyPathToolMenuEvent.RENAME_REQUEST, this._textField.text ) );
		}

		public function refreshView():void
		{
			this._textField.text = this.enemyPathVO.name;

			this.selectTextField();
		}
	}
}