package net.fpp.starlingtdleveleditor
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
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
			this.x = 5;
			this.y = 5;

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

		public function addElement( id:String, name:String, iconImageSrc:String, isSelectable:Boolean ):void
		{
			var button:IconButton = new IconButton(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					iconImageSrc,
					SkinManager.getSkin( CSkinAsset.BUTTON_SELECTED_STATE ),
					25,
					25
			);

			button.tabEnabled = false;
			button.isSelectable = isSelectable;
			button.data = id;
			button.addEventListener( MouseEvent.CLICK, this.onButtonClickedHandler );

			this._buttonContainer.addChild( button );

			this.setSize();
		}

		private function onButtonClickedHandler( e:MouseEvent ):void
		{
			var selectedButton:IconButton = ( e.currentTarget as IconButton );

			if( selectedButton.isSelectable )
			{
				for( var i:int = 0; i < this._buttonContainer.numChildren; i++ )
				{
					var button:IconButton = this._buttonContainer.getChildAt( i ) as IconButton;

					if( button == selectedButton )
					{
						button.isSelected = true;
					}
					else
					{
						button.isSelected = false;
					}
				}
			}

			this.dispatchEvent( new MenuEvent( MenuEvent.CHANGE_CONTROLLER, selectedButton.data as String ) );
		}
	}
}