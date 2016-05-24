/**
 * Created by newkrok on 24/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.display.Sprite;

	public class RectangleNodeView extends Sprite
	{
		public function RectangleNodeView()
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