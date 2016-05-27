package
{
	import assets.TerrainTextures;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.static.FPPContextMenu;
	import net.fpp.starlingtdleveleditor.EditorWorld;
	import net.fpp.starlingtdleveleditor.Menu;
	import net.fpp.starlingtdleveleditor.config.ToolConfig;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.events.MenuEvent;
	import net.fpp.starlingtdleveleditor.vo.ToolConfigVO;

	public class MapEditorMain extends Sprite
	{
		private var _editorMain:EditorWorld;

		private var _menu:Menu;
		//private var _editorLibrary:EditorLibrary;

		public function MapEditorMain()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;

			StaticBitmapAssetManager.scaleFactor = 2;
			StaticBitmapAssetManager.instance.loadFromJSONAtlas( TerrainTextures.AtlasImage, TerrainTextures.AtlasDescription );

			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );

			FPPContextMenu.create( this );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler );

			this.addChild( this._editorMain = new EditorWorld );
			this.addChild( this._menu = new Menu );

			this.createTools();

			/*this._editorLibrary = new EditorLibrary();
			 this._editorLibrary.addEventListener( EditorLibraryEvent.OPEN_REQUEST, onEditorLibraryOpenHandler )
			 this._editorLibrary.addEventListener( EditorLibraryEvent.ADD_ELEMENT_TO_WORLD_REQUEST, onAddelementToWorldRequestHandler )
			 this.addChild( this._editorLibrary );*/
		}

		private function createTools():void
		{
			var toolConfig:ToolConfig = new ToolConfig();

			for( var i:int = 0; i < toolConfig.configs.length; i++ )
			{
				var config:ToolConfigVO = toolConfig.configs[ i ];

				this._menu.addElement( config.id, config.name, config.iconImageSrc, config.isSelectable );
				this._menu.addEventListener( MenuEvent.CHANGE_CONTROLLER, onChangeControllerHandler );

				var toolController:AToolController = new config.toolControllerClass();
				toolController.id = config.id;
				toolController.isSelectable = config.isSelectable;

				this._editorMain.registerToolController( config.id, toolController );
			}
		}

		private function onChangeControllerHandler( e:MenuEvent ):void
		{
			this._editorMain.selectToolController( e.id );
		}

		/*
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
		 }*/
	}
}