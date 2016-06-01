/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.Sprite;

	import net.fpp.common.geom.SimplePoint;
	import net.fpp.common.util.GeomUtil;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.enemypath.events.EnemyPathToolEvent;

	public class EnemyPathView extends Sprite
	{
		private const DEFAULT_PATH_NODE_RADIUS:int = 25;
		private const MAXIMUM_NODE_DISTANCE:int = 250;
		private const MINIMUM_NODE_DISTANCE:int = 100;

		private var _enemyPathNodeViews:Vector.<EnemyPathNodeView> = new <EnemyPathNodeView>[];
		private var _enemyPathVO:EnemyPathVO;

		public function EnemyPathView( enemyPathVO:EnemyPathVO, radiuses:Vector.<Number> )
		{
			this._enemyPathVO = enemyPathVO;

			this.createEnemyPathNodeViews( radiuses );

			this.draw();
		}

		private function createEnemyPathNodeViews( radiuses:Vector.<Number> ):void
		{
			for( var i:int = 0; i < this._enemyPathVO.points.length; i++ )
			{
				var enemyPathNodeView:EnemyPathNodeView = this.createEnemyPathNodeView();
				enemyPathNodeView.radius = radiuses[i];

				this._enemyPathNodeViews.push( enemyPathNodeView );
			}
		}

		private function createEnemyPathNodeView():EnemyPathNodeView
		{
			var enemyPathNodeView:EnemyPathNodeView = new EnemyPathNodeView( this.DEFAULT_PATH_NODE_RADIUS );

			enemyPathNodeView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onMouseActionStartedHandler );
			enemyPathNodeView.addEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onMouseActionStoppedHandler );
			enemyPathNodeView.addEventListener( EnemyPathToolEvent.NODE_POSTITION_CHANGED, this.onNodePositionChangedHandler );

			this.addChild( enemyPathNodeView );

			return enemyPathNodeView;
		}

		private function onMouseActionStartedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onMouseActionStoppedHandler( e:ToolControllerEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function onNodePositionChangedHandler( event:EnemyPathToolEvent ):void
		{
			this.updatePositionByView();
			this.addNewNodesIfNeeded();

			this.draw();
		}

		private function updatePositionByView():void
		{
			for( var i:int = 0; i < this._enemyPathVO.points.length; i++ )
			{
				this._enemyPathVO.points[ i ].x = this._enemyPathNodeViews[ i ].x;
				this._enemyPathVO.points[ i ].y = this._enemyPathNodeViews[ i ].y;
			}
		}

		private function addNewNodesIfNeeded():void
		{
			for( var i:int = 0; i < this._enemyPathVO.points.length - 1; i++ )
			{
				var firstEnemyPathPoint:SimplePoint = this._enemyPathVO.points[ i ];
				var secondEnemyPathPoint:SimplePoint = this._enemyPathVO.points[ i + 1 ];

				var nodeDistance:Number = GeomUtil.simplePointDistance( firstEnemyPathPoint, secondEnemyPathPoint );

				if( nodeDistance > MAXIMUM_NODE_DISTANCE )
				{
					var xLength = firstEnemyPathPoint.x - secondEnemyPathPoint.x;
					var yLength = firstEnemyPathPoint.y - secondEnemyPathPoint.y;
					var angle:Number = Math.atan2( yLength, xLength ) + Math.PI;

					var newPoint = new SimplePoint(
							firstEnemyPathPoint.x + MAXIMUM_NODE_DISTANCE / 2 * Math.cos( angle ),
							firstEnemyPathPoint.y + MAXIMUM_NODE_DISTANCE / 2 * Math.sin( angle )
					);

					var newOrderedPoints:Vector.<SimplePoint> = new <SimplePoint>[];
					var newOrderedEnemyPathNodeViews:Vector.<EnemyPathNodeView> = new <EnemyPathNodeView>[];

					for( var j:int = 0; j < this._enemyPathVO.points.length; j++ )
					{
						if( j == i + 1 )
						{
							newOrderedPoints.push( newPoint );
							newOrderedEnemyPathNodeViews.push( this.createEnemyPathNodeView() );
						}

						newOrderedPoints.push( this._enemyPathVO.points[ j ] );
						newOrderedEnemyPathNodeViews.push( this._enemyPathNodeViews[ j ] );
					}

					this._enemyPathVO.points = newOrderedPoints;
					this._enemyPathNodeViews = newOrderedEnemyPathNodeViews;
				}
				else if( nodeDistance < MINIMUM_NODE_DISTANCE && this._enemyPathVO.points.length > 2 )
				{
					var disposeIndex:int = this._enemyPathNodeViews[ i ].isDragged ? i + 1 : i;

					this._enemyPathVO.points.splice( disposeIndex, 1 );

					this.disposePathNodeView( this._enemyPathNodeViews[ disposeIndex ] );
					this._enemyPathNodeViews.splice( disposeIndex, 1 );
				}
			}
		}

		public function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle( 1, 1, 1 );

			for( var i:int = 0; i < this._enemyPathVO.points.length; i++ )
			{
				var pathPoint:SimplePoint = this._enemyPathVO.points[ i ];

				this._enemyPathNodeViews[ i ].x = pathPoint.x;
				this._enemyPathNodeViews[ i ].y = pathPoint.y;

				if( i == 0 )
				{
					this.graphics.moveTo( pathPoint.x, pathPoint.y );
				}
				else
				{
					var prevPathPoint:SimplePoint = this._enemyPathVO.points[ i - 1 ];

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

		public function get enemyPathNodeViews():Vector.<EnemyPathNodeView>
		{
			return this._enemyPathNodeViews;
		}

		private function disposePathNodeView( pathNodeView:EnemyPathNodeView ):void
		{
			pathNodeView.removeEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onMouseActionStartedHandler );
			pathNodeView.removeEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onMouseActionStoppedHandler );

			pathNodeView.dispose();
			this.removeChild( pathNodeView );
			pathNodeView = null;
		}

		public function dispose():void
		{
			this.graphics.clear();

			for( var i:int = 0; i < this._enemyPathNodeViews.length; i++ )
			{
				this.disposePathNodeView( this._enemyPathNodeViews[ i ] );
			}

			this._enemyPathNodeViews.length = 0;
			this._enemyPathNodeViews = null;
		}
	}
}