package
{
	import assets.TerrainTextures;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.static.FPPContextMenu;
	import net.fpp.starlingtdleveleditor.Background;
	import net.fpp.starlingtdleveleditor.EditorLibrary;
	import net.fpp.starlingtdleveleditor.EditorMain;
	import net.fpp.starlingtdleveleditor.ExportPanel;
	import net.fpp.starlingtdleveleditor.ZoomView;
	import net.fpp.starlingtdleveleditor.config.ToolConfig;
	import net.fpp.starlingtdleveleditor.controller.importlevel.ImportPanel;
	import net.fpp.starlingtdleveleditor.events.EditorLibraryEvent;
	import net.fpp.starlingtdleveleditor.events.EditorWorldEvent;
	import net.fpp.starlingtdleveleditor.events.ImportEvent;
	import net.fpp.starlingtdleveleditor.events.MenuEvent;
	import net.fpp.starlingtdleveleditor.menu.Menu;
	import net.fpp.starlingtdleveleditor.vo.ToolConfigVO;

	public class MapEditorMain extends Sprite
	{
		private var _background:Background;
		private var _editorMain:EditorMain;
		private var _zoomView:ZoomView;
		private var _menu:Menu;
		private var _editorLibrary:EditorLibrary;
		private var _importPanel:ImportPanel;
		private var _exportPanel:ExportPanel;

		public function MapEditorMain()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			StaticBitmapAssetManager.scaleFactor = 2;
			StaticBitmapAssetManager.instance.loadFromJSONAtlas( TerrainTextures.AtlasImage, TerrainTextures.AtlasDescription );

			addEventListener( Event.ADDED_TO_STAGE, inited );

			FPPContextMenu.create( this );
		}

		private function inited( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, inited );

			addChild( _background = new Background );
			addChild( _editorMain = new EditorMain );
			addChild( _zoomView = new ZoomView() );

			this._menu = new Menu;
			this._menu.x = 5;
			this._menu.y = 5;
			this.addChild( this._menu );


			this._editorLibrary = new EditorLibrary();
			//this._editorLibrary.addEventListener( EditorLibraryEvent.OPEN_REQUEST, onEditorLibraryOpenHandler )
			this._editorLibrary.addEventListener( EditorLibraryEvent.ADD_ELEMENT_TO_WORLD_REQUEST, onAddelementToWorldRequestHandler )
			this.addChild( this._editorLibrary );

			this._editorMain.addEventListener( EditorWorldEvent.ON_VIEW_RESIZE, this.onEditorWorldResize );

			addChild( _importPanel = new ImportPanel );
			_importPanel.addEventListener( ImportEvent.DATA_IMPORTED, onDataImportedHandler );
			_importPanel.addEventListener( MenuEvent.CLOSE_REQUEST, onCloseImportPanelHandler );

			addChild( _exportPanel = new ExportPanel );
			_exportPanel.addEventListener( MenuEvent.CLOSE_REQUEST, onCloseExportPanelHandler );

			this.createTools();
		}

		private function createTools():void
		{
			var toolConfig:ToolConfig = new ToolConfig();

			for( var i:int = 0; i < toolConfig.configs.length; i++ )
			{
				var config:ToolConfigVO = toolConfig.configs[ i ];

				this._menu.addElement( config.id, config.name, config.iconImageSrc );
				this._menu.addEventListener( MenuEvent.CHANGE_CONTROLLER, onChangeControllerHandler );
			}
		}

		private function onImportRequestHandler( e:MenuEvent ):void
		{
			_importPanel.show();
		}

		private function onEditorWorldResize( e:EditorWorldEvent ):void
		{
			var zoomValue:Number = e.data as Number;

			this._background.setScale( zoomValue );

			_zoomView.setZoom( zoomValue );
		}

		private function onDataImportedHandler( e:ImportEvent ):void
		{
			_editorMain.loadLevel( e.levelData );

			onCloseImportPanelHandler( new MenuEvent( MenuEvent.CLOSE_REQUEST ) );
		}

		private function onCloseImportPanelHandler( e:MenuEvent ):void
		{
			_importPanel.hide();
		}

		private function onExportRequestHandler( e:MenuEvent ):void
		{
			_exportPanel.show( _editorMain.getLevelData() );
		}

		private function onCloseExportPanelHandler( e:MenuEvent ):void
		{
			_exportPanel.hide();
		}

		private function zoomInHandler( e:MenuEvent ):void
		{
			_editorMain.zoomIn();
		}

		private function zoomOutHandler( e:MenuEvent ):void
		{
			_editorMain.zoomOut();
		}

		private function onSetControlToSelectHandler( e:MenuEvent ):void
		{
			_editorMain.setControl( EditorMain.CONTROL_TYPE_SELECT );
		}

		private function onSetControlToAddHandler( e:MenuEvent ):void
		{
			_editorMain.setControl( EditorMain.CONTROL_TYPE_POLYGON );
		}

		private function closeEditorLibrary():void
		{
			if( this._editorLibrary )
			{
				this._editorLibrary.closeLibrary();
			}
		}

		private function onAddelementToWorldRequestHandler( e:EditorLibraryEvent ):void
		{
			this._editorMain.addLibraryElement( e.libraryElementVO );
		}

		private function onChangeControllerHandler( e:MenuEvent ):void
		{
			this._editorMain.setControl( e.id );
		}
	}
}