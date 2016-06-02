/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.importlevel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	import net.fpp.starlingtdleveleditor.config.ImportParserConfig;
	import net.fpp.starlingtdleveleditor.config.vo.ImportParserConfigVO;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.parser.IParser;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;

	public class ImportToolController extends AToolController
	{
		private var _background:Sprite;
		private var _dialog:ImportDialog;

		private var _container:Sprite;

		private var _importParserConfig:ImportParserConfig;

		override protected function uiContainerInited():void
		{
			this._importParserConfig = this.toolConfig as ImportParserConfig;

			this.build();
			this.hide();
		}

		private function build():void
		{
			this._container = new Sprite();

			this._container.addChild( this._background = new Sprite );
			this._background.graphics.beginFill( 0x000000, .5 );
			this._background.graphics.drawRect( 0, 0, this._view.stage.stageWidth, this._view.stage.stageHeight );
			this._background.graphics.endFill();

			this._container.addChild( this._dialog = new ImportDialog );
			this._dialog.inputText.text = '';

			this._uiContainer.addChild( this._container );

			this.draw();
		}

		override protected function stageResized():void
		{
			this.draw();
		}

		private function draw():void
		{
			this._background.width = this._uiContainer.stage.stageWidth;
			this._background.height = this._uiContainer.stage.stageHeight;

			this._dialog.x = this._background.width / 2 - this._dialog.width / 2;
			this._dialog.y = this._background.height / 2 - this._dialog.height / 2;
		}

		protected function closeButtonHandler( e:MouseEvent ):void
		{
			this.deactivate();
		}

		protected function startImport( e:MouseEvent ):void
		{
			var data:String = _dialog.inputText.text;

			if( data == '' )
			{
				return;
			}

			var levelDataVO:LevelDataVO;

			try
			{
				levelDataVO = this.convertJSONDataToLevelData( JSON.parse( data ) );
			}catch( e:Error )
			{
				_dialog.inputText.text = e.getStackTrace();
				return;
			}

			for( var key:String in this._toolControllers )
			{
				var toolController:AToolController = this._toolControllers[ key ] as AToolController;

				if( toolController.isSelectable )
				{
					toolController.setLevelDataVO( levelDataVO );
				}
			}

			this.deactivate();
		}

		private function convertJSONDataToLevelData( data:Object ):LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO;
			levelData.createEmptyDatas();

			for( var key:String in data )
			{
				levelData[ key ] = this.parse( data[ key ], levelData[ key ] );
			}

			return levelData;
		}

		private function parse( source:Object, target:Object ):Object
		{
			for( var i:int = 0; i < this._importParserConfig.rule.length; i++ )
			{
				var rule:ImportParserConfigVO = this._importParserConfig.rule[ i ];

				if( getQualifiedClassName( rule.entryType ) == getQualifiedClassName( target ) )
				{
					var parser:IParser = new rule.parserClass();
					return parser.parse( source );
				}
			}

			return null;
		}

		public function show():void
		{
			this._container.visible = true;

			this._dialog.inputText.text = '';
		}

		public function hide():void
		{
			this._container.visible = false;
		}

		override public function activate():void
		{
			this.show();

			this._dialog.importButton.addEventListener( MouseEvent.CLICK, this.startImport );
			this._dialog.closeButton.addEventListener( MouseEvent.CLICK, this.closeButtonHandler );
		}

		override public function deactivate():void
		{
			this.hide();

			this._dialog.importButton.removeEventListener( MouseEvent.CLICK, this.startImport );
			this._dialog.closeButton.removeEventListener( MouseEvent.CLICK, this.closeButtonHandler );
		}
	}
}