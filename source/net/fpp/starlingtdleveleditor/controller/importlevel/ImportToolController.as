/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.importlevel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtowerdefense.vo.EnemyPathDataVO;
	import net.fpp.starlingtowerdefense.vo.EnemyPathPointVO;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;
	import net.fpp.starlingtowerdefense.vo.RectangleBackgroundVO;

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
				levelDataVO = convertJSONDataToLevelData( JSON.parse( data ) );
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

		protected function convertJSONDataToLevelData( data:Object ):LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO;
			levelData.createEmptyDatas();

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
				else if( levelData[ key ] is Vector.<RectangleBackgroundVO> )
				{
					levelData[ key ] = new Vector.<RectangleBackgroundVO>;

					for( i = 0; i < data[ key ].length; i++ )
					{
						var rectangleBackgroundVO:RectangleBackgroundVO = new RectangleBackgroundVO();
						rectangleBackgroundVO.polygon = this.arrayToSimplePointVector( data[ key ][ i ].polygon as Array );
						rectangleBackgroundVO.terrainTextureId = data[ key ][ i ].terrainTextureId;

						levelData[ key ].push( rectangleBackgroundVO );
					}
				}
				else if( levelData[ key ] is Vector.<EnemyPathDataVO> )
				{
					levelData[ key ] = new Vector.<EnemyPathDataVO>;

					for( i = 0; i < data[ key ].length; i++ )
					{
						var enemyPathDataVO:EnemyPathDataVO = new EnemyPathDataVO();
						enemyPathDataVO.id = data[ key ][ i ].id;
						enemyPathDataVO.enemyPathPoints = new <EnemyPathPointVO>[];

						for( var j:int = 0; j < data[ key ][ i ].enemyPathPoints.length; j++ )
						{
							var enemyPathPointData:Object = data[ key ][ i ].enemyPathPoints[ j ];
							enemyPathDataVO.enemyPathPoints.push( new EnemyPathPointVO( enemyPathPointData.radius, new SimplePoint( enemyPathPointData.point.x, enemyPathPointData.point.y ) ) );
						}

						levelData[ key ].push( enemyPathDataVO );
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