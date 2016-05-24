/**
 * Created by newkrok on 16/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygonbackground
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	import net.fpp.starlingtowerdefense.game.module.background.polygonbackground.vo.PolygonBackgroundTerrainTextureVO;

	public class PolygonView extends Sprite
	{
		public var terrainTextureVO:PolygonBackgroundTerrainTextureVO;
		public var polygonNodeViews:Vector.<PolygonNodeView> = new <PolygonNodeView>[];

		public function PolygonView( terrainTextureVO:PolygonBackgroundTerrainTextureVO )
		{
			this.terrainTextureVO = terrainTextureVO;
		}

		public function mark():void
		{
			this.filters = [ new GlowFilter( 0xFFFFFF, 1, 5, 5, 100 ) ];
		}

		public function unmark():void
		{
			this.filters = [];
		}

		public function dispose():void
		{
			this.unmark();
			this.graphics.clear();
			this.polygonNodeViews.length = 0;
			this.polygonNodeViews = null;
		}
	}
}