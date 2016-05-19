package net.fpp.starlingtdleveleditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import net.fpp.starlingtdleveleditor.assets.library.LibraryElementVO;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.PolygonToolController;

	import net.fpp.starlingtdleveleditor.data.LevelDataVO;
	import net.fpp.starlingtdleveleditor.events.EditorLibraryEvent;
	import net.fpp.starlingtdleveleditor.events.EditorWorldEvent;

	public class EditorMain extends BaseUIComponent
	{
		protected const DEFAULT_WORLD_SIZE:Point = new Point( 1600, 1600 );

		public static const CONTROL_TYPE_SELECT:String = 'EditorMain.CONTROL_TYPE_SELECT';
		public static const CONTROL_TYPE_POLYGON:String = 'EditorMain.CONTROL_TYPE_POLYGON';

		protected var _background:Sprite;
		protected var _polygonContainer:Sprite;
		protected var _markerContainer:Sprite;
		protected var _libraryElementContainer:Sprite;
		protected var _graphicsMarkContainer:Sprite;

		protected var _sizeMarkers:Vector.<TextField> = new Vector.<TextField>;
		protected var _libraryElements:Vector.<LibraryElement> = new Vector.<LibraryElement>;

		protected var _controlType:String = '';
		protected var _dragStartPoint:Point = new Point;
		protected var _dragStartMousePoint:Point = new Point;

		protected var _blockWorldDrag:Boolean = false;

		protected var _polygonToolController:PolygonToolController;

		public function EditorMain()
		{
		}

		override protected function inited():void
		{
			addChild( _background = new Sprite );
			addChild( _polygonContainer = new Sprite );
			addChild( _markerContainer = new Sprite );
			addChild( _libraryElementContainer = new Sprite );
			addChild( _graphicsMarkContainer = new Sprite );

			draw();

			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownHandler );
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUpHandler );

			this.initControllers();
		}

		protected function initControllers():void
		{
			//this._polygonToolController = new PolygonToolController( this, this._polygonContainer );
		}

		protected function onMouseDownHandler( e:MouseEvent ):void
		{
			if( e.target is LibraryElement )
			{
				return;
			}

			addEventListener( MouseEvent.MOUSE_MOVE, onMouseMoveHandler );

			_dragStartPoint.setTo( x, y );
			_dragStartMousePoint.setTo( mouseX, mouseY );

		}

		protected function onMouseMoveHandler( event:MouseEvent ):void
		{
			if( Point.distance( _dragStartMousePoint, new Point( mouseX, mouseY ) ) > 10 && !_blockWorldDrag )
			{
				startDrag( false );
			}
		}

		protected function onStageMouseUpHandler( e:MouseEvent ):void
		{
			removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMoveHandler );

			stopDrag();
			normalizePositions();
		}

		protected function draw():void
		{
			removeSizeMarkers();

			_background.graphics.clear();

			_background.graphics.beginFill( 0xFFFFFF, .2 );
			_background.graphics.drawRect( 0, 0, DEFAULT_WORLD_SIZE.x, DEFAULT_WORLD_SIZE.y );
			_background.graphics.endFill();

			generateSizeMarkers();
		}

		protected function removeSizeMarkers():void
		{
			for( var i:int = 0; i < _sizeMarkers.length; i++ )
			{
				_markerContainer.removeChild( _sizeMarkers[ i ] );
				_sizeMarkers[ i ] = null;
			}
			_sizeMarkers.length = 0;
		}

		protected function generateSizeMarkers():void
		{
			var markerCount:int = Math.floor( _background.width / 200 );

			for( var i:int = 0; i < markerCount; i++ )
			{
				addSizeMarker( i * 200, 0 );
				addSizeMarker( i * 200, _background.height - _sizeMarkers[ 0 ].height );
			}
		}

		protected function addSizeMarker( xPosition:uint, yPosition:uint ):void
		{
			var marker:TextField = createMarkerText( xPosition );
			marker.y = yPosition;

			_markerContainer.addChild( marker );
			_sizeMarkers.push( marker );
		}

		protected function createMarkerText( xPosition:uint ):TextField
		{
			var marker:TextField = new TextField();
			marker.text = '| ' + String( xPosition );
			marker.autoSize = 'left';
			marker.alpha = .3;
			marker.x = xPosition;

			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.size = 10;
			textFormat.font = 'verdana';

			marker.setTextFormat( textFormat );

			return marker
		}

		protected function normalizePositions():void
		{
			x = normalizePixelCoordinateWithScale( x );
			y = normalizePixelCoordinateWithScale( y );
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

		public function setControl( type:String ):void
		{
			this._controlType = type;
			trace('>>>',this._controlType);

			/*this.deactivateLibraryElements();

			this._polygonToolController.deactivate();

			this.removeControllerListeners();

			_blockWorldDrag = false;

			switch( _controlType )
			{
				case CONTROL_TYPE_SELECT:
					this.activateLibraryElements();
					break;

				case CONTROL_TYPE_POLYGON:
					this._polygonToolController.activate();
					break;
			}*/
		}

		protected function removeControllerListeners():void
		{
		}

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

		public function loadLevel( levelData:LevelDataVO ):void
		{
			if( levelData.polygons )
			{
				this._polygonToolController.loadPolygons( levelData.polygons );
			}

			if( levelData.libraryElements )
			{
				this.loadLibraryElements( levelData.libraryElements );
			}
		}

		private function loadLibraryElements( datas:Array ):void
		{
			var length:int = datas.length;

			for( var i:int = 0; i < length; i++ )
			{
				var libraryElementVO:LibraryElementVO = new LibraryElementVO( 'importlevel', datas[i].className );
				libraryElementVO.scale = datas[i].scale;
				libraryElementVO.position = new Point( datas[i].x + this.x, datas[i].y + this.y );

				this.addLibraryElement( libraryElementVO );
			}
		}

		public function getLevelData():LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO();

			levelData.polygons = this._polygonToolController.getPolygons();
			levelData.libraryElements = this.createLibraryElementExportData();

			return levelData;
		}

		private function createLibraryElementExportData():Array
		{
			var result:Array = [];

			var length:int = this._libraryElements.length;

			for( var i:int = 0; i < length; i++ )
			{
				var libraryElementVO:LibraryElementVO = this._libraryElements[i].getLibraryElementVO();

				result.push( { className: libraryElementVO.className, scale: libraryElementVO.scale, x: libraryElementVO.position.x, y: libraryElementVO.position.y } );
			}

			return result;
		}

		public function isWorldDragged():Boolean
		{
			return Point.distance( _dragStartPoint, new Point( x, y ) ) != 0;
		}

		public function set blockWorldDrag( value:Boolean ):void
		{
			_blockWorldDrag = value;
		}

		override public function get width():Number
		{
			return _background.width;
		}

		override public function get height():Number
		{
			return _background.height;
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