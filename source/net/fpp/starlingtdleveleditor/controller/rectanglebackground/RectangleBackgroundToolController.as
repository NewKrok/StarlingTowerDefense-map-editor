/**
 * Created by newkrok on 22/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.events.MouseEvent;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;

	public class RectangleBackgroundToolController extends AToolController
	{
		protected var _rectangleViews:Vector.<RectangleView> = new <RectangleView>[];

		private var _rectangleBackgroundToolMenu:RectangleBackgroundToolMenu;

		public function RectangleBackgroundToolController()
		{
			this._rectangleBackgroundToolMenu = new RectangleBackgroundToolMenu();
		}

		override public function activate():void
		{
			super.activate();

			this._view.addEventListener( MouseEvent.CLICK, this.addRectangleRequest );
			//this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			//this._view.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			//this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		override public function deactivate():void
		{
			super.deactivate();

			this._view.removeEventListener( MouseEvent.CLICK, this.addRectangleRequest );
			//this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			//this._view.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			//this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		private function addRectangleRequest( e:MouseEvent ):void
		{

		}
	}
}