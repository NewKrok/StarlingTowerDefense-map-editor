/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygontool
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.display.UIBox;
	import net.fpp.common.display.UIGrid;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.polygontool.event.PolygonToolMenuEvent;
	import net.fpp.starlingtowerdefense.game.config.terraintexture.TerrainTextureConfig;
	import net.fpp.starlingtowerdefense.game.module.background.terrainbackground.vo.TerrainTextureVO;

	public class TerrainTextureGrid extends Sprite
	{
		private var _elementContainer:UIGrid;

		public function TerrainTextureGrid()
		{
			this._elementContainer = new UIGrid( 3, new SimplePoint( 40, 40 ) );
			this._elementContainer.gap = 10;
			this._elementContainer.borderColor = 0x666666;
			this._elementContainer.isBorderEnabled = true;

			this.addChild( this._elementContainer );

			this.createTerrainTextures();
		}

		private function createTerrainTextures():void
		{
			var terrainTextures:Vector.<TerrainTextureVO> = TerrainTextureConfig.instance.getTerrainTextureList();

			for( var i:int = 0; i < terrainTextures.length; i++ )
			{
				var container:UIBox = new UIBox();

				container.addChild( new TerrainTextureView( terrainTextures[ i ] ) );

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
			if( e.target is TerrainTextureView )
			{
				this.dispatchEvent( new PolygonToolMenuEvent( PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, ( e.target as TerrainTextureView ).getTerrainTextureVO() ) );
			}
		}
	}
}