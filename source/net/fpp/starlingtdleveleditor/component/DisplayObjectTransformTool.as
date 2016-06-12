/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;

	public class DisplayObjectTransformTool
	{
		private const RESIZER_SIZE:Number = 10;

		private var _target:DisplayObjectContainer;

		private var _frame:Sprite;
		private var _resizer:Vector.<Sprite>;

		private var _defaultSize:SimplePoint;

		public function DisplayObjectTransformTool( target:DisplayObjectContainer )
		{
			this._target = target;
			this._target.addEventListener( Event.ADDED_TO_STAGE, this.onTargetAddedToStageHandler );
		}

		private function onTargetAddedToStageHandler( e:Event ):void
		{
			this._target.removeEventListener( Event.ADDED_TO_STAGE, this.onTargetAddedToStageHandler );

			this._frame = new Sprite();
			this._target.parent.addChild( this._frame );

			this.createResizers();

			this._defaultSize = new SimplePoint( this._target.width, this._target.height );

			this._target.stage.addEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );

			this.draw();
		}

		private function createResizers():void
		{
			this._resizer = new <Sprite>[];

			for ( var i:int = 0; i < 4; i++ )
			{
				var resizer:Sprite = new Sprite();
				resizer.graphics.beginFill( 0xFFFFFF, .3 );
				resizer.graphics.drawRect( -RESIZER_SIZE / 2, -RESIZER_SIZE / 2, RESIZER_SIZE, RESIZER_SIZE );
				resizer.graphics.endFill();

				resizer.buttonMode = true;
				resizer.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );

				this._resizer.push( resizer );

				this._target.parent.addChild( resizer );
			}
		}

		private function onMouseDownHandler( e:MouseEvent ):void
		{
			var resizer:Sprite = e.target as Sprite;

			resizer.startDrag();

			this._target.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			this._target.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

			e.stopPropagation();
		}

		private function onMouseUpHandler( e:MouseEvent ):void
		{
			var resizer:Sprite = e.target as Sprite;

			resizer.stopDrag();

			this._target.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			this._target.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function onMouseMoveHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case this._resizer[0]:
					this._resizer[1].y = this._resizer[0].y;
					this._resizer[3].x = this._resizer[0].x;
					break;

				case this._resizer[1]:
					this._resizer[0].y = this._resizer[1].y;
					this._resizer[2].x = this._resizer[1].x;
					break;

				case this._resizer[2]:
					this._resizer[3].y = this._resizer[2].y;
					this._resizer[1].x = this._resizer[2].x;
					break;

				case this._resizer[3]:
					this._resizer[2].y = this._resizer[3].y;
					this._resizer[0].x = this._resizer[3].x;
					break;
			}

			this._target.scaleX = this._defaultSize.x / ( this._resizer[0].x - this._resizer[1].x );
			this._target.scaleY = this._defaultSize.y / ( this._resizer[2].y - this._resizer[1].y );

			this.drawFrame();
		}

		private function draw():void
		{
			this.drawFrame();

			const resizerPositions:Vector.<SimplePoint> = new <SimplePoint>[
				new SimplePoint( this._target.x, this._target.y ),
				new SimplePoint( this._target.x + this._target.width - RESIZER_SIZE / 2, this._target.y ),
				new SimplePoint( this._target.x + this._target.width - RESIZER_SIZE / 2, this._target.y + this._target.height - RESIZER_SIZE / 2 ),
				new SimplePoint( this._target.x, this._target.y + this._target.height - RESIZER_SIZE / 2 )
			];

			for ( var i:int = 0; i < this._resizer.length; i++ )
			{
				this._resizer[i].x = resizerPositions[i].x;
				this._resizer[i].y = resizerPositions[i].y;
			}
		}

		private function drawFrame():void
		{
			this._frame.graphics.clear();

			this._frame.graphics.lineStyle( 1, 0xFFFFFF, .3 );
			this._frame.graphics.drawRect( 0, 0, this._target.width, this._target.height );
		}

		public function dispose():void
		{
			this._target.parent.removeChild( this._frame );
			this._frame.graphics.clear();
			this._frame = null;

			for ( var i:int = 0; i < this._resizer.length; i++ )
			{
				this._resizer[i].removeEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
				this._resizer[i].graphics.clear();
				this._target.parent.removeChild( this._resizer[i] );
				this._resizer[i] = null;
			}
			this._resizer.length = 0;
			this._resizer = null;

			this._target.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onMouseUpHandler );
		}
	}
}