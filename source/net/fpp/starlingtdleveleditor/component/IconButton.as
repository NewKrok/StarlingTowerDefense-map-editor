/**
 * Created by newkrok on 19/05/16.
 */
package net.fpp.starlingtdleveleditor.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;

	public class IconButton extends Button
	{
		private const SELECTED_STATE:String = 'Button.SELECTED_STATE';

		private var _iconSrc:String;
		private var _icon:DisplayObject;

		private var _selectedSkin:DisplayObject;
		private var _isSelected:Boolean = false;
		private var _isSelectable:Boolean;

		public function IconButton( upSkin:DisplayObject, downSkin:DisplayObject, iconSrc:String, selectedSkin:DisplayObject =  null, width:Number = 100, height:Number = 25 )
		{
			this._selectedSkin = selectedSkin;

			super( upSkin, downSkin, '', width, height );

			this._stateViewManifest[SELECTED_STATE] = this.updateSelectedStateView;

			this._iconSrc = iconSrc;

			this.createIcon();
			this.setPosition();
		}

		private function updateSelectedStateView():void
		{
			this._activeSkin = this._selectedSkin;
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

		public function set isSelected( value:Boolean ):void
		{
			this._isSelected = value;

			if ( this._isSelected && this._isSelectable )
			{
				this._state = SELECTED_STATE;
			}
			else
			{
				this._state = NORMAL_STATE;
			}

			this.updateView();
		}

		public function set isSelectable( value:Boolean ):void
		{
			this._isSelectable = value;

			if ( this._isSelected )
			{
				this.isSelected = false;
			}
		}

		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		override protected function mouseOverHandler( e:MouseEvent ):void
		{
			if ( this._state != SELECTED_STATE )
			{
				this._state = this.OVER_STATE;
				this.updateView();
			}
		}

		override protected function mouseOutHandler( e:MouseEvent ):void
		{
			if ( this._state != SELECTED_STATE )
			{
				this._state = this.NORMAL_STATE;
				this.updateView();
			}
		}

		override protected function updateSize():void
		{
			this._selectedSkin.width = this._width;
			this._selectedSkin.height = this._height;

			super.updateSize();
		}
	}
}