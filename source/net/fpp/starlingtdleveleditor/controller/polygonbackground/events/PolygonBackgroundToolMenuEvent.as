/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.polygonbackground.events
{
	import flash.events.Event;

	import net.fpp.starlingtowerdefense.game.module.background.polygonbackground.vo.PolygonBackgroundTerrainTextureVO;

	public class PolygonBackgroundToolMenuEvent extends Event
	{
		public static const DELETE_REQUEST:String = 'PolygonBackgroundToolMenuEvent.DELETE_REQUEST';
		public static const CHANGE_TERRAIN_TEXTURE_REQUEST:String = 'PolygonBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST';
		public static const SEND_BACKWARD:String = 'PolygonBackgroundToolMenuEvent.SEND_BACKWARD';
		public static const BRING_FORWARD:String = 'PolygonBackgroundToolMenuEvent.BRING_FORWARD';
		public static const CLOSE_REQUEST:String = 'PolygonBackgroundToolMenuEvent.CLOSE_REQUEST';

		public var terrainTextureVO:PolygonBackgroundTerrainTextureVO;

		public function PolygonBackgroundToolMenuEvent( type:String, terrainTextureVO:PolygonBackgroundTerrainTextureVO = null )
		{
			super( type );

			this.terrainTextureVO = terrainTextureVO;
		}

		override public function clone():Event
		{
			var event:PolygonBackgroundToolMenuEvent = new PolygonBackgroundToolMenuEvent( this.type, this.terrainTextureVO );

			return event;
		}
	}
}