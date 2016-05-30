/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.Sprite;

	public class EnemyPathNodeViewSizer extends Sprite
	{
		public function EnemyPathNodeViewSizer()
		{
			this.draw();
		}

		private function draw():void
		{
			const rectSize:int = 10;

			this.graphics.clear();

			this.graphics.beginFill( 0xFFFFFF, .4 );
			this.graphics.lineStyle( 1, 0xFFFFFF, .4 );

			this.graphics.drawRect( -rectSize / 2, -rectSize / 2, rectSize, rectSize );

			this.graphics.endFill();
		}

		public function dispose():void
		{
			this.graphics.clear();
		}
	}
}