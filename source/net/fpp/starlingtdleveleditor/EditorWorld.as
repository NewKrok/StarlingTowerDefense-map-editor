package net.fpp.starlingtdleveleditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import net.fpp.starlingtdleveleditor.assets.library.LibraryElementVO;
	import net.fpp.starlingtdleveleditor.background.EditorMainBackground;
	import net.fpp.starlingtdleveleditor.background.ToolViewContainerBackground;
	import net.fpp.starlingtdleveleditor.constant.CEditor;
	import net.fpp.starlingtdleveleditor.controller.AToolController;
	import net.fpp.starlingtdleveleditor.controller.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.data.LevelDataVO;
	import net.fpp.starlingtdleveleditor.events.EditorWorldEvent;

	public class EditorWorld extends BaseUIComponent
	{
		private var _toolControllers:Dictionary = new Dictionary();
		private var _toolViewContainers:Vector.<Sprite> = new <Sprite>[];

		private var _editorMainBackground:EditorMainBackground;

		private var _selectedToolControllerId:String = '';

		private var _dragStartMousePoint:Point = new Point;

		private var _isEditorWorldDragged:Boolean;
		private var _blockWorldDrag:Boolean;

		public function EditorWorld()
		{
			this.addChild( this._editorMainBackground = new EditorMainBackground() );
		}

		public function registerToolController( id:String, toolController:AToolController ):void
		{
			var toolViewContainer:ToolViewContainerBackground = new ToolViewContainerBackground();
			this.addChild( toolViewContainer );

			toolController.setViewContainer( toolViewContainer );

			toolController.addEventListener( ToolControllerEvent.MOUSE_ACTION_STARTED, this.onToolControllerMouseActionStarted );
			toolController.addEventListener( ToolControllerEvent.MOUSE_ACTION_STOPPED, this.onToolControllerMouseActionStopped );

			this._toolViewContainers.push( toolViewContainer );
			this._toolControllers[ id ] = toolController;
		}

		private function onToolControllerMouseActionStarted( e:ToolControllerEvent ):void
		{
			this._blockWorldDrag = true;
		}

		private function onToolControllerMouseActionStopped( e:ToolControllerEvent ):void
		{
			this._blockWorldDrag = false;
		}

		public function selectToolController( id:String ):void
		{
			this._selectedToolControllerId = id;

			this.deactivateAllToolController();

			this._toolControllers[ this._selectedToolControllerId ].activate();
		}

		private function deactivateAllToolController():void
		{
			for( var key:String in this._toolControllers )
			{
				this._toolControllers[ key ].deactivate();
			}
		}

		override protected function inited():void
		{
			this.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );
		}

		protected function onMouseDownHandler( e:MouseEvent ):void
		{
			if ( !this._blockWorldDrag )
			{
				this.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

				_dragStartMousePoint.setTo( mouseX, mouseY );
			}
		}

		protected function onMouseMoveHandler( event:MouseEvent ):void
		{
			if( Point.distance( _dragStartMousePoint, new Point( mouseX, mouseY ) ) > CEditor.MINIMUM_DRAG_DISTANCE )
			{
				this._isEditorWorldDragged = true;

				this.disableMouseActionsInToolControllers();
				this.startDrag( false );
			}
		}

		protected function onStageMouseUpHandler( e:MouseEvent ):void
		{
			this.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			this.enableMouseActionsInToolControllers();
			this._isEditorWorldDragged = false;

			this.stopDrag();
			this.normalizePositions();
		}

		protected function normalizePositions():void
		{
			this.x = this.normalizePixelCoordinateWithScale( this.x );
			this.y = this.normalizePixelCoordinateWithScale( this.y );
		}

		private function disableMouseActionsInToolControllers():void
		{
			for( var key:String in this._toolControllers )
			{
				this._toolControllers[ key ].mouseEnabled = false;
			}
		}

		private function enableMouseActionsInToolControllers():void
		{
			for( var key:String in this._toolControllers )
			{
				this._toolControllers[ key ].mouseEnabled = true;
			}
		}














		public function zoomIn():void
		{
			this.scaleX += .1;

			this.scaleX = Math.min( this.scaleX, 2 );

			this.scaleY = this.scaleX;

			this.normalizePositions();

			this.dispatchEvent( new EditorWorldEvent( EditorWorldEvent.ON_VIEW_RESIZE, this.scaleX ) );
		}

		public function zoomOut():void
		{
			this.scaleX -= .1;

			this.scaleX = Math.max( this.scaleX, .2 );

			this.scaleY = this.scaleX;

			this.normalizePositions();

			this.dispatchEvent( new EditorWorldEvent( EditorWorldEvent.ON_VIEW_RESIZE, this.scaleX ) );
		}

		protected function removeControllerListeners():void
		{
		}
/*
		public function addLibraryElement( elementVO:LibraryElementVO ):void
		{
			elementVO.position.x -= this.x;
			elementVO.position.y -= this.y;

			var libraryElement:LibraryElement = new LibraryElement( elementVO );
			libraryElement.addEventListener( EditorLibraryEvent.REMOVE_ELEMENT_FROM_WORLD_REQUEST, this.onRemoveLibraryElementRequestHandler );

			this._libraryElements.push( libraryElement );
			this._libraryElementContainer.addChild( libraryElement );

			libraryElement.activate();
		}

		private function onRemoveLibraryElementRequestHandler( e:EditorLibraryEvent ):void
		{
			var length:int = this._libraryElements.length;

			for( var i:int = 0; i < length; i++ )
			{
				if( this._libraryElements[ i ] == e.currentTarget )
				{
					this._libraryElements[ i ].removeEventListener( EditorLibraryEvent.REMOVE_ELEMENT_FROM_WORLD_REQUEST, this.onRemoveLibraryElementRequestHandler );
					this._libraryElements[ i ].deactivate();
					this._libraryElementContainer.removeChild( this._libraryElements[ i ] );
					this._libraryElements[ i ] = null;
					this._libraryElements.splice( i, 1 );
					break;
				}
			}
		}

		private function activateLibraryElements():void
		{
			var length:int = this._libraryElements.length;

			for( var i:int = 0; i < length; i++ )
			{
				this._libraryElements[ i ].activate();
			}
		}

		private function deactivateLibraryElements():void
		{
			var length:int = this._libraryElements.length;

			for( var i:int = 0; i < length; i++ )
			{
				this._libraryElements[ i ].deactivate();
			}
		}
*/
		public function loadLevel( levelData:LevelDataVO ):void
		{
			if( levelData.polygons )
			{
			//	this._polygonToolController.loadPolygons( levelData.polygons );
			}

			if( levelData.libraryElements )
			{
			//	this.loadLibraryElements( levelData.libraryElements );
			}
		}

		private function loadLibraryElements( datas:Array ):void
		{
			var length:int = datas.length;

			for( var i:int = 0; i < length; i++ )
			{
				var libraryElementVO:LibraryElementVO = new LibraryElementVO( 'importlevel', datas[ i ].className );
				libraryElementVO.scale = datas[ i ].scale;
				libraryElementVO.position = new Point( datas[ i ].x + this.x, datas[ i ].y + this.y );

				//this.addLibraryElement( libraryElementVO );
			}
		}

		public function getLevelData():LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO();

			//levelData.polygons = this._polygonToolController.getPolygons();
			//levelData.libraryElements = this.createLibraryElementExportData();

			return levelData;
		}
/*
		private function createLibraryElementExportData():Array
		{
			var result:Array = [];

			var length:int = this._libraryElements.length;

			for( var i:int = 0; i < length; i++ )
			{
				var libraryElementVO:LibraryElementVO = this._libraryElements[ i ].getLibraryElementVO();

				result.push( {
					className: libraryElementVO.className,
					scale: libraryElementVO.scale,
					x: libraryElementVO.position.x,
					y: libraryElementVO.position.y
				} );
			}

			return result;
		}
*/
		public function set blockWorldDrag( value:Boolean ):void
		{
			_blockWorldDrag = value;
		}

		override public function get width():Number
		{
			return _editorMainBackground.width;
		}

		override public function get height():Number
		{
			return _editorMainBackground.height;
		}

		private function normalizePixelCoordinateWithScale( value:Number ):Number
		{
			return snapToGrid( value, PIXEL_SNAP_VALUE * this.scaleX );
		}

		private function normalizePixelCoordinate( value:Number ):Number
		{
			return snapToGrid( value );
		}
	}
}