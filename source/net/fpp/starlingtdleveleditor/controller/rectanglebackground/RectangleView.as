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
		public var nodeContainer:Sprite;
		public var inGameGraphicsContainer:Sprite;

		public function RectangleView( terrainTextureVO:RectangleBackgroundTerrainTextureVO )
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
			for( var i:int = 0; i < this.rectangleNodeViews.length; i++ )
			{
				this.rectangleNodeViews[ i ].visible = true;
			}
		}

		public function hideNodePoints():void
		{
			for( var i:int = 0; i < this.rectangleNodeViews.length; i++ )
			{
				this.rectangleNodeViews[ i ].visible = false;
			}
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