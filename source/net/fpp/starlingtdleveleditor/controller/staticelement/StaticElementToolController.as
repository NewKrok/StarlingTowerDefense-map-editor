/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.events.Event;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;

	public class StaticElementToolController extends AToolController
	{
		private var _staticElementToolLibrary:StaticElementToolLibrary;

		public function StaticElementToolController()
		{
			this._staticElementToolLibrary = new StaticElementToolLibrary();
		}

		override public function activate():void
		{
			super.activate();

			this._uiContainer.addChild( this._staticElementToolLibrary );

			this._uiContainer.stage.addEventListener( Event.RESIZE, onStageResizeHandler );

			this.repositionLibrary();
		}

		override public function deactivate():void
		{
			super.deactivate();

			if( this._staticElementToolLibrary.parent )
			{
				this._uiContainer.removeChild( this._staticElementToolLibrary );
			}

			this._uiContainer.stage.removeEventListener( Event.RESIZE, onStageResizeHandler );
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.repositionLibrary();
			this._staticElementToolLibrary.resize();
		}

		private function repositionLibrary():void
		{
			this._staticElementToolLibrary.x = 5;
			this._staticElementToolLibrary.y = this._uiContainer.stage.stageHeight - this._staticElementToolLibrary.height - 5;
		}
	}
}