/**
 * Created by newkrok on 22/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	import net.fpp.starlingtowerdefense.game.module.background.rectanglebackground.vo.RectangleBackgroundTerrainTextureVO;

	public class RectangleView extends Sprite
	{
		public var terrainTextureVO:RectangleBackgroundTerrainTextureVO;
		public var rectangleNodeViews:Vector.<RectangleNodeView> = new <RectangleNodeView>[];

		public function RectangleView( terrainTextureVO:RectangleBackgroundTerrainTextureVO )
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
			this.rectangleNodeViews.length = 0;
			this.rectangleNodeViews = null;
		}
	}
}