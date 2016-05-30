/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;

	public class EnemyPathNodeView extends Sprite
	{
		private var _viewSizers:Vector.<EnemyPathNodeViewSizer> = new <EnemyPathNodeViewSizer>[];

		private var _size:int;

		public function EnemyPathNodeView( size:int )
		{
			this._size = size;
			this.buttonMode = true;

			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );

			this.createViewSizers();
			this.updateViewSizerPositions();

			this.draw();
		}

		private function createViewSizers():void
		{
			for( var i:int = 0; i < 4; i++ )
			{
				var viewSizer:EnemyPathNodeViewSizer = new EnemyPathNodeViewSizer();
				viewSizer.addEventListener( MouseEvent.MOUSE_DOWN, this.onViewSizerMouseDownHandler );
				this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );
				this.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

				this._viewSizers.push( viewSizer );
				this.addChild( viewSizer );
			}
		}

		private function onViewSizerMouseDownHandler( e:MouseEvent ):void
		{
			if ( e.currentTarget == this._viewSizers[0] || e.currentTarget == this._viewSizers[2] )
			{
				( e.currentTarget as EnemyPathNodeViewSizer ).startDrag( false, new Rectangle( -Number.MAX_VALUE, 0, Number.MAX_VALUE, 0 ) );
			}
			else
			{
				( e.currentTarget as EnemyPathNodeViewSizer ).startDrag( false, new Rectangle( 0, 0, 0, Number.MAX_VALUE ) );
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
		}

		private function onMouseUpHandler( e:MouseEvent ):void
		{
			for( var i:int = 0; i < this._viewSizers.length; i++ )
			{
				this._viewSizers[i].stopDrag();
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function onMouseMoveHandler( e:MouseEvent ):void
		{

		}

		private function updateViewSizerPositions():void
		{
			this._viewSizers[0].x = -this._size / 2;
			this._viewSizers[1].x = this._size / 2;
			this._viewSizers[2].y = this._size / 2;
			this._viewSizers[3].y = -this._size / 2;
		}

		private function draw():void
		{
			this.graphics.clear();

			const middlePointSize:Number = 10;

			this.graphics.lineStyle( 1, 0xFFFFFF, .3 );
			this.graphics.moveTo( -middlePointSize, 0 );
			this.graphics.lineTo( +middlePointSize, 0 );
			this.graphics.moveTo( 0, -middlePointSize );
			this.graphics.lineTo( 0, middlePointSize );

			this.graphics.beginFill( 0xFFFFFF, .2 );
			this.graphics.drawCircle( 0, 0, this._size / 2 );
			this.graphics.endFill();
		}

		public function get size():int
		{
			return this._size;
		}

		public function set size( value:int ):void
		{
			this._size = value;

			this.updateViewSizerPositions();

			this.draw();
		}

		public function dispose():void
		{
			this.graphics.clear();

			for( var i:int = 0; i < this._viewSizers.length; i++ )
			{
				var viewSizer:EnemyPathNodeViewSizer = this._viewSizers[i];

				viewSizer.removeEventListener( MouseEvent.MOUSE_DOWN, this.onViewSizerMouseDownHandler );
				this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );
				this.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

				this.removeChild( viewSizer );
				viewSizer.dispose();
				viewSizer = null
			}

			this._viewSizers.length = 0;
			this._viewSizers = null;
		}
	}
}