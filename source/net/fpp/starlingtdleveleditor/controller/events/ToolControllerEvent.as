/**
 * Created by newkrok on 21/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.events
{
	import flash.events.Event;

	public class ToolControllerEvent extends Event
	{
		public static const MOUSE_ACTION_STARTED:String = 'ToolControllerEvent.MOUSE_ACTION_STARTED';
		public static const MOUSE_ACTION_STOPPED:String = 'ToolControllerEvent.MOUSE_ACTION_STOPPED';

		public function ToolControllerEvent( type:String ):void
		{
			super( type );

		}
	}
}