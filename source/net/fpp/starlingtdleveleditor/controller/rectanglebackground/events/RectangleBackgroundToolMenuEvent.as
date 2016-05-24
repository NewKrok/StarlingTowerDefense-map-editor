/**
 * Created by newkrok on 24/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground.events
{
	import flash.events.Event;

	import net.fpp.starlingtowerdefense.game.module.background.rectanglebackground.vo.RectangleBackgroundTerrainTextureVO;

	public class RectangleBackgroundToolMenuEvent extends Event
	{
		public static const DELETE_REQUEST:String = 'RectangleBackgroundToolMenuEvent.DELETE_REQUEST';
		public static const CHANGE_TERRAIN_TEXTURE_REQUEST:String = 'RectangleBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST';
		public static const SEND_BACKWARD:String = 'RectangleBackgroundToolMenuEvent.SEND_BACKWARD';
		public static const BRING_FORWARD:String = 'RectangleBackgroundToolMenuEvent.BRING_FORWARD';
		public static const CLOSE_REQUEST:String = 'RectangleBackgroundToolMenuEvent.CLOSE_REQUEST';

		public var terrainTextureVO:RectangleBackgroundTerrainTextureVO;

		public function RectangleBackgroundToolMenuEvent( type:String, terrainTextureVO:RectangleBackgroundTerrainTextureVO = null )
		{
			super( type );

			this.terrainTextureVO = terrainTextureVO;
		}

		override public function clone():Event
		{
			var event:RectangleBackgroundToolMenuEvent = new RectangleBackgroundToolMenuEvent( this.type, this.terrainTextureVO );

			return event;
		}
	}
}