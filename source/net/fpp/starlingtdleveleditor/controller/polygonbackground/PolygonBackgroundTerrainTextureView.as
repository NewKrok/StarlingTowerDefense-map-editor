/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygonbackground
{
	import flash.display.Sprite;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.starlingtowerdefense.game.module.background.polygonbackground.vo.PolygonBackgroundTerrainTextureVO;

	public class PolygonBackgroundTerrainTextureView extends Sprite
	{
		private var _terrainTextureVO:PolygonBackgroundTerrainTextureVO;

		public function PolygonBackgroundTerrainTextureView( terrainTextureVO:PolygonBackgroundTerrainTextureVO )
		{
			this._terrainTextureVO = terrainTextureVO;

			this.useHandCursor = true;
			this.buttonMode = true;

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._terrainTextureVO.contentTextureId ) );
		}

		public function getTerrainTextureVO():PolygonBackgroundTerrainTextureVO
		{
			return this._terrainTextureVO;
		}
	}
}