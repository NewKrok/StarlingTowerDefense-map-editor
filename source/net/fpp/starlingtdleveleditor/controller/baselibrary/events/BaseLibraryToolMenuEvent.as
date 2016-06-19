/**
 * Created by newkrok on 16/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.baselibrary.events
{
	import flash.events.Event;

	public class BaseLibraryToolMenuEvent extends Event
	{
		public static const DELETE_REQUEST:String = 'BaseLibraryToolMenuEvent.DELETE_REQUEST';
		public static const SEND_BACKWARD:String = 'BaseLibraryToolMenuEvent.SEND_BACKWARD';
		public static const BRING_FORWARD:String = 'BaseLibraryToolMenuEvent.BRING_FORWARD';
		public static const CLOSE_REQUEST:String = 'BaseLibraryToolMenuEvent.CLOSE_REQUEST';

		public function BaseLibraryToolMenuEvent( type:String )
		{
			super( type );
		}

		override public function clone():Event
		{
			var event:BaseLibraryToolMenuEvent = new BaseLibraryToolMenuEvent( this.type );

			return event;
		}
	}
}