package net.fpp.starlingtdleveleditor.events
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
		public static var IMPORT_REQUEST:String = 'MenuEvent.IMPORT_REQUEST';
		public static var EXPORT_REQUEST:String = 'MenuEvent.EXPORT_REQUEST';
		public static var SET_CONTROL_TO_SELECT:String = 'MenuEvent.SET_CONTROL_TO_SELECT';
		public static var SET_CONTROL_TO_POLYGON:String = 'MenuEvent.SET_CONTROL_TO_POLYGON';
		public static var ZOOM_IN_REQUEST:String = 'MenuEvent.ZOOM_IN_REQUEST';
		public static var ZOOM_OUT_REQUEST:String = 'MenuEvent.ZOOM_OUT_REQUEST';
		public static var CLOSE_REQUEST:String = 'MenuEvent.CLOSE_REQUEST';

		public static const CHANGE_CONTROLLER:String = 'MenuEvent.CHANGE_CONTROLLER';

		public var id:String;

		public function MenuEvent( type:String, id:String = null )
		{
			super( type );

			this.id = id;
		}

		override public function clone():Event
		{
			return new MenuEvent( this.type, this.id );
		}
	}
}