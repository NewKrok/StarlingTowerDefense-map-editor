/**
 * Created by newkrok on 29/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath.events
{
	import flash.events.Event;

	public class EnemyPathToolMenuEvent extends Event
	{
		public static const RESIZE_REQUEST:String = 'EnemyPathToolMenuEvent.RESIZE_REQUEST';
		public static const RENAME_REQUEST:String = 'EnemyPathToolMenuEvent.RENAME_REQUEST';
		public static const REMOVE_REQUEST:String = 'EnemyPathToolMenuEvent.REMOVE_REQUEST';

		public var data:Object;

		public function EnemyPathToolMenuEvent( type:String, data:Object = null )
		{
			super( type );

			this.data = data;
		}

		override public function clone():Event
		{
			var event:EnemyPathToolMenuEvent = new EnemyPathToolMenuEvent( this.type, data );

			return event;
		}
	}
}