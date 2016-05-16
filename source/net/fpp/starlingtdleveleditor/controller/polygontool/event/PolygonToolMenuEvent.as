/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygontool.event
{
	import flash.events.Event;

	import net.fpp.starlingtowerdefense.game.module.background.terrainbackground.vo.TerrainTextureVO;

	public class PolygonToolMenuEvent extends Event
	{
		public static const DELETE_REQUEST:String = 'PolygonToolMenuEvent.DELETE_REQUEST';
		public static const CHANGE_TERRAIN_TEXTURE_REQUEST:String = 'PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST';
		public static const SEND_BACKWARD:String = 'PolygonToolMenuEvent.SEND_BACKWARD';
		public static const BRING_FORWARD:String = 'PolygonToolMenuEvent.BRING_FORWARD';
		public static const CLOSE_REQUEST:String = 'PolygonToolMenuEvent.CLOSE_REQUEST';

		public var terrainTextureVO:TerrainTextureVO;

		public function PolygonToolMenuEvent( type:String, terrainTextureVO:TerrainTextureVO = null )
		{
			super( type );

			this.terrainTextureVO = terrainTextureVO;
		}

		override public function clone():Event
		{
			var event:PolygonToolMenuEvent = new PolygonToolMenuEvent( this.type, this.terrainTextureVO );

			return event;
		}
	}
}