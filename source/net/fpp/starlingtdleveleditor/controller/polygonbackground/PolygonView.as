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
		public var nodeContainer:Sprite;
		public var inGameGraphicsContainer:Sprite;

		public function PolygonView( terrainTextureVO:PolygonBackgroundTerrainTextureVO )
		{
			this.terrainTextureVO = terrainTextureVO;

			this.inGameGraphicsContainer = new Sprite();
			this.addChild( this.inGameGraphicsContainer );

			this.nodeContainer = new Sprite();
			this.addChild( this.nodeContainer );
		}

		public function mark():void
		{
			this.inGameGraphicsContainer.filters = [ new GlowFilter( 0xFFFFFF, 1, 5, 5, 100 ) ];
		}

		public function unmark():void
		{
			this.inGameGraphicsContainer.filters = [];
		}

		public function showNodePoints():void
		{
			for( var i:int = 0; i < this.polygonNodeViews.length; i++ )
			{
				this.polygonNodeViews[ i ].visible = true;
			}
		}

		public function hideNodePoints():void
		{
			for( var i:int = 0; i < this.polygonNodeViews.length; i++ )
			{
				this.polygonNodeViews[ i ].visible = false;
			}
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