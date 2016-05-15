/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygontool
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.component.Button;
	import net.fpp.starlingtdleveleditor.controller.polygontool.event.PolygonToolMenuEvent;

	public class PolygonToolMenu extends Sprite
	{
		private var _background:DisplayObject;
		private var _container:UIBox;

		private var _deleteButton:Button;
		private var _terrainTextureGrid:TerrainTextureGrid;

		public function PolygonToolMenu()
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._container = new UIBox();
			this._container.gap = 5;
			this.addChild( this._container );

			this.createDeleteButton();
			this.createTerrainTextureContainer();

			this._deleteButton.width = width;

			var padding:Number = 5;
			this._background.width = width + padding * 2;
			this._background.height = height + padding * 2;

			this._container.x = padding;
			this._container.y = padding;
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
			this._terrainTextureGrid = new TerrainTextureGrid();

			this._container.addChild( this._terrainTextureGrid );
		}

		public function enable():void
		{
			this._deleteButton.enable();
			this._deleteButton.addEventListener( MouseEvent.CLICK, this.onDeleteRequest );

			this._terrainTextureGrid.enable();
			this._terrainTextureGrid.addEventListener( PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainChangeRequestHandler );
		}

		public function disable():void
		{
			this._deleteButton.disable();
			this._terrainTextureGrid.disable();

			this._terrainTextureGrid.removeEventListener( PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainChangeRequestHandler );
		}

		private function onTerrainChangeRequestHandler( e:PolygonToolMenuEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onDeleteRequest( e:MouseEvent ):void
		{
			this.dispatchEvent( new PolygonToolMenuEvent( PolygonToolMenuEvent.DELETE_REQUEST ) );

			e.stopPropagation();
		}
	}
}