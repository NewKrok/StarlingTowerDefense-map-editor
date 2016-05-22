package net.fpp.starlingtdleveleditor.events
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
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