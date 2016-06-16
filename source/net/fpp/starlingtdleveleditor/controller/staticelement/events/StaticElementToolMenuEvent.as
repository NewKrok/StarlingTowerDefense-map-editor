/**
 * Created by newkrok on 16/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement.events
{
	import flash.events.Event;

	public class StaticElementToolMenuEvent extends Event
	{
		public static const DELETE_REQUEST:String = 'RectangleBackgroundToolMenuEvent.DELETE_REQUEST';
		public static const SEND_BACKWARD:String = 'RectangleBackgroundToolMenuEvent.SEND_BACKWARD';
		public static const BRING_FORWARD:String = 'RectangleBackgroundToolMenuEvent.BRING_FORWARD';
		public static const CLOSE_REQUEST:String = 'RectangleBackgroundToolMenuEvent.CLOSE_REQUEST';

		public function StaticElementToolMenuEvent( type:String )
		{
			super( type );
		}

		override public function clone():Event
		{
			var event:StaticElementToolMenuEvent = new StaticElementToolMenuEvent( this.type );

			return event;
		}
	}
}