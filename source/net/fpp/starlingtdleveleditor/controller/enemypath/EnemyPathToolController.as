/**
 * Created by newkrok on 27/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.geom.SimplePoint;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.enemypath.events.EnemyPathToolMenuEvent;

	public class EnemyPathToolController extends AToolController
	{
		private var _enemyPathToolMenu:EnemyPathToolMenu;
		private var _enemyPaths:Vector.<EnemyPathVO> = new <EnemyPathVO>[];
		private var _enemyPathViews:Vector.<EnemyPathView> = new <EnemyPathView>[];
		private var _enemyPathIndex:int = 0;

		public function EnemyPathToolController()
		{
			this._enemyPathToolMenu = new EnemyPathToolMenu();
		}

		override public function activate():void
		{
			super.activate();

			this._uiContainer.addChild( this._enemyPathToolMenu );
			this._enemyPathToolMenu.enable();

			this._uiContainer.stage.addEventListener( Event.RESIZE, onStageResizeHandler );
			this._view.addEventListener( MouseEvent.CLICK, this.addEnemyPathRequest );
			this._enemyPathToolMenu.addEventListener( EnemyPathToolMenuEvent.REMOVE_REQUEST, this.removeEnemyPathRequestHandler );

			this.rePositionEnemyPathToolMenu();
		}

		override public function deactivate():void
		{
			super.deactivate();

			if( this._enemyPathToolMenu.parent )
			{
				this._uiContainer.removeChild( this._enemyPathToolMenu );
				this._enemyPathToolMenu.disable();
			}

			this._uiContainer.stage.removeEventListener( Event.RESIZE, onStageResizeHandler );
			this._view.removeEventListener( MouseEvent.CLICK, this.addEnemyPathRequest );
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.rePositionEnemyPathToolMenu();
		}

		private function rePositionEnemyPathToolMenu():void
		{
			this._enemyPathToolMenu.x = 5;
			this._enemyPathToolMenu.y = this._uiContainer.stage.stageHeight - this._enemyPathToolMenu.height - 5;
		}

		private function addEnemyPathRequest( e:MouseEvent ):void
		{
			var enemyPathVO:EnemyPathVO = new EnemyPathVO;
			enemyPathVO.name = this.calculateNextEnemyPathName();
			enemyPathVO.points = new <SimplePoint>[
				new SimplePoint( this._view.mouseX, this._view.mouseY ),
				new SimplePoint( this._view.mouseX + 100, this._view.mouseY ),
				new SimplePoint( this._view.mouseX + 200, this._view.mouseY ),
				new SimplePoint( this._view.mouseX + 300, this._view.mouseY )
			];

			this._enemyPaths.push( enemyPathVO );

			var enemyPathView:EnemyPathView = new EnemyPathView( enemyPathVO );
			enemyPathView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onMouseActionStartedHandler );
			enemyPathView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onMouseActionStoppedHandler );
			this._view.addChild( enemyPathView );
			this._enemyPathViews.push( enemyPathView )

			this.updateEnemyPathViews();
			this.updateEnemyPathToolMenu();
		}

		private function onMouseActionStartedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onMouseActionStoppedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function calculateNextEnemyPathName():String
		{
			var result:String = 'EnemyPath' + this._enemyPathIndex++;

			for ( var i:int = 0; i < this._enemyPaths.length; i++ )
			{
				if ( this._enemyPaths[i].name == result )
				{
					result = 'EnemyPath' + this._enemyPathIndex++;
				}
			}

			return result;
		}

		private function updateEnemyPathToolMenu():void
		{
			this._enemyPathToolMenu.setEnemyPaths( this._enemyPaths );

			this.rePositionEnemyPathToolMenu();
		}

		private function removeEnemyPathRequestHandler( e:EnemyPathToolMenuEvent ):void
		{
			for ( var i:int = 0; i < this._enemyPaths.length; i++ )
			{
				if ( this._enemyPaths[i] == e.data )
				{
					this._enemyPaths.splice( i, 1 );

					this._view.removeChild( this._enemyPathViews[i] );
					this._enemyPathViews[i].dispose();
					this._enemyPathViews[i] = null;
					this._enemyPathViews.splice( i, 1 );
					break;
				}
			}

			this.updateEnemyPathViews();
			this.updateEnemyPathToolMenu();
		}

		private function updateEnemyPathViews():void
		{
			for ( var i:int = 0; i < this._enemyPathViews.length; i++ )
			{
				this._enemyPathViews[i].draw();
			}
		}
	}
}