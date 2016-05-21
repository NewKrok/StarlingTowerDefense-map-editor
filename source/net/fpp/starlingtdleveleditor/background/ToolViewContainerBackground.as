/**
 * Created by newkrok on 21/05/16.
 */
package net.fpp.starlingtdleveleditor.background
{
	import flash.display.Sprite;

	import net.fpp.starlingtdleveleditor.constant.CEditor;

	public class ToolViewContainerBackground extends Sprite
	{
		public function ToolViewContainerBackground()
		{
			this.graphics.clear();
			this.graphics.beginFill( 0, 0 );
			this.graphics.drawRect( 0, 0, CEditor.EDITOR_WORLD_SIZE.x, CEditor.EDITOR_WORLD_SIZE.y );
			this.graphics.endFill();
		}
	}
}