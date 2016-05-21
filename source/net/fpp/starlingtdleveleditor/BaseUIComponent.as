package net.fpp.starlingtdleveleditor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class BaseUIComponent extends Sprite
	{
		public static const PIXEL_SNAP_VALUE:int = 20;

		private var _lastStageSize:Point = new Point;

		public function BaseUIComponent()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, this.addedToStageHandler );
		}

		private function addedToStageHandler( e:Event ):void
		{
			this._lastStageSize.setTo( this.stage.stageWidth, this.stage.stageHeight );

			this.removeEventListener( Event.ADDED_TO_STAGE, this.inited );
			this.stage.addEventListener( Event.RESIZE, this.onStageResizeHandler );

			this.inited();
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.stageResized();

			this._lastStageSize.setTo( this.stage.stageWidth, this.stage.stageHeight );
		}

		protected function inited():void
		{
		}

		protected function stageResized():void
		{
		}

		protected function get lastStageSize():Point
		{
			return this._lastStageSize;
		}

		public static function snapToGrid( position:Number, snapSize:Number = PIXEL_SNAP_VALUE ):int
		{
			return Math.round( position / snapSize ) * snapSize;
		}
	}
}