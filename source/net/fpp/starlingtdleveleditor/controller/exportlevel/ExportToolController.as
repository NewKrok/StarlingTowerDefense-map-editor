/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.exportlevel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.describeType;

	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.events.MenuEvent;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;

	public class ExportToolController extends AToolController
	{
		private var _background:Sprite;
		private var _dialog:ExportDialog;

		private var _container:Sprite;

		override protected function uiContainerInited():void
		{
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

			this._container.addChild( this._dialog = new ExportDialog );
			this._dialog.outputText.text = '';

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
			dispatchEvent( new MenuEvent( MenuEvent.CLOSE_REQUEST ) );
		}

		protected function convertLevelDataToJSONString( levelDataVO:LevelDataVO ):String
		{
			var data:Object = {};

			data.libraryElements = levelDataVO.libraryElements;
			data.polygonBackgroundData = levelDataVO.polygonBackgroundData;

			return JSON.stringify( data );
		}

		public function show():void
		{
			this._container.visible = true;

			var levelDataVO:LevelDataVO = new LevelDataVO();

			for( var key:String in this._toolControllers )
			{
				var toolController:AToolController = this._toolControllers[ key ] as AToolController;

				if( toolController.isSelectable )
				{
					var toolControllerLevelDataVO:LevelDataVO = toolController.getLevelDataVO();
					var levelDataProperties:XML = describeType( toolControllerLevelDataVO );

					for( var levelDataProperty:String in levelDataProperties.variable )
					{
						var propertyName:String = levelDataProperties.variable[ levelDataProperty ].@name;

						if( toolControllerLevelDataVO[ propertyName ] )
						{
							levelDataVO[ propertyName ] = toolControllerLevelDataVO[ propertyName ];
						}
					}
				}
			}

			_dialog.outputText.text = convertLevelDataToJSONString( levelDataVO );

			this._view.stage.focus = this._dialog.outputText;
			( this._dialog.outputText as TextField ).setSelection( 0, this._dialog.outputText.text.length );
		}

		public function hide():void
		{
			this._container.visible = false;
		}

		override public function activate():void
		{
			this.show();

			this._dialog.largeCloseButton.addEventListener( MouseEvent.CLICK, closeButtonHandler );
			this._dialog.closeButton.addEventListener( MouseEvent.CLICK, closeButtonHandler );
		}

		override public function deactivate():void
		{
			this.hide();

			this._dialog.largeCloseButton.removeEventListener( MouseEvent.CLICK, closeButtonHandler );
			this._dialog.closeButton.removeEventListener( MouseEvent.CLICK, closeButtonHandler );
		}
	}
}