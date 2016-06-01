/**
 * Created by newkrok on 30/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath.events
{
	import flash.events.Event;

	public class EnemyPathToolEvent extends Event
	{
		public static const NODE_POSTITION_CHANGED:String = 'EnemyPathToolEvent.NODE_POSTITION_CHANGED';

		public function EnemyPathToolEvent( type:String )
		{
			super( type );
		}

		override public function clone():Event
		{
			var event:EnemyPathToolEvent = new EnemyPathToolEvent( this.type );

			return event;
		}
	}
}