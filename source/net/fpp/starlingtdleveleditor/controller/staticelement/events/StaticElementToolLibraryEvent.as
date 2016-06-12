/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement.events
{
	import flash.events.Event;

	public class StaticElementToolLibraryEvent extends Event
	{
		public static const ELEMENT_SELECTED:String = 'StaticElementToolLibraryEvent.ELEMENT_SELECTED';
		public static const ELEMENT_DESELECTED:String = 'StaticElementToolLibraryEvent.ELEMENT_DESELECTED';

		public var data:Object;

		public function StaticElementToolLibraryEvent( type:String, data:Object = null )
		{
			this.data = data;

			super( type );
		}

		override public function clone():Event
		{
			var event:StaticElementToolLibraryEvent = new StaticElementToolLibraryEvent( this.type, data );

			return event;
		}
	}
}