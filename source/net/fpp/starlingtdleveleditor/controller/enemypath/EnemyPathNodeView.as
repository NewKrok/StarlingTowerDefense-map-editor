/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.enemypath.events.EnemyPathToolEvent;

	public class EnemyPathNodeView extends Sprite
	{
		private const MINUMUM_PATH_NODE_RADIUS:int = 25;
		private const MAXIMUM_PATH_NODE_RADIUS:int = 75;

		private var _viewSizers:Vector.<EnemyPathNodeViewSizer> = new <EnemyPathNodeViewSizer>[];

		private var _radius:int;

		private var _draggedSizer:EnemyPathNodeViewSizer;
		private var _areaView:Sprite;
		private var _isDragged:Boolean;

		public function EnemyPathNodeView( radius:int )
		{
			this._radius = radius;
			this.buttonMode = true;

			this.createAreaView();
			this.createViewSizers();
			this.updateViewSizerPositions();

			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );

			this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );

			this.draw();
		}

		private function createAreaView():void
		{
			this._areaView = new Sprite();

			this._areaView.addEventListener( MouseEvent.MOUSE_DOWN, this.onAreaViewMouseDownHandler );

			this.addChild( this._areaView );
		}

		private function onAreaViewMouseDownHandler( e:MouseEvent ):void
		{
			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
			this.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			this._isDragged = true;
			this.startDrag();
		}

		private function createViewSizers():void
		{
			for( var i:int = 0; i < 4; i++ )
			{
				var viewSizer:EnemyPathNodeViewSizer = new EnemyPathNodeViewSizer();
				viewSizer.addEventListener( MouseEvent.MOUSE_DOWN, this.onViewSizerMouseDownHandler );

				this._viewSizers.push( viewSizer );
				this.addChild( viewSizer );
			}
		}

		private function onViewSizerMouseDownHandler( e:MouseEvent ):void
		{
			switch( e.currentTarget )
			{
				case this._viewSizers[ 0 ]:
					e.currentTarget.startDrag( false, new Rectangle( -MAXIMUM_PATH_NODE_RADIUS, 0, MAXIMUM_PATH_NODE_RADIUS - MINUMUM_PATH_NODE_RADIUS, 0 ) );
					break;

				case this._viewSizers[ 1 ]:
					e.currentTarget.startDrag( false, new Rectangle( MINUMUM_PATH_NODE_RADIUS, 0, MAXIMUM_PATH_NODE_RADIUS - MINUMUM_PATH_NODE_RADIUS, 0 ) );
					break;

				case this._viewSizers[ 2 ]:
					e.currentTarget.startDrag( false, new Rectangle( 0, MINUMUM_PATH_NODE_RADIUS, 0, MAXIMUM_PATH_NODE_RADIUS - MINUMUM_PATH_NODE_RADIUS ) );
					break;

				case this._viewSizers[ 3 ]:
					e.currentTarget.startDrag( false, new Rectangle( 0, -MAXIMUM_PATH_NODE_RADIUS, 0, MAXIMUM_PATH_NODE_RADIUS - MINUMUM_PATH_NODE_RADIUS ) );
					break;
			}

			this._draggedSizer = e.currentTarget as EnemyPathNodeViewSizer;
			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
			this.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );
		}

		private function onMouseUpHandler( e:MouseEvent ):void
		{
			for( var i:int = 0; i < this._viewSizers.length; i++ )
			{
				this._viewSizers[ i ].stopDrag();
			}

			this._isDragged = false;
			this.stopDrag();

			this._draggedSizer = null;

			this.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			TweenLite.delayedCall( 0.1, this.releaseMouseActions );
		}

		private function releaseMouseActions():void
		{
			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function onMouseMoveHandler( e:MouseEvent ):void
		{
			if( this._draggedSizer )
			{
				switch( this._draggedSizer )
				{
					case this._viewSizers[ 0 ]:
					case this._viewSizers[ 1 ]:
						this.radius = Math.abs( this._draggedSizer.x );
						break;

					case this._viewSizers[ 2 ]:
					case this._viewSizers[ 3 ]:
						this.radius = Math.abs( this._draggedSizer.y );
						break;
				}
			}
			else
			{
				this.dispatchEvent( new EnemyPathToolEvent( EnemyPathToolEvent.NODE_POSTITION_CHANGED ) );
			}
		}

		private function updateViewSizerPositions():void
		{
			this._viewSizers[ 0 ].x = -this._radius;
			this._viewSizers[ 1 ].x = this._radius;
			this._viewSizers[ 2 ].y = this._radius;
			this._viewSizers[ 3 ].y = -this._radius;
		}

		private function draw():void
		{
			this._areaView.graphics.clear();

			const middlePointSize:Number = 10;

			this._areaView.graphics.lineStyle( 1, 0xFFFFFF, .3 );
			this._areaView.graphics.moveTo( -middlePointSize, 0 );
			this._areaView.graphics.lineTo( +middlePointSize, 0 );
			this._areaView.graphics.moveTo( 0, -middlePointSize );
			this._areaView.graphics.lineTo( 0, middlePointSize );

			this._areaView.graphics.beginFill( 0xFFFFFF, .2 );
			this._areaView.graphics.drawCircle( 0, 0, this._radius );
			this._areaView.graphics.endFill();
		}

		public function get radius():int
		{
			return this._radius;
		}

		public function set radius( value:int ):void
		{
			this._radius = value;

			this.updateViewSizerPositions();

			this.draw();
		}

		public function dispose():void
		{
			this._areaView.graphics.clear();

			this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );
			this.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			for( var i:int = 0; i < this._viewSizers.length; i++ )
			{
				var viewSizer:EnemyPathNodeViewSizer = this._viewSizers[ i ];

				viewSizer.removeEventListener( MouseEvent.MOUSE_DOWN, this.onViewSizerMouseDownHandler );

				this.removeChild( viewSizer );
				viewSizer.dispose();
				viewSizer = null
			}

			this._viewSizers.length = 0;
			this._viewSizers = null;
		}

		public function get isDragged():Boolean
		{
			return this._isDragged;
		}
	}
}