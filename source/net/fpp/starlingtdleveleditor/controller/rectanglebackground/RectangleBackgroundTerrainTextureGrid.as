/**
 * Created by newkrok on 22/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
	import net.fpp.common.display.UIGrid;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.rectanglebackground.events.RectangleBackgroundToolMenuEvent;
	import net.fpp.starlingtowerdefense.game.config.terraintexture.RectangleBackgroundTerrainTextureConfig;
	import net.fpp.starlingtowerdefense.game.module.background.rectanglebackground.vo.RectangleBackgroundTerrainTextureVO;

	public class RectangleBackgroundTerrainTextureGrid extends Sprite
	{
		private var _elementContainer:UIGrid;

		public function RectangleBackgroundTerrainTextureGrid()
		{
			this._elementContainer = new UIGrid( 4, new SimplePoint( 32, 32 ) );
			this._elementContainer.gap = 5;

			this.addChild( this._elementContainer );

			this.createTerrainTextures();
		}

		private function createTerrainTextures():void
		{
			var terrainTextures:Vector.<RectangleBackgroundTerrainTextureVO> = RectangleBackgroundTerrainTextureConfig.instance.getTerrainTextureList();

			for( var i:int = 0; i < terrainTextures.length; i++ )
			{
				var container:UIBox = new UIBox();

				var terrainTextureView:RectangleBackgroundTerrainTextureView = new RectangleBackgroundTerrainTextureView( terrainTextures[ i ] )
				terrainTextureView.width = this._elementContainer.gridSize.x;
				terrainTextureView.height = this._elementContainer.gridSize.y;

				container.addChild( terrainTextureView );

				this._elementContainer.addChild( container );
			}
		}

		public function enable():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;

			this.addEventListener( MouseEvent.CLICK, this.onMouseDownHandler );
		}

		public function disable():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;

			this.removeEventListener( MouseEvent.CLICK, this.onMouseDownHandler );
		}

		private function onMouseDownHandler( e:MouseEvent ):void
		{
			if( e.target is RectangleBackgroundTerrainTextureView )
			{
				this.dispatchEvent( new RectangleBackgroundToolMenuEvent( RectangleBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, ( e.target as RectangleBackgroundTerrainTextureView ).getTerrainTextureVO() ) );
			}
		}
	}
}