/**
 * Created by newkrok on 27/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;

	public class EnemyPathToolController extends AToolController
	{
		private var _enemyPathToolMenu:EnemyPathToolMenu;
		private var _enemyPaths:Vector.<EnemyPathVO> = new <EnemyPathVO>[];
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
			enemyPathVO.name = 'EnemyPath' + this._enemyPathIndex++;

			this._enemyPaths.push( enemyPathVO );

			this._enemyPathToolMenu.setEnemyPaths( this._enemyPaths );

			this.rePositionEnemyPathToolMenu();
		}
	}
}