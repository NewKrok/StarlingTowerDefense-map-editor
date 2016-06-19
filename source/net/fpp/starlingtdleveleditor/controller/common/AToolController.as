/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.common
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import net.fpp.starlingtowerdefense.vo.LevelDataVO;

	public class AToolController extends EventDispatcher
	{
		protected var _view:DisplayObjectContainer;
		protected var _mainContainer:DisplayObjectContainer;
		protected var _uiContainer:DisplayObjectContainer;

		protected var _toolControllers:Dictionary;

		private var _mouseEnabled:Boolean = true;

		public var id:String;
		public var isSelectable:Boolean;

		protected var _isActivated:Boolean;

		public function AToolController()
		{
		}

		public function activate():void
		{
			this._isActivated = true;

			this.mouseEnabled = true;
		}

		public function deactivate():void
		{
			this._isActivated = false;

			this.mouseEnabled = false;
		}

		public function getLevelDataVO():LevelDataVO
		{
			if( this.isSelectable )
			{
				trace( 'Warning - Missing getLevelData function override :: ' + this.id );
			}

			return null;
		}

		public function setLevelDataVO( levelDataVO:LevelDataVO ):void
		{
		}

		public function setTools( tools:Dictionary ):void
		{
			this._toolControllers = tools;
		}

		public function set mouseEnabled( value:Boolean ):void
		{
			if ( value && !this._isActivated )
			{
				return;
			}

			this._mouseEnabled = value;

			if( this._view )
			{
				this._view.mouseEnabled = value;
				this._view.mouseChildren = value;
			}
		}

		public function setViewContainer( value:DisplayObjectContainer ):void
		{
			this._view = value;

			this._view.mouseEnabled = this._mouseEnabled;
			this._view.mouseChildren = this._mouseEnabled;

			this._view.stage.addEventListener( Event.RESIZE, this.onStageResizeHandler );

			this.viewContainerInited();
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.stageResized();
		}

		protected function stageResized():void
		{
		}

		protected function viewContainerInited():void
		{
		}

		public function setUIContainer( value:DisplayObjectContainer ):void
		{
			this._uiContainer = value;

			this.uiContainerInited();
		}

		protected function uiContainerInited():void
		{
		}

		public function setMainContainer( value:DisplayObjectContainer ):void
		{
			this._mainContainer = value;
			this._mainContainer.addEventListener( Event.RESIZE, this.onMainContainerResizeHandler );

			this.mainContainerInited();
		}

		protected function mainContainerInited():void
		{
		}

		private function onMainContainerResizeHandler( e:Event ):void
		{
			this.mainContainerResized();
		}

		protected function mainContainerResized():void
		{
		}
	}
}