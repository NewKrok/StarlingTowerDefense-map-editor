/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.Sprite;

	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;

	public class EnemyPathView extends Sprite
	{
		private const DEFAULT_PATH_NODE_SIZE:int = 50;

		private var _enemyPathNodeViews:Vector.<EnemyPathNodeView> = new <EnemyPathNodeView>[];
		private var _enemyPathVO:EnemyPathVO;

		public function EnemyPathView( enemyPathVO:EnemyPathVO )
		{
			this._enemyPathVO = enemyPathVO;

			this.createEnemyPathNodeViews();

			this.draw();
		}

		private function createEnemyPathNodeViews():void
		{
			for ( var i:int = 0; i < this._enemyPathVO.points.length; i++ )
			{
				var enemyPathNodeView:EnemyPathNodeView = new EnemyPathNodeView( this.DEFAULT_PATH_NODE_SIZE );
				enemyPathNodeView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onMouseActionStartedHandler );
				enemyPathNodeView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onMouseActionStoppedHandler );
				this.addChild( enemyPathNodeView );

				this._enemyPathNodeViews.push( enemyPathNodeView );
			}
		}

		private function onMouseActionStartedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onMouseActionStoppedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		public function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle( 1, 1, 1 );

			for ( var i:int = 0; i < this._enemyPathVO.points.length; i++ )
			{
				var pathPoint:SimplePoint = this._enemyPathVO.points[i];

				this._enemyPathNodeViews[i].x = pathPoint.x;
				this._enemyPathNodeViews[i].y = pathPoint.y;

				if ( i == 0 )
				{
					this.graphics.moveTo( pathPoint.x, pathPoint.y );
				}
				else
				{
					var prevPathPoint:SimplePoint = this._enemyPathVO.points[i - 1];

					const arrowWidth:int = 10;
					const arrowHeight:int = 10;

					var angle:Number = Math.atan2( pathPoint.y - prevPathPoint.y, pathPoint.x - prevPathPoint.x );
					var arrowStartPoint:SimplePoint = new SimplePoint( pathPoint.x - arrowWidth * Math.cos( angle ), pathPoint.y - arrowWidth * Math.sin( angle ) );

					this.graphics.lineTo( arrowStartPoint.x, arrowStartPoint.y );

					this.graphics.lineTo( arrowStartPoint.x + arrowHeight / 2 * Math.cos( angle + Math.PI / 2 ), arrowStartPoint.y + arrowHeight / 2 * Math.sin( angle + Math.PI / 2 ) );
					this.graphics.lineTo( pathPoint.x, pathPoint.y );
					this.graphics.lineTo( arrowStartPoint.x + arrowHeight / 2 * Math.cos( angle - Math.PI / 2 ), arrowStartPoint.y + arrowHeight / 2 * Math.sin( angle - Math.PI / 2 ) );
					this.graphics.lineTo( arrowStartPoint.x + arrowHeight / 2 * Math.cos( angle + Math.PI / 2 ), arrowStartPoint.y + arrowHeight / 2 * Math.sin( angle + Math.PI / 2 ) );

					this.graphics.lineTo( pathPoint.x, pathPoint.y );
				}
			}
		}

		public function dispose():void
		{
			this.graphics.clear();

			for ( var i:int = 0; i < this._enemyPathNodeViews.length; i++ )
			{
				var enemyPathNodeView:EnemyPathNodeView = this._enemyPathNodeViews[i];

				enemyPathNodeView.removeEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onMouseActionStartedHandler );
				enemyPathNodeView.removeEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onMouseActionStoppedHandler );

				enemyPathNodeView.dispose();
				this.removeChild( enemyPathNodeView );
				enemyPathNodeView = null;
			}

			this._enemyPathNodeViews.length = 0;
			this._enemyPathNodeViews = null;
		}
	}
}