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
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.event.PolygonToolMenuEvent;
	import net.fpp.starlingtowerdefense.game.config.terraintexture.TerrainTextureConfig;
	import net.fpp.starlingtowerdefense.game.module.background.terrainbackground.vo.TerrainTextureVO;
	import net.fpp.starlingtowerdefense.utils.BrushPattern;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;

	public class PolygonBackgroundToolController extends AToolController
	{
		private const MIN_DISTANCE:Number = 100;

		protected var _polygonViews:Vector.<PolygonView> = new <PolygonView>[];

		protected var _polygonViewContainer:Sprite;

		protected var _draggedNode:PolygonNodeView;

		protected var _polygonToolMenu:PolygonToolMenu;

		protected var _isActivated:Boolean = false;

		private var _lastAddedNodeTime:Number = 0;
		private var _lastSelectedPolygonIndex:int = 0;
		private var _selectedPolygonView:PolygonView;

		public function PolygonBackgroundToolController()
		{
			this._polygonToolMenu = new PolygonToolMenu();
		}

		override protected function viewContainerInited():void
		{
			this._view.addChild( this._polygonViewContainer = new Sprite() );
		}

		override public function activate():void
		{
			this._isActivated = true;

			this._view.addEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		override public function deactivate():void
		{
			this._isActivated = false;

			this._view.removeEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		protected function onRouteMouseMove( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				this.draw();
			}
		}

		protected function onRouteMouseDown( e:MouseEvent ):void
		{
			if( e.target is PolygonNodeView )
			{
				this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

				this._draggedNode = e.target as PolygonNodeView;
				( this._draggedNode as Sprite ).startDrag();
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

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function isPolygonToolMenuClicked( e:MouseEvent ):Boolean
		{
			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			var localPoint:Point = this._view.localToGlobal( new Point( mouseX, mouseY ) );

			return this._polygonToolMenu.hitTestPoint( localPoint.x, localPoint.y );
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
			if( !this._polygonToolMenu.parent && !isPolygonToolMenuClicked( e ) && !this.isPolygonViewClicked( e ) && !this._draggedNode && new Date().time - this._lastAddedNodeTime > 1000 )
			{
				this.addNewPolygonToPoint( _view.mouseX, _view.mouseY );
				this.draw();
			}

			if( this._polygonToolMenu.parent && !this.isPolygonToolMenuClicked( e ) )
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
			var terrainTextureVO:TerrainTextureVO;

			if ( terrainTextureId == '' )
			{
				terrainTextureVO = TerrainTextureConfig.instance.getTerrainTextureList()[0];
			}
			else
			{
				terrainTextureVO = TerrainTextureConfig.instance.getTerrainTextureVO( terrainTextureId );
			}

			var polygonView:PolygonView = new PolygonView( terrainTextureVO );
			polygonView.unmark();

			this._polygonViewContainer.addChild( polygonView );
			this._polygonViews.push( polygonView );

			polygonView.addEventListener( MouseEvent.CLICK, onPolygonClickHandler );

			this.addPolygonNodeViews( polygonView.polygonNodeViews, polygonView, polygon );
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
				var points:Vector.<Point> = new <Point>[];

				this._polygonViews[ i ].graphics.clear();
				this._polygonViews[ i ].graphics.lineStyle( 1 );
				this._polygonViews[ i ].graphics.beginFill( 0, .1 );

				var polygon:Vector.<PolygonNodeView> = this._polygonViews[ i ].polygonNodeViews;
				this._polygonViews[ i ].graphics.moveTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new Point( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				for( var j:int = 1; j < polygon.length; j++ )
				{
					this._polygonViews[ i ].graphics.lineTo( polygon[ j ].x, polygon[ j ].y );
					points.push( new Point( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
					points.push( new Point( polygon[ j ].x / 2, polygon[ j ].y / 2 ) );
				}

				this._polygonViews[ i ].graphics.lineTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new Point( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
				points.push( new Point( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				this._polygonViews[ i ].graphics.endFill();

				if( !(this._polygonViews[ i ].getChildAt( 0 ) is PolygonNodeView ) )
				{
					this._polygonViews[ i ].removeChildAt( 0 );
				}

				this._polygonViews[ i ].addChildAt( this.createIngameGraphics( points, this._polygonViews[ i ].terrainTextureVO ), 0 );
			}
		}

		private function createIngameGraphics( points:Vector.<Point>, terrainTextureVO:TerrainTextureVO ):DisplayObject
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
			this._view.addChild( this._polygonToolMenu );

			this._polygonToolMenu.x = this._view.mouseX;
			this._polygonToolMenu.y = this._view.mouseY;

			this._polygonToolMenu.addEventListener( PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
			this._polygonToolMenu.addEventListener( PolygonToolMenuEvent.BRING_FORWARD, this.onBringForwardPolyginRequestHandler );
			this._polygonToolMenu.addEventListener( PolygonToolMenuEvent.SEND_BACKWARD, this.onSendBackwardPolyginRequestHandler );
			this._polygonToolMenu.addEventListener( PolygonToolMenuEvent.CLOSE_REQUEST, this.onClosePolyginRequestHandler );
			this._polygonToolMenu.addEventListener( PolygonToolMenuEvent.DELETE_REQUEST, this.onDeletePolyginRequestHandler );
			this._polygonToolMenu.enable();
		}

		private function closePolygonToolMenu():void
		{
			if( this._polygonToolMenu.parent )
			{
				this._selectedPolygonView.unmark();

				this._view.removeChild( this._polygonToolMenu );

				this._polygonToolMenu.removeEventListener( PolygonToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
				this._polygonToolMenu.removeEventListener( PolygonToolMenuEvent.BRING_FORWARD, this.onBringForwardPolyginRequestHandler );
				this._polygonToolMenu.removeEventListener( PolygonToolMenuEvent.SEND_BACKWARD, this.onSendBackwardPolyginRequestHandler );
				this._polygonToolMenu.removeEventListener( PolygonToolMenuEvent.CLOSE_REQUEST, this.onClosePolyginRequestHandler );
				this._polygonToolMenu.removeEventListener( PolygonToolMenuEvent.DELETE_REQUEST, this.onDeletePolyginRequestHandler );
				this._polygonToolMenu.disable();
			}
		}

		private function onTerrainTextureChangeRequestHandler( e:PolygonToolMenuEvent ):void
		{
			this._polygonViews[ this._lastSelectedPolygonIndex ].terrainTextureVO = e.terrainTextureVO;

			this.draw();
		}

		private function onBringForwardPolyginRequestHandler( e:PolygonToolMenuEvent ):void
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

		private function onSendBackwardPolyginRequestHandler( e:PolygonToolMenuEvent ):void
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

		private function onClosePolyginRequestHandler( e:PolygonToolMenuEvent ):void
		{
			this.closePolygonToolMenu();
		}

		private function onDeletePolyginRequestHandler( e:PolygonToolMenuEvent ):void
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