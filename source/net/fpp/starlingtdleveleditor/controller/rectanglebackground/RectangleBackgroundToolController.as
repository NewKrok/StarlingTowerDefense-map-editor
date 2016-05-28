/**
 * Created by newkrok on 22/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.rectanglebackground
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.rectanglebackground.events.RectangleBackgroundToolMenuEvent;
	import net.fpp.starlingtowerdefense.game.config.terraintexture.RectangleBackgroundTerrainTextureConfig;
	import net.fpp.starlingtowerdefense.game.module.background.rectanglebackground.vo.RectangleBackgroundTerrainTextureVO;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.RectangleBackgroundVO;

	public class RectangleBackgroundToolController extends AToolController
	{
		private const MIN_DISTANCE:Number = 100;

		protected var _rectangleViews:Vector.<RectangleView> = new <RectangleView>[];

		protected var _rectangleViewContainer:Sprite;

		protected var _draggedNode:RectangleNodeView;

		private var _rectangleBackgroundToolMenu:RectangleBackgroundToolMenu;

		private var _lastAddedNodeTime:Number = 0;
		private var _lastSelectedRectangleIndex:int = 0;
		private var _selectedRectanglenView:RectangleView;
		private var _draggedRectangleView:RectangleView;
		private var _lastDragRectangleViewPoint:SimplePoint;

		public function RectangleBackgroundToolController()
		{
			this._rectangleBackgroundToolMenu = new RectangleBackgroundToolMenu();
		}

		override protected function viewContainerInited():void
		{
			this._view.addChild( this._rectangleViewContainer = new Sprite() );
		}

		override public function activate():void
		{
			super.activate();

			this.showNodePoints();

			this._view.addEventListener( MouseEvent.CLICK, this.addRectangleRequest );
			this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onRecangleMouseDown );
		}

		override public function deactivate():void
		{
			super.deactivate();

			this.hideNodePoints();
			this.closeRectangleToolMenu();

			this._view.removeEventListener( MouseEvent.CLICK, this.addRectangleRequest );
			this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._view.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onRecangleMouseDown );
		}

		private function showNodePoints():void
		{
			for( var i:int = 0; i < this._rectangleViews.length; i++ )
			{
				this._rectangleViews[ i ].showNodePoints();
			}
		}

		private function hideNodePoints():void
		{
			for( var i:int = 0; i < this._rectangleViews.length; i++ )
			{
				this._rectangleViews[ i ].hideNodePoints();
			}
		}

		protected function onRouteMouseMove( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				this.updateNodePoints();
				this.draw();
			}
			else if( this._lastDragRectangleViewPoint )
			{
				for( var i:int = 0; i < this._rectangleViews.length; i++ )
				{
					if( this._draggedRectangleView == this._rectangleViews[ i ] )
					{
						for( var j:int = 0; j < this._rectangleViews[ i ].rectangleNodeViews.length; j++ )
						{
							var rectangleNodeView:RectangleNodeView = this._rectangleViews[ i ].rectangleNodeViews[ j ];

							rectangleNodeView.x += this._view.mouseX - this._lastDragRectangleViewPoint.x;
							rectangleNodeView.y += this._view.mouseY - this._lastDragRectangleViewPoint.y;
						}
					}
				}

				this.draw();
				this._lastDragRectangleViewPoint = new SimplePoint( this._view.mouseX, this._view.mouseY );
			}
		}

		private function updateNodePoints():void
		{
			var nodeCount:int = this._draggedRectangleView.rectangleNodeViews.length;

			for( var i:int = 0; i < nodeCount; i++ )
			{
				var nodeView:RectangleNodeView = this._draggedRectangleView.rectangleNodeViews[ i ];

				if( nodeView == this._draggedNode )
				{
					switch( i )
					{
						case 0:
							var previousNodeView:RectangleNodeView = this._draggedRectangleView.rectangleNodeViews[ nodeCount - 1 ];
							var nextNodeView:RectangleNodeView = this._draggedRectangleView.rectangleNodeViews[ i + 1 ];

							previousNodeView.x = this._draggedNode.x;
							nextNodeView.y = this._draggedNode.y;
							break;

						case 1:
							previousNodeView = this._draggedRectangleView.rectangleNodeViews[ i - 1 ];
							nextNodeView = this._draggedRectangleView.rectangleNodeViews[ i + 1 ];

							previousNodeView.y = this._draggedNode.y;
							nextNodeView.x = this._draggedNode.x;
							break;

						case 2:
							previousNodeView = this._draggedRectangleView.rectangleNodeViews[ i - 1 ];
							nextNodeView = this._draggedRectangleView.rectangleNodeViews[ i + 1 ];

							previousNodeView.x = this._draggedNode.x;
							nextNodeView.y = this._draggedNode.y;
							break;

						case 3:
							previousNodeView = this._draggedRectangleView.rectangleNodeViews[ i - 1 ];
							nextNodeView = this._draggedRectangleView.rectangleNodeViews[ 0 ];

							previousNodeView.y = this._draggedNode.y;
							nextNodeView.x = this._draggedNode.x;
							break;
					}
				}
			}
		}

		protected function onRecangleMouseDown( e:MouseEvent ):void
		{
			if( e.target is RectangleNodeView )
			{
				this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

				this._draggedNode = e.target as RectangleNodeView;
				( this._draggedNode as Sprite ).startDrag();

				this.closeRectangleToolMenu();

				for( var i:int = 0; i < this._rectangleViews.length; i++ )
				{
					if( ( this._draggedNode as Sprite ).parent.parent == this._rectangleViews[ i ] )
					{
						this._draggedRectangleView = this._rectangleViews[ i ];

						break;
					}
				}
			}
			else
			{
				for( i = 0; i < this._rectangleViews.length; i++ )
				{
					if( ( e.target as Sprite ).parent.parent == this._rectangleViews[ i ] )
					{
						this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

						this._draggedRectangleView = this._rectangleViews[ i ];

						this._lastDragRectangleViewPoint = new SimplePoint( this._view.mouseX, this._view.mouseY );

						this.closeRectangleToolMenu();

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

				this.draw();

				this._lastAddedNodeTime = new Date().time;
			}
			else if( this._lastDragRectangleViewPoint )
			{
				this._lastDragRectangleViewPoint = null;
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function isRectangleToolMenuClicked( e:MouseEvent ):Boolean
		{
			if ( !this._rectangleBackgroundToolMenu.parent )
			{
				return false;
			}

			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			var localPoint:Point = this._view.localToGlobal( new Point( mouseX, mouseY ) );

			return this._rectangleBackgroundToolMenu.hitTestPoint( localPoint.x, localPoint.y );
		}

		private function isRectangleViewClicked( e:MouseEvent ):Boolean
		{
			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			for( var i:int = 0; i < this._rectangleViews.length; i++ )
			{
				if( this._rectangleViews[ i ].hitTestPoint( mouseX, mouseY, true ) )
				{
					return true;
				}
			}

			return false;
		}

		private function addRectangleRequest( e:MouseEvent ):void
		{
			if( !this._rectangleBackgroundToolMenu.parent && !isRectangleToolMenuClicked( e ) && !this.isRectangleViewClicked( e ) && !this._draggedNode && new Date().time - this._lastAddedNodeTime > 1000 )
			{
				this.addNewRectangleToPoint( _view.mouseX, _view.mouseY );
				this.draw();
			}

			if( this._rectangleBackgroundToolMenu.parent && !this.isRectangleToolMenuClicked( e ) )
			{
				this.closeRectangleToolMenu();
			}
		}

		protected function addNewRectangleToPoint( x:Number, y:Number ):void
		{
			var newRectangle:Vector.<Point> = new <Point>[
				new Point( x - this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 ),
				new Point( x - this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 )
			];

			this.addNewRectangle( newRectangle );
		}

		private function addNewRectangle( polygon:Vector.<Point>, terrainTextureId:String = '' ):void
		{
			var terrainTextureVO:RectangleBackgroundTerrainTextureVO;

			if( terrainTextureId == '' )
			{
				terrainTextureVO = RectangleBackgroundTerrainTextureConfig.instance.getTerrainTextureList()[ 0 ];
			}
			else
			{
				terrainTextureVO = RectangleBackgroundTerrainTextureConfig.instance.getTerrainTextureVO( terrainTextureId );
			}

			var rectangleView:RectangleView = new RectangleView( terrainTextureVO );
			rectangleView.unmark();

			this._rectangleViewContainer.addChild( rectangleView );
			this._rectangleViews.push( rectangleView );

			rectangleView.addEventListener( MouseEvent.CLICK, onPolygonClickHandler );

			this.addRectangleNodeViews( rectangleView.rectangleNodeViews, rectangleView.nodeContainer, polygon );
		}

		private function onPolygonClickHandler( e:MouseEvent ):void
		{
			if( !this._isActivated || e.target is RectangleNodeView )
			{
				return;
			}

			if( this._selectedRectanglenView )
			{
				this._selectedRectanglenView.unmark();
			}

			this._selectedRectanglenView = e.currentTarget as RectangleView;
			this._selectedRectanglenView.mark();

			this._lastSelectedRectangleIndex = this._rectangleViewContainer.getChildIndex( this._selectedRectanglenView );

			this.openRectangleToolMenu();
		}

		private function addRectangleNodeViews( target:Vector.<RectangleNodeView>, container:Sprite, points:Vector.<Point> ):void
		{
			for( var i:int = 0; i < points.length; i++ )
			{
				this.addRectangleNodeView( target, container, points[ i ] );
			}
		}

		private function addRectangleNodeView( target:Vector.<RectangleNodeView>, container:Sprite, point:Point, index:int = -1 ):Vector.<RectangleNodeView>
		{
			var rectangleNodeView:RectangleNodeView = new RectangleNodeView();
			rectangleNodeView.buttonMode = true;
			container.addChild( rectangleNodeView );

			rectangleNodeView.x = point.x;
			rectangleNodeView.y = point.y;

			if( index == -1 || index == target.length )
			{
				target.push( rectangleNodeView );
			}
			else
			{
				var newOrderedTarget:Vector.<RectangleNodeView> = new <RectangleNodeView>[];
				for( var i:int = 0; i < target.length; i++ )
				{
					if( i == index )
					{
						newOrderedTarget.push( rectangleNodeView )
					}
					newOrderedTarget.push( target[ i ] );
				}
				target = newOrderedTarget;
			}

			return target;
		}

		private function draw():void
		{
			for( var i:int = 0; i < this._rectangleViews.length; i++ )
			{
				var points:Vector.<Point> = new <Point>[];

				this._rectangleViews[ i ].graphics.clear();
				this._rectangleViews[ i ].graphics.lineStyle( 1 );
				this._rectangleViews[ i ].graphics.beginFill( 0, .1 );

				var polygon:Vector.<RectangleNodeView> = this._rectangleViews[ i ].rectangleNodeViews;
				this._rectangleViews[ i ].graphics.moveTo( polygon[ 0 ].x, polygon[ 0 ].y );

				for( var j:int = 0; j < polygon.length; j++ )
				{
					this._rectangleViews[ i ].graphics.lineTo( polygon[ j ].x, polygon[ j ].y );
					points.push( new Point( polygon[ j ].x, polygon[ j ].y ) );
				}

				this._rectangleViews[ i ].graphics.lineTo( polygon[ 0 ].x, polygon[ 0 ].y );
				this._rectangleViews[ i ].graphics.endFill();

				if( this._rectangleViews[ i ].inGameGraphicsContainer.numChildren > 0 )
				{
					this._rectangleViews[ i ].inGameGraphicsContainer.removeChildAt( 0 );
				}

				this._rectangleViews[ i ].inGameGraphicsContainer.addChild( this.createIngameGraphics( points, this._rectangleViews[ i ].terrainTextureVO ) );
			}
		}

		private function createIngameGraphics( points:Vector.<Point>, terrainTextureVO:RectangleBackgroundTerrainTextureVO ):DisplayObject
		{
			var ingameGraphics:Sprite = new Sprite()

			ingameGraphics.graphics.beginBitmapFill( StaticBitmapAssetManager.instance.getBitmapData( terrainTextureVO.contentTextureId ) );
			ingameGraphics.graphics.moveTo( points[ 0 ].x, points[ 0 ].y );
			ingameGraphics.graphics.lineTo( points[ 1 ].x, points[ 1 ].y );
			ingameGraphics.graphics.lineTo( points[ 2 ].x, points[ 2 ].y );
			ingameGraphics.graphics.lineTo( points[ 3 ].x, points[ 3 ].y );
			ingameGraphics.graphics.lineTo( points[ 0 ].x, points[ 0 ].y );
			ingameGraphics.graphics.endFill();

			return ingameGraphics;
		}

		private function openRectangleToolMenu():void
		{
			this._uiContainer.addChild( this._rectangleBackgroundToolMenu );

			var globalPoint:Point = this._view.localToGlobal( new Point( this._view.mouseX, this._view.mouseY ) );

			this._rectangleBackgroundToolMenu.x = globalPoint.x;
			this._rectangleBackgroundToolMenu.y = globalPoint.y;

			this._rectangleBackgroundToolMenu.addEventListener( RectangleBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
			this._rectangleBackgroundToolMenu.addEventListener( RectangleBackgroundToolMenuEvent.BRING_FORWARD, this.onBringForwardRectangleRequestHandler );
			this._rectangleBackgroundToolMenu.addEventListener( RectangleBackgroundToolMenuEvent.SEND_BACKWARD, this.onSendBackwardRectangleRequestHandler );
			this._rectangleBackgroundToolMenu.addEventListener( RectangleBackgroundToolMenuEvent.CLOSE_REQUEST, this.onCloseRectangleRequestHandler );
			this._rectangleBackgroundToolMenu.addEventListener( RectangleBackgroundToolMenuEvent.DELETE_REQUEST, this.onDeleteRectangleRequestHandler );
			this._rectangleBackgroundToolMenu.enable();
		}

		private function closeRectangleToolMenu():void
		{
			if( this._rectangleBackgroundToolMenu.parent )
			{
				this._selectedRectanglenView.unmark();

				this._uiContainer.removeChild( this._rectangleBackgroundToolMenu );

				this._rectangleBackgroundToolMenu.removeEventListener( RectangleBackgroundToolMenuEvent.CHANGE_TERRAIN_TEXTURE_REQUEST, this.onTerrainTextureChangeRequestHandler );
				this._rectangleBackgroundToolMenu.removeEventListener( RectangleBackgroundToolMenuEvent.BRING_FORWARD, this.onBringForwardRectangleRequestHandler );
				this._rectangleBackgroundToolMenu.removeEventListener( RectangleBackgroundToolMenuEvent.SEND_BACKWARD, this.onSendBackwardRectangleRequestHandler );
				this._rectangleBackgroundToolMenu.removeEventListener( RectangleBackgroundToolMenuEvent.CLOSE_REQUEST, this.onCloseRectangleRequestHandler );
				this._rectangleBackgroundToolMenu.removeEventListener( RectangleBackgroundToolMenuEvent.DELETE_REQUEST, this.onDeleteRectangleRequestHandler );
				this._rectangleBackgroundToolMenu.disable();
			}
		}

		private function onTerrainTextureChangeRequestHandler( e:RectangleBackgroundToolMenuEvent ):void
		{
			this._rectangleViews[ this._lastSelectedRectangleIndex ].terrainTextureVO = e.terrainTextureVO;

			this.draw();
		}

		private function onBringForwardRectangleRequestHandler( e:RectangleBackgroundToolMenuEvent ):void
		{
			if( this._lastSelectedRectangleIndex < this._rectangleViewContainer.numChildren - 1 )
			{
				this._rectangleViewContainer.swapChildrenAt( this._lastSelectedRectangleIndex, this._lastSelectedRectangleIndex + 1 );

				var savedRectangleView:RectangleView = this._rectangleViews[ this._lastSelectedRectangleIndex ];
				this._rectangleViews[ this._lastSelectedRectangleIndex ] = this._rectangleViews[ this._lastSelectedRectangleIndex + 1 ];
				this._rectangleViews[ this._lastSelectedRectangleIndex + 1 ] = savedRectangleView;

				this._lastSelectedRectangleIndex++;

				this.draw();
			}
		}

		private function onSendBackwardRectangleRequestHandler( e:RectangleBackgroundToolMenuEvent ):void
		{
			if( this._lastSelectedRectangleIndex > 0 )
			{
				this._rectangleViewContainer.swapChildrenAt( this._lastSelectedRectangleIndex, this._lastSelectedRectangleIndex - 1 );

				var savedRectangleView:RectangleView = this._rectangleViews[ this._lastSelectedRectangleIndex ];
				this._rectangleViews[ this._lastSelectedRectangleIndex ] = this._rectangleViews[ this._lastSelectedRectangleIndex - 1 ];
				this._rectangleViews[ this._lastSelectedRectangleIndex - 1 ] = savedRectangleView;

				this._lastSelectedRectangleIndex--;

				this.draw();
			}
		}

		private function onCloseRectangleRequestHandler( e:RectangleBackgroundToolMenuEvent ):void
		{
			this.closeRectangleToolMenu();
		}

		private function onDeleteRectangleRequestHandler( e:RectangleBackgroundToolMenuEvent ):void
		{
			var rectangleView:RectangleView = this._rectangleViews[ this._lastSelectedRectangleIndex ];
			rectangleView.dispose();
			rectangleView.removeEventListener( MouseEvent.CLICK, onPolygonClickHandler );

			this._rectangleViewContainer.removeChild( rectangleView );
			this._rectangleViews.splice( this._lastSelectedRectangleIndex, 1 );

			this.closeRectangleToolMenu();

			this.draw();
		}

		override public function setLevelDataVO( levelDataVO:LevelDataVO ):void
		{
			if( !levelDataVO.rectangleBackgroundData )
			{
				return;
			}

			for( var i:int = 0; i < levelDataVO.rectangleBackgroundData.length; i++ )
			{
				var newPolygon:Vector.<Point> = new <Point>[];
				var polygon:Vector.<SimplePoint> = levelDataVO.rectangleBackgroundData[ i ].polygon;

				for( var j:int = 0; j < polygon.length; j++ )
				{
					newPolygon.push( new Point( polygon[ j ].x, polygon[ j ].y ) );
				}

				this.addNewRectangle( newPolygon, levelDataVO.rectangleBackgroundData[ i ].terrainTextureId );
			}

			this.draw();
		}

		override public function getLevelDataVO():LevelDataVO
		{
			var levelDataVO:LevelDataVO = new LevelDataVO();

			var rectangleBackgroundDatas:Vector.<RectangleBackgroundVO> = new <RectangleBackgroundVO>[];

			for( var i:int = 0; i < this._rectangleViews.length; i++ )
			{
				var polygonElements:Vector.<SimplePoint> = new <SimplePoint>[];

				for( var j:int = 0; j < this._rectangleViews[ i ].rectangleNodeViews.length; j++ )
				{
					polygonElements.push( new SimplePoint(
							this._rectangleViews[ i ].rectangleNodeViews[ j ].x,
							this._rectangleViews[ i ].rectangleNodeViews[ j ].y
					) );
				}

				rectangleBackgroundDatas.push( new RectangleBackgroundVO( this._rectangleViews[ i ].terrainTextureVO.id, polygonElements ) );
			}

			levelDataVO.rectangleBackgroundData = rectangleBackgroundDatas;

			return levelDataVO;
		}
	}
}