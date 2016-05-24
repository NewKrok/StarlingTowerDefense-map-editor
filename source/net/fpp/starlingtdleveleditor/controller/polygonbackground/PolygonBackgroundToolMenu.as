/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygonbackground
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.component.Button;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.events.PolygonBackgroundToolMenuEvent;

	public class PolygonBackgroundToolMenu extends Sprite
	{
		private var _background:DisplayObject;
		private var _container:UIBox;

		private var _deleteButton:Button;
		private var _bringForwardButton:Button;
		private var _sendBackwardButton:Button;
		private var _closeButton:Button;
		private var _terrainTextureGrid:PolygonBackgroundTerrainTextureGrid;

		public function PolygonBackgroundToolMenu()
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._container = new UIBox();
			this._container.gap = 5;
			this.addChild( this._container );

			this.createTerrainTextureContainer();

			var arrangeButtonContainer:Sprite = new Sprite();
			this._container.addChild( arrangeButtonContainer );

			arrangeButtonContainer.addChild( this.createBringForwardButton() );
			arrangeButtonContainer.addChild( this.createSendBackwardButton() );

			this.createCloseButton();
			this.createDeleteButton();

			var arrangeButtonContainerGap:Number = 5;
			this._bringForwardButton.width = this.width / 2 - arrangeButtonContainerGap / 2;
			this._sendBackwardButton.width = this._bringForwardButton.width;
			this._sendBackwardButton.x = this._bringForwardButton.width + arrangeButtonContainerGap;

			this._closeButton.width = this.width;
			this._deleteButton.width = this.width;

			var padding:Number = 5;
			this._background.width = this.width + padding * 2;
			this._background.height = this.height + padding * 2;

			this._container.x = padding;
			this._container.y = padding;
		}

		private function createBringForwardButton():Button
		{
			this._bringForwardButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'Forward'
			);
			this._bringForwardButton.disable();

			return this._bringForwardButton;
		}

		private function createSendBackwardButton():Button
		{
			this._sendBackwardButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'Backward'
			);
			this._sendBackwardButton.disable();

			return this._sendBackwardButton;
		}

		private function createCloseButton():void
		{
			this._closeButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'Close'
			);
			this._closeButton.disable();
			this._container.addChild( this._closeButton );
		}

		private function createDeleteButton():void
		{
			this._deleteButton = new Button(
					SkinManager.getSkin( CSkinAsset.BUTTON_NORMAL_STATE ),
					SkinManager.getSkin( CSkinAsset.BUTTON_OVER_STATE ),
					'Delete'
			);
			this._deleteButton.disable();
			this._container.addChild( this._deleteButton );
		}

		private function createTerrainTextureContainer():void
		{
			this._terrainTextureGrid = new PolygonBackgroundTerrainTextureGrid();

			this._container.addChild( this._terrainTextureGrid );
		}

		public function enable():void
		{
			this._sendBackwardButton.enable();
			this._sendBackwardButton.addEventListener( MouseEvent.CLICK, this.onSendBackwardRequest );

			this._bringForwardButton.enable();
			this._bringForwardButton.addEventListener( MouseEvent.CLICK, this.onBringForwardRequest );

			this._terrainTextureGrid.enable();
			this._terrainTextureGrid.addEventListener( PolygonBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainChangeRequestHandler );

			this._closeButton.enable();
			this._closeButton.addEventListener( MouseEvent.CLICK, this.onCloseRequest );

			this._deleteButton.enable();
			this._deleteButton.addEventListener( MouseEvent.CLICK, this.onDeleteRequest );
		}

		public function disable():void
		{
			this._sendBackwardButton.disable();
			this._sendBackwardButton.removeEventListener( MouseEvent.CLICK, this.onSendBackwardRequest );

			this._bringForwardButton.disable();
			this._bringForwardButton.removeEventListener( MouseEvent.CLICK, this.onBringForwardRequest );

			this._terrainTextureGrid.disable();
			this._terrainTextureGrid.removeEventListener( PolygonBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainChangeRequestHandler );

			this._closeButton.disable();
			this._closeButton.removeEventListener( MouseEvent.CLICK, this.onCloseRequest );

			this._deleteButton.disable();
			this._deleteButton.removeEventListener( MouseEvent.CLICK, this.onDeleteRequest );
		}

		private function onTerrainChangeRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onSendBackwardRequest( e:MouseEvent ):void
		{
			this.dispatchEvent( new PolygonBackgroundToolMenuEvent( PolygonBackgroundToolMenuEvent.SEND_BACKWARD ) );

			e.stopPropagation();
		}

		private function onBringForwardRequest( e:MouseEvent ):void
		{
			this.dispatchEvent( new PolygonBackgroundToolMenuEvent( PolygonBackgroundToolMenuEvent.BRING_FORWARD ) );

			e.stopPropagation();
		}

		private function onCloseRequest( e:MouseEvent ):void
		{
			this.dispatchEvent( new PolygonBackgroundToolMenuEvent( PolygonBackgroundToolMenuEvent.CLOSE_REQUEST ) );

			e.stopPropagation();
		}

		private function onDeleteRequest( e:MouseEvent ):void
		{
			this.dispatchEvent( new PolygonBackgroundToolMenuEvent( PolygonBackgroundToolMenuEvent.DELETE_REQUEST ) );

			e.stopPropagation();
		}
	}
}