/**
 * Created by newkrok on 24/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.display.Sprite;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.starlingtowerdefense.game.module.background.rectanglebackground.vo.RectangleBackgroundTerrainTextureVO;

	public class RectangleBackgroundTerrainTextureView extends Sprite
	{
		private var _terrainTextureVO:RectangleBackgroundTerrainTextureVO;

		public function RectangleBackgroundTerrainTextureView( terrainTextureVO:RectangleBackgroundTerrainTextureVO )
		{
			this._terrainTextureVO = terrainTextureVO;

			this.useHandCursor = true;
			this.buttonMode = true;

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._terrainTextureVO.contentTextureId ) );
		}

		public function getTerrainTextureVO():RectangleBackgroundTerrainTextureVO
		{
			return this._terrainTextureVO;
		}
	}
}