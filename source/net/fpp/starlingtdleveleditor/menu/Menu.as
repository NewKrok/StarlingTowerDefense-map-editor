package net.fpp.starlingtdleveleditor.menu
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
	import net.fpp.starlingtdleveleditor.BaseUIComponent;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.component.IconButton;
	import net.fpp.starlingtdleveleditor.events.MenuEvent;

	public class Menu extends BaseUIComponent
	{
		private var _background:DisplayObject;
		private var _buttonContainer:UIBox;

		public function Menu()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.createBackground();
			this.createButtonContainer();

			this.setSize();
		}

		private function createButtonContainer():void
		{
			this._buttonContainer = new UIBox;
			this._buttonContainer.orderType = UIBox.HORIZONTAL_ORDER;
			this._buttonContainer.gap = 5;
			this.addChild( this._buttonContainer );
		}

		private function createBackground():void
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );
		}

		private function setSize():void
		{
			const padding:Number = 5;

			this._background.width = this._buttonContainer.width + padding * 2;
			this._background.height = this._buttonContainer.height + padding * 2;

			this._buttonContainer.x = padding;
			this._buttonContainer.y = padding;
		}

		public function addElement( id:String, name:String, iconImageSrc:String ):void
		{
			var button:IconButton = new IconButton(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					iconImageSrc,
					25,
					25
			);
			button.data = id;
			button.addEventListener( MouseEvent.CLICK, this.onButtonClickedHandler );

			this._buttonContainer.addChild( button );

			this.setSize();
		}

		private function onButtonClickedHandler( e:MouseEvent ):void
		{
			this.dispatchEvent( new MenuEvent( MenuEvent.CHANGE_CONTROLLER, ( e.currentTarget as IconButton ).data as String ) );
		}
	}
}