/**
 * Created by newkrok on 14/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygontool
{
	import flash.display.Sprite;

	public class PolygonNodeView extends Sprite
	{
		public function PolygonNodeView()
		{
			const size:int = 10;

			this.graphics.lineStyle( 1, 0xFFFFFF, .8 );
			this.graphics.moveTo( -size, 0 );
			this.graphics.lineTo( size, 0 );
			this.graphics.moveTo( 0, -size );
			this.graphics.lineTo( 0, size );

			this.graphics.beginFill( 0xFFFFFF, .2 );
			this.graphics.drawCircle( 0, 0, size / 2 );
			this.graphics.endFill();
		}

		public function dispose():void
		{
			this.graphics.clear();
		}
	}
}