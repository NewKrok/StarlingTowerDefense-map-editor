package leveleditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import leveleditor.data.LevelDataVO;
	import leveleditor.events.ImportEvent;
	import leveleditor.events.MenuEvent;

	public class ImportPanel extends BaseUIComponent
	{
		private var background:Sprite;

		private var dialog:ImportDialog;
		
		public function ImportPanel( )
		{
			hide( );
		}
		
		override protected function inited( ):void
		{
			addChild( background = new Sprite );
			background.graphics.beginFill( 0x000000, .5 );
			background.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			background.graphics.endFill( );
			
			addChild( dialog = new ImportDialog );
			dialog.inputText.text = '';
			dialog.importButton.addEventListener( MouseEvent.CLICK, startImport );
			dialog.closeButton.addEventListener( MouseEvent.CLICK, closeButtonHandler );
			
			stageResized( );
		}
		
		override protected function stageResized( ):void
		{
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			
			dialog.x = width / 2 - dialog.width / 2;
			dialog.y = height / 2 - dialog.height / 2;
		}
		
		protected function closeButtonHandler( e:MouseEvent ):void
		{
			dispatchEvent( new MenuEvent( MenuEvent.CLOSE_REQUEST ) );
		}
		
		protected function startImport( e:MouseEvent ):void
		{
			var data:String = dialog.inputText.text;
			var levelData:LevelDataVO;

			levelData = convertJSONDataToLevelData( JSON.parse( data ) );
			
			dispatchEvent( new ImportEvent( ImportEvent.DATA_IMPORTED, levelData ) );
		}
		
		protected function convertJSONDataToLevelData( data:Object ):LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO;

			levelData.libraryElements = data.libraryElements;

			return levelData;
		}

		public function show( ):void
		{
			visible = true;
			
			dialog.inputText.text = '';
		}

		public function hide( ):void
		{
			visible = false;
		}
		
	}
}