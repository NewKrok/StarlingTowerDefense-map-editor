package net.fpp.starlingtdleveleditor.events
{
	import flash.events.Event;
	
	import net.fpp.starlingtdleveleditor.data.LevelDataVO;

	public class ImportEvent extends Event
	{
		public static var DATA_IMPORTED:String = 'ImportEvent.DATA_IMPORTED';
		
		public var levelData:LevelDataVO;
		
		public function ImportEvent( type:String, levelData:LevelDataVO = null )
		{
			this.levelData = levelData;
			
			super( type );
		}
	}
}