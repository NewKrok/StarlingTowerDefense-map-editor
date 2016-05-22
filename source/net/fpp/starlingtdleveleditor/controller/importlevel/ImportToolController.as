/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.importlevel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.events.MenuEvent;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;

	public class ImportToolController extends AToolController
	{
		private var _background:Sprite;
		private var _dialog:ImportDialog;

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
			dispatchEvent( new MenuEvent( MenuEvent.CLOSE_REQUEST ) );
		}

		protected function startImport( e:MouseEvent ):void
		{
			var data:String = _dialog.inputText.text;

			var levelDataVO:LevelDataVO;
			levelDataVO = convertJSONDataToLevelData( JSON.parse( data ) );

			for( var key:String in this._toolControllers )
			{
				var toolController:AToolController = this._toolControllers[ key ] as AToolController;

				if( toolController.isSelectable )
				{
					toolController.setLevelDataVO( levelDataVO );
				}
			}
		}

		protected function convertJSONDataToLevelData( data:Object ):LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO;

			for( var key:String in data )
			{
				if( levelData[ key ] is Vector.<PolygonBackgroundVO> )
				{
					levelData[ key ] = new Vector.<PolygonBackgroundVO>;

					for( var i:int = 0; i < data[ key ].length; i++ )
					{
						var polygonBackgroundVO:PolygonBackgroundVO = new PolygonBackgroundVO();
						polygonBackgroundVO.polygon = this.arrayToSimplePointVector( data[ key ][ i ].polygon as Array );
						polygonBackgroundVO.terrainTextureId = data[ key ][ i ].terrainTextureId;

						levelData[ key ].push( polygonBackgroundVO );
					}
				}
				else if( levelData[ key ] is Vector.<SimplePoint> )
				{
					levelData[ key ] = this.arrayToSimplePointVector( data[ key ] );
				}
			}

			return levelData;
		}

		private function arrayToSimplePointVector( array:Array ):Vector.<SimplePoint>
		{
			var simplePointVector:Vector.<SimplePoint> = new <SimplePoint>[];

			for( var i:int = 0; i < array.length; i++ )
			{
				simplePointVector.push( new SimplePoint( array[ i ].x, array[ i ].y ) );
			}

			return simplePointVector;
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