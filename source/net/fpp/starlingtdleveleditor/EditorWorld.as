package net.fpp.starlingtdleveleditor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import net.fpp.starlingtdleveleditor.background.BluePrintBackground;
	import net.fpp.starlingtdleveleditor.background.EditorMainBackground;
	import net.fpp.starlingtdleveleditor.background.ToolViewContainerBackground;
	import net.fpp.starlingtdleveleditor.constant.CEditor;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;

	public class EditorWorld extends BaseUIComponent
	{
		private var _toolControllers:Dictionary = new Dictionary();
		private var _toolViewContainers:Vector.<Sprite> = new <Sprite>[];

		private var _bluePrintBackground:BluePrintBackground;
		private var _editorMainBackground:EditorMainBackground;
		private var _zoomView:ZoomView;

		private var _mainContainer:Sprite;
		private var _uiContainer:Sprite;

		private var _selectedToolControllerId:String = '';

		private var _dragStartMousePoint:Point = new Point;

		private var _isEditorWorldDragged:Boolean;
		private var _blockWorldDrag:Boolean;

		public function EditorWorld()
		{
			this._bluePrintBackground = new BluePrintBackground;
			this.addChild( this._bluePrintBackground );

			this.addChild( this._mainContainer = new Sprite() );
			this._mainContainer.addEventListener( Event.RESIZE, this.onResizeHandler );

			this._mainContainer.addChild( this._editorMainBackground = new EditorMainBackground() );

			this._uiContainer = new Sprite();
			this.addChild( this._uiContainer );

			this._zoomView = new ZoomView();
			this._zoomView.buttonMode = true;
			this._zoomView.mouseChildren = false;
			this._zoomView.addEventListener( MouseEvent.CLICK, onZoomViewDoubleClickHandler );
			this._uiContainer.addChild( this._zoomView );
		}

		private function onZoomViewDoubleClickHandler( e:MouseEvent ):void
		{
			this._mainContainer.scaleX = this._mainContainer.scaleY = 1;
			this._mainContainer.dispatchEvent( new Event( Event.RESIZE ) );
		}

		private function onResizeHandler( e:Event ):void
		{
			this.normalizePositions();

			this._bluePrintBackground.setScale( this._mainContainer.scaleX );
			this._zoomView.setZoom( this._mainContainer.scaleX );
		}

		public function registerToolController( id:String, toolController:AToolController ):void
		{
			var toolViewContainer:ToolViewContainerBackground = new ToolViewContainerBackground();
			this._mainContainer.addChild( toolViewContainer );

			toolController.setViewContainer( toolViewContainer );
			toolController.setMainContainer( this._mainContainer );
			toolController.setUIContainer( this._uiContainer );
			toolController.setTools( this._toolControllers );

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
			var toolController:AToolController = this._toolControllers[ id ];

			if( toolController.isSelectable )
			{
				this._selectedToolControllerId = id;

				this.deactivateAllToolController();
			}

			toolController.activate();
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
			this._mainContainer.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );
		}

		protected function onMouseDownHandler( e:MouseEvent ):void
		{
			if( !this._blockWorldDrag )
			{
				this._mainContainer.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

				this._dragStartMousePoint.setTo( this._mainContainer.mouseX, this._mainContainer.mouseY );
			}
		}

		protected function onMouseMoveHandler( event:MouseEvent ):void
		{
			if( Point.distance( this._dragStartMousePoint, new Point( this._mainContainer.mouseX, this._mainContainer.mouseY ) ) > CEditor.MINIMUM_DRAG_DISTANCE )
			{
				this._isEditorWorldDragged = true;

				this.disableMouseActionsInToolControllers();
				this._mainContainer.startDrag( false );
			}
		}

		protected function onStageMouseUpHandler( e:MouseEvent ):void
		{
			this._mainContainer.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );

			this.enableMouseActionsInToolControllers();
			this._isEditorWorldDragged = false;

			this._mainContainer.stopDrag();
			this.normalizePositions();
		}

		protected function normalizePositions():void
		{
			this._mainContainer.x = this.normalizePixelCoordinateWithScale( this._mainContainer.x );
			this._mainContainer.y = this.normalizePixelCoordinateWithScale( this._mainContainer.y );
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
		/*
		 public function loadLevel( levelData:* ):void
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
		 */
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

		override public function get width():Number
		{
			return this._editorMainBackground.width;
		}

		override public function get height():Number
		{
			return this._editorMainBackground.height;
		}

		private function normalizePixelCoordinateWithScale( value:Number ):Number
		{
			return snapToGrid( value, PIXEL_SNAP_VALUE * this._mainContainer.scaleX );
		}

		private function normalizePixelCoordinate( value:Number ):Number
		{
			return snapToGrid( value );
		}
	}
}