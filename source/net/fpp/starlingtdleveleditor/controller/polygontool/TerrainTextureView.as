/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygontool
{
	import flash.display.Sprite;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;

	import net.fpp.starlingtowerdefense.game.module.background.terrainbackground.vo.TerrainTextureVO;

	public class TerrainTextureView extends Sprite
	{
		private var _terrainTextureVO:TerrainTextureVO;

		public function TerrainTextureView( terrainTextureVO:TerrainTextureVO )
		{
			this._terrainTextureVO = terrainTextureVO;

			this.useHandCursor = true;
			this.buttonMode = true;

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._terrainTextureVO.contentTextureId ) );
		}

		public function getTerrainTextureVO():TerrainTextureVO
		{
			return this._terrainTextureVO;
		}
	}
}