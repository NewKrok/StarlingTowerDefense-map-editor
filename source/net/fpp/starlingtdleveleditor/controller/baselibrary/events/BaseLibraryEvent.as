/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.baselibrary.events
{
	import flash.events.Event;

	public class BaseLibraryEvent extends Event
	{
		public static const ELEMENT_SELECTED:String = 'BaseLibraryEvent.ELEMENT_SELECTED';
		public static const ELEMENT_DESELECTED:String = 'BaseLibraryEvent.ELEMENT_DESELECTED';

		public var data:Object;

		public function BaseLibraryEvent( type:String, data:Object = null )
		{
			this.data = data;

			super( type );
		}

		override public function clone():Event
		{
			var event:BaseLibraryEvent = new BaseLibraryEvent( this.type, data );

			return event;
		}
	}
}