/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	public class AToolController extends EventDispatcher
	{
		protected var _view:DisplayObjectContainer;
		private var _mouseEnabled:Boolean = true;

		public function AToolController()
		{
		}

		public function activate():void
		{
		}

		public function deactivate():void
		{
		}

		public function set mouseEnabled( value:Boolean ):void
		{
			this._mouseEnabled = value;

			if ( this._view )
			{
				this._view.mouseEnabled = value;
			}
		}

		public function setViewContainer( value:DisplayObjectContainer ):void
		{
			this._view = value;

			this._view.mouseEnabled = this._mouseEnabled;
		}
	}
}