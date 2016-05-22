/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.zoomout
{
	import flash.events.Event;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;

	public class ZoomOutToolController extends AToolController
	{
		override public function activate():void
		{
			this.zoomIn();
		}

		public function zoomIn():void
		{
			this._mainContainer.scaleX -= .1;

			this._mainContainer.scaleX = Math.max( this._mainContainer.scaleX, .2 );

			this._mainContainer.scaleY = this._mainContainer.scaleX;

			this._mainContainer.dispatchEvent( new Event( Event.RESIZE ) );
		}
	}
}