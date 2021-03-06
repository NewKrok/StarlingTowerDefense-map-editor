package net.fpp.starlingtdleveleditor.controller.polygonbackground
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.events.PolygonBackgroundToolMenuEvent;
	import net.fpp.starlingtowerdefense.game.config.terraintexture.PolygonBackgroundTerrainTextureConfig;
	import net.fpp.starlingtowerdefense.game.module.background.polygonbackground.vo.PolygonBackgroundTerrainTextureVO;
	import net.fpp.starlingtowerdefense.util.BrushPattern;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;

	public class PolygonBackgroundToolController extends AToolController
	{
		private const MIN_DISTANCE:Number = 100;

		protected var _polygonViews:Vector.<PolygonView> = new <PolygonView>[];

		protected var _polygonViewContainer:Sprite;

		protected var _draggedNode:PolygonNodeView;

		protected var _polygonBackgroundToolMenu:PolygonBackgroundToolMenu;

		private var _lastAddedNodeTime:Number = 0;
		private var _lastSelectedPolygonIndex:int = 0;
		private var _selectedPolygonView:PolygonView;
		private var _draggedPolygonView:PolygonView;
		private var _lastDragPolygonViewPoint:SimplePoint;

		public function PolygonBackgroundToolController()
		{
			this._polygonBackgroundToolMenu = new PolygonBackgroundToolMenu();
		}

		override protected function viewContainerInited():void
		{
			this._view.addChild( this._polygonViewContainer = new Sprite() );
		}

		override public function activate():void
		{
			super.activate();

			this.showNodePoints();

			this._view.addEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onPolygonMouseDown );
		}

		override public function deactivate():void
		{
			super.deactivate();

			this.hideNodePoints();
			this.closePolygonToolMenu();

			this._view.removeEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onPolygonMouseDown );
		}

		private function showNodePoints():void
		{
			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				this._polygonViews[ i ].showNodePoints();
			}
		}

		private function hideNodePoints():void
		{
			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				this._polygonViews[ i ].hideNodePoints();
			}
		}

		protected function onRouteMouseMove( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				this.draw();
			}
			else if( this._lastDragPolygonViewPoint )
			{
				for( var i:int = 0; i < this._polygonViews.length; i++ )
				{
					if( this._draggedPolygonView == this._polygonViews[ i ] )
					{
						for( var j:int = 0; j < this._polygonViews[ i ].polygonNodeViews.length; j++ )
						{
							var polygonNodeView:PolygonNodeView = this._polygonViews[ i ].polygonNodeViews[ j ];

							polygonNodeView.x += this._view.mouseX - this._lastDragPolygonViewPoint.x;
							polygonNodeView.y += this._view.mouseY - this._lastDragPolygonViewPoint.y;
						}
					}
				}

				this.draw();
				this._lastDragPolygonViewPoint = new SimplePoint( this._view.mouseX, this._view.mouseY );
			}
		}

		protected function onPolygonMouseDown( e:MouseEvent ):void
		{
			if( e.target is PolygonNodeView )
			{
				this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

				this._draggedNode = e.target as PolygonNodeView;
				( this._draggedNode as Sprite ).startDrag();

				this.closePolygonToolMenu();
			}
			else
			{
				for( var i:int = 0; i < this._polygonViews.length; i++ )
				{
					if( ( e.target as Sprite ).parent.parent.parent == this._polygonViews[ i ] )
					{
						this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

						this._draggedPolygonView = this._polygonViews[ i ];

						this._lastDragPolygonViewPoint = new SimplePoint( this._view.mouseX, this._view.mouseY );

						this.closePolygonToolMenu();

						break;
					}
				}
			}
		}

		protected function onStageMouseUpHandler( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				( this._draggedNode as Sprite ).stopDrag();
				this._draggedNode = null;

				this.calculatePolygonNodes();

				this.draw();

				this._lastAddedNodeTime = new Date().time;
			}
			else if( this._lastDragPolygonViewPoint )
			{
				this._lastDragPolygonViewPoint = null;
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function isPolygonToolMenuClicked( e:MouseEvent ):Boolean
		{
			if( !this._polygonBackgroundToolMenu.parent )
			{
				return false;
			}

			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			var localPoint:Point = this._view.localToGlobal( new Point( mouseX, mouseY ) );

			return this._polygonBackgroundToolMenu.hitTestPoint( localPoint.x, localPoint.y );
		}

		private function isPolygonViewClicked( e:MouseEvent ):Boolean
		{
			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				if( this._polygonViews[ i ].hitTestPoint( mouseX, mouseY, true ) )
				{
					return true;
				}
			}

			return false;
		}

		private function calculatePolygonNodes():void
		{
			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				var route:Vector.<PolygonNodeView> = this._polygonViews[ i ].polygonNodeViews;

				for( var j:int = 0; j < route.length; j++ )
				{
					var distance:Number;
					var xLength:Number;
					var yLength:Number;
					var angle:Number;
					var newPoint:Point;
					var index:int;

					if( j == 0 )
					{
						xLength = route[ j ].x - route[ route.length - 1 ].x;
						yLength = route[ j ].y - route[ route.length - 1 ].y;
						index = route.length;
					}
					else
					{
						xLength = route[ j ].x - route[ j - 1 ].x;
						yLength = route[ j ].y - route[ j - 1 ].y;
						index = j - 1;
					}

					distance = Math.sqrt( Math.pow( xLength, 2 ) + Math.pow( yLength, 2 ) );

					if( distance > MIN_DISTANCE * 2 )
					{
						angle = Math.atan2( yLength, xLength ) + Math.PI;

						newPoint = new Point(
								route[ j ].x + MIN_DISTANCE * Math.cos( angle ),
								route[ j ].y + MIN_DISTANCE * Math.sin( angle )
						);

						this._polygonViews[ i ].polygonNodeViews = this.addPolygonNodeView( route, this._polygonViews[ i ], newPoint, index );

						if( index == j - 1 )
						{
							j--;
						}
					}

					var nextDistance:Number;
					if( j == route.length - 1 )
					{
						xLength = route[ j ].x - route[ 0 ].x;
						yLength = route[ j ].y - route[ 0 ].y;
						index = 0;
					}
					else
					{
						xLength = route[ j ].x - route[ j + 1 ].x;
						yLength = route[ j ].y - route[ j + 1 ].y;
						index = j + 1;
					}

					distance = Math.sqrt( Math.pow( xLength, 2 ) + Math.pow( yLength, 2 ) );

					if( distance > MIN_DISTANCE * 2 )
					{
						angle = Math.atan2( yLength, xLength );

						if( angle > Math.PI )
						{
							angle += Math.PI * 2;
						}

						newPoint = new Point(
								route[ j ].x - MIN_DISTANCE * Math.cos( angle ),
								route[ j ].y - MIN_DISTANCE * Math.sin( angle )
						);
						this._polygonViews[ i ].polygonNodeViews = this.addPolygonNodeView( route, this._polygonViews[ i ], newPoint, index );
					}

					route = this._polygonViews[ i ].polygonNodeViews;
				}
			}
		}

		protected function addPolygonRequest( e:MouseEvent ):void
		{
			if( !this._polygonBackgroundToolMenu.parent && !isPolygonToolMenuClicked( e ) && !this.isPolygonViewClicked( e ) && !this._draggedNode && new Date().time - this._lastAddedNodeTime > 1000 )
			{
				this.addNewPolygonToPoint( _view.mouseX, _view.mouseY );
				this.draw();
			}

			if( this._polygonBackgroundToolMenu.parent && !this.isPolygonToolMenuClicked( e ) )
			{
				this.closePolygonToolMenu();
			}
		}

		protected function addNewPolygonToPoint( x:Number, y:Number ):void
		{
			var newPolygon:Vector.<Point> = new <Point>[
				new Point( x - this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 ),
				new Point( x - this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 )
			];

			this.addNewPolygon( newPolygon );
		}

		private function addNewPolygon( polygon:Vector.<Point>, terrainTextureId:String = '' ):void
		{
			var terrainTextureVO:PolygonBackgroundTerrainTextureVO;

			if( terrainTextureId == '' )
			{
				terrainTextureVO = PolygonBackgroundTerrainTextureConfig.instance.getTerrainTextureList()[ 0 ];
			}
			else
			{
				terrainTextureVO = PolygonBackgroundTerrainTextureConfig.instance.getTerrainTextureVO( terrainTextureId );
			}

			var polygonView:PolygonView = new PolygonView( terrainTextureVO );
			polygonView.unmark();

			this._polygonViewContainer.addChild( polygonView );
			this._polygonViews.push( polygonView );

			polygonView.addEventListener( MouseEvent.CLICK, onPolygonClickHandler );

			this.addPolygonNodeViews( polygonView.polygonNodeViews, polygonView.nodeContainer, polygon );
		}

		private function onPolygonClickHandler( e:MouseEvent ):void
		{
			if( !this._isActivated || e.target is PolygonNodeView )
			{
				return;
			}

			if( this._selectedPolygonView )
			{
				this._selectedPolygonView.unmark();
			}

			this._selectedPolygonView = e.currentTarget as PolygonView;
			this._selectedPolygonView.mark();

			this._lastSelectedPolygonIndex = this._polygonViewContainer.getChildIndex( this._selectedPolygonView );

			this.openPolygonToolMenu();
		}

		private function addPolygonNodeViews( target:Vector.<PolygonNodeView>, container:Sprite, points:Vector.<Point> ):void
		{
			for( var i:int = 0; i < points.length; i++ )
			{
				this.addPolygonNodeView( target, container, points[ i ] );
			}
		}

		private function addPolygonNodeView( target:Vector.<PolygonNodeView>, container:Sprite, point:Point, index:int = -1 ):Vector.<PolygonNodeView>
		{
			var polygonNodeView:PolygonNodeView = new PolygonNodeView();
			polygonNodeView.buttonMode = true;
			container.addChild( polygonNodeView );

			polygonNodeView.x = point.x;
			polygonNodeView.y = point.y;

			if( index == -1 || index == target.length )
			{
				target.push( polygonNodeView );
			}
			else
			{
				var newOrderedTarget:Vector.<PolygonNodeView> = new <PolygonNodeView>[];
				for( var i:int = 0; i < target.length; i++ )
				{
					if( i == index )
					{
						newOrderedTarget.push( polygonNodeView )
					}
					newOrderedTarget.push( target[ i ] );
				}
				target = newOrderedTarget;
			}

			return target;
		}

		private function draw():void
		{
			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				var points:Vector.<SimplePoint> = new <SimplePoint>[];

				this._polygonViews[ i ].graphics.clear();
				this._polygonViews[ i ].graphics.lineStyle( 1 );
				this._polygonViews[ i ].graphics.beginFill( 0, .1 );

				var polygon:Vector.<PolygonNodeView> = this._polygonViews[ i ].polygonNodeViews;
				this._polygonViews[ i ].graphics.moveTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new SimplePoint( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				for( var j:int = 1; j < polygon.length; j++ )
				{
					this._polygonViews[ i ].graphics.lineTo( polygon[ j ].x, polygon[ j ].y );
					points.push( new SimplePoint( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
					points.push( new SimplePoint( polygon[ j ].x / 2, polygon[ j ].y / 2 ) );
				}

				this._polygonViews[ i ].graphics.lineTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new SimplePoint( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
				points.push( new SimplePoint( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				this._polygonViews[ i ].graphics.endFill();

				if( this._polygonViews[ i ].inGameGraphicsContainer.numChildren > 0 )
				{
					this._polygonViews[ i ].inGameGraphicsContainer.removeChildAt( 0 );
				}

				this._polygonViews[ i ].inGameGraphicsContainer.addChild( this.createIngameGraphics( points, this._polygonViews[ i ].terrainTextureVO ) );
			}
		}

		private function createIngameGraphics( points:Vector.<SimplePoint>, terrainTextureVO:PolygonBackgroundTerrainTextureVO ):DisplayObject
		{
			var ingameGraphics:Sprite = new BrushPattern(
					points,
					terrainTextureVO.borderTextureId ? StaticBitmapAssetManager.instance.getBitmapData( terrainTextureVO.borderTextureId ) : null,
					terrainTextureVO.contentTextureId ? StaticBitmapAssetManager.instance.getBitmapData( terrainTextureVO.contentTextureId ) : null,
					30 / 2,
					40 / 2
			);

			return ingameGraphics;
		}

		private function openPolygonToolMenu():void
		{
			this._uiContainer.addChild( this._polygonBackgroundToolMenu );

			var globalPoint:Point = this._view.localToGlobal( new Point( this._view.mouseX, this._view.mouseY ) );

			this._polygonBackgroundToolMenu.x = globalPoint.x;
			this._polygonBackgroundToolMenu.y = globalPoint.y;

			this._polygonBackgroundToolMenu.addEventListener( PolygonBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
			this._polygonBackgroundToolMenu.addEventListener( PolygonBackgroundToolMenuEvent.BRING_FORWARD, this.onBringForwardPolyginRequestHandler );
			this._polygonBackgroundToolMenu.addEventListener( PolygonBackgroundToolMenuEvent.SEND_BACKWARD, this.onSendBackwardPolyginRequestHandler );
			this._polygonBackgroundToolMenu.addEventListener( PolygonBackgroundToolMenuEvent.CLOSE_REQUEST, this.onClosePolyginRequestHandler );
			this._polygonBackgroundToolMenu.addEventListener( PolygonBackgroundToolMenuEvent.DELETE_REQUEST, this.onDeletePolyginRequestHandler );
			this._polygonBackgroundToolMenu.enable();
		}

		private function closePolygonToolMenu():void
		{
			if( this._polygonBackgroundToolMenu.parent )
			{
				this._selectedPolygonView.unmark();

				this._uiContainer.removeChild( this._polygonBackgroundToolMenu );

				this._polygonBackgroundToolMenu.removeEventListener( PolygonBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
				this._polygonBackgroundToolMenu.removeEventListener( PolygonBackgroundToolMenuEvent.BRING_FORWARD, this.onBringForwardPolyginRequestHandler );
				this._polygonBackgroundToolMenu.removeEventListener( PolygonBackgroundToolMenuEvent.SEND_BACKWARD, this.onSendBackwardPolyginRequestHandler );
				this._polygonBackgroundToolMenu.removeEventListener( PolygonBackgroundToolMenuEvent.CLOSE_REQUEST, this.onClosePolyginRequestHandler );
				this._polygonBackgroundToolMenu.removeEventListener( PolygonBackgroundToolMenuEvent.DELETE_REQUEST, this.onDeletePolyginRequestHandler );
				this._polygonBackgroundToolMenu.disable();
			}
		}

		private function onTerrainTextureChangeRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			this._polygonViews[ this._lastSelectedPolygonIndex ].terrainTextureVO = e.terrainTextureVO;

			this.draw();
		}

		private function onBringForwardPolyginRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			if( this._lastSelectedPolygonIndex < this._polygonViewContainer.numChildren - 1 )
			{
				this._polygonViewContainer.swapChildrenAt( this._lastSelectedPolygonIndex, this._lastSelectedPolygonIndex + 1 );

				var savedPolygonView:PolygonView = this._polygonViews[ this._lastSelectedPolygonIndex ];
				this._polygonViews[ this._lastSelectedPolygonIndex ] = this._polygonViews[ this._lastSelectedPolygonIndex + 1 ];
				this._polygonViews[ this._lastSelectedPolygonIndex + 1 ] = savedPolygonView;

				this._lastSelectedPolygonIndex++;

				this.draw();
			}
		}

		private function onSendBackwardPolyginRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			if( this._lastSelectedPolygonIndex > 0 )
			{
				this._polygonViewContainer.swapChildrenAt( this._lastSelectedPolygonIndex, this._lastSelectedPolygonIndex - 1 );

				var savedPolygonView:PolygonView = this._polygonViews[ this._lastSelectedPolygonIndex ];
				this._polygonViews[ this._lastSelectedPolygonIndex ] = this._polygonViews[ this._lastSelectedPolygonIndex - 1 ];
				this._polygonViews[ this._lastSelectedPolygonIndex - 1 ] = savedPolygonView;

				this._lastSelectedPolygonIndex--;

				this.draw();
			}
		}

		private function onClosePolyginRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			this.closePolygonToolMenu();
		}

		private function onDeletePolyginRequestHandler( e:PolygonBackgroundToolMenuEvent ):void
		{
			var polygonView:PolygonView = this._polygonViews[ this._lastSelectedPolygonIndex ];
			polygonView.dispose();
			polygonView.removeEventListener( MouseEvent.CLICK, onPolygonClickHandler );

			this._polygonViewContainer.removeChild( polygonView );
			this._polygonViews.splice( this._lastSelectedPolygonIndex, 1 );

			this.closePolygonToolMenu();

			this.draw();
		}

		override public function setLevelDataVO( levelDataVO:LevelDataVO ):void
		{
			if( !levelDataVO.polygonBackgroundData )
			{
				return;
			}

			for( var i:int = 0; i < levelDataVO.polygonBackgroundData.length; i++ )
			{
				var newPolygon:Vector.<Point> = new <Point>[];
				var polygon:Vector.<SimplePoint> = levelDataVO.polygonBackgroundData[ i ].polygon;

				for( var j:int = 0; j < polygon.length; j++ )
				{
					newPolygon.push( new Point( polygon[ j ].x, polygon[ j ].y ) );
				}

				this.addNewPolygon( newPolygon, levelDataVO.polygonBackgroundData[ i ].terrainTextureId );
			}

			this.draw();
		}

		override public function getLevelDataVO():LevelDataVO
		{
			var levelDataVO:LevelDataVO = new LevelDataVO();

			var polygonBackgroundDatas:Vector.<PolygonBackgroundVO> = new <PolygonBackgroundVO>[];

			for( var i:int = 0; i < this._polygonViews.length; i++ )
			{
				var polygonElements:Vector.<SimplePoint> = new <SimplePoint>[];

				for( var j:int = 0; j < this._polygonViews[ i ].polygonNodeViews.length; j++ )
				{
					polygonElements.push( new SimplePoint(
							this._polygonViews[ i ].polygonNodeViews[ j ].x,
							this._polygonViews[ i ].polygonNodeViews[ j ].y
					) );
				}

				polygonBackgroundDatas.push( new PolygonBackgroundVO( this._polygonViews[ i ].terrainTextureVO.id, polygonElements ) );
			}

			levelDataVO.polygonBackgroundData = polygonBackgroundDatas;

			return levelDataVO;
		}
	}
}