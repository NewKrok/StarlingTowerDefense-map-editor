/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.baselibrary
{
	import com.senocular.display.transform.ControlRegistration;
	import com.senocular.display.transform.ControlUVRotate;
	import com.senocular.display.transform.ControlUVScale;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.common.util.GeomUtil;
	import net.fpp.starlingtdleveleditor.controller.baselibrary.events.BaseLibraryEvent;
	import net.fpp.starlingtdleveleditor.controller.baselibrary.events.BaseLibraryToolMenuEvent;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.StaticElementDataVO;

	public class BaseLibraryToolController extends AToolController
	{
		private var _staticElementToolLibrary:ElementLibrary;
		private var _staticElementPreview:Sprite;
		private var _staticElementContainer:Sprite;
		private var _selectedElementName:String;
		private var _staticElementViews:Vector.<ElementView> = new <ElementView>[];
		private var _draggedStaticElementView:ElementView;
		private var _selectedStaticElementView:ElementView;
		private var _staticElementToolMenu:ElementViewMenu;
		private var _lastSelectedStaticElementIndex:int = 0;
		private var _dragStartPoint:SimplePoint = new SimplePoint();

		public function BaseLibraryToolController()
		{
			this._staticElementContainer = new Sprite();

			this._staticElementPreview = new Sprite();
			this._staticElementPreview.alpha = .5;
			this._staticElementPreview.mouseEnabled = false;

			this._staticElementToolMenu = new ElementViewMenu();
		}

		public function setLibraryElementList( elementList:Vector.<String> )
		{
			this._staticElementToolLibrary = new ElementLibrary( elementList );
		}

		override protected function viewContainerInited():void
		{
			this._view.addChild( this._staticElementContainer );
		}

		override public function activate():void
		{
			super.activate();

			if ( this._staticElementToolLibrary )
			{
				this._uiContainer.addChild( this._staticElementToolLibrary );
				this._staticElementToolLibrary.addEventListener( BaseLibraryEvent.ELEMENT_SELECTED, this.onElementSelectedHandler );
				this._staticElementToolLibrary.addEventListener( BaseLibraryEvent.ELEMENT_DESELECTED, this.onElementDeselectedHandler );
			}

			this._uiContainer.stage.addEventListener( Event.RESIZE, onStageResizeHandler );
			this._uiContainer.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );
			this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this._view.addEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			this.repositionLibrary();

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				this._staticElementViews[ i ].activate();
			}
		}

		private function onElementSelectedHandler( e:BaseLibraryEvent ):void
		{
			this._selectedElementName = e.data as String;

			if( this._staticElementPreview.numChildren > 0 )
			{
				this._staticElementPreview.removeChildAt( 0 );
			}

			this._staticElementPreview.addChild( StaticBitmapAssetManager.instance.getBitmap( this._selectedElementName ) );

			this._view.addChild( this._staticElementPreview );

			this.repositionStaticElementPreview();
		}

		private function onElementDeselectedHandler( e:BaseLibraryEvent ):void
		{
			this._view.removeChild( this._staticElementPreview );
		}

		override public function deactivate():void
		{
			super.deactivate();

			this.closeStaticElementToolMenu();

			if( this._staticElementToolLibrary )
			{
				this._staticElementToolLibrary.deselectAllElement();

				if( this._staticElementToolLibrary.parent )
				{
					this._uiContainer.removeChild( this._staticElementToolLibrary );
					this._staticElementToolLibrary.removeEventListener( BaseLibraryEvent.ELEMENT_SELECTED, this.onElementSelectedHandler );
					this._staticElementToolLibrary.removeEventListener( BaseLibraryEvent.ELEMENT_DESELECTED, this.onElementDeselectedHandler );
				}
			}

			this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );
			this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this._view.removeEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			this._uiContainer.stage.removeEventListener( Event.RESIZE, this.onStageResizeHandler );
			this._uiContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			if( this._staticElementPreview.parent )
			{
				this._view.removeChild( this._staticElementPreview );
			}

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				this._staticElementViews[ i ].deactivate();
			}
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.repositionLibrary();
			this._staticElementToolLibrary.resize();
		}

		private function onStageMouseUpHandler( e:Event ):void
		{
			if( this._draggedStaticElementView && !this._staticElementToolMenu.parent )
			{
				this._draggedStaticElementView.stopDrag();
				this._draggedStaticElementView = null;
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function onMouseMoveHandler( e:MouseEvent ):void
		{
			if( this.isStaticElementToolLibraryClicked( e ) || this.isStaticElementViewClicked( e ) )
			{
				this._staticElementPreview.visible = false;
			}
			else
			{
				this._staticElementPreview.visible = true;
				this.repositionStaticElementPreview();
			}
		}

		private function onMouseDownHandler( e:MouseEvent ):void
		{
			if( e.target is ControlUVScale ||
					e.target is ControlUVRotate ||
					e.target is ControlRegistration
			)
			{
				this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
			}
		}

		private function onMouseClickHandler( e:MouseEvent ):void
		{
			if( this._staticElementPreview.parent && !this.isStaticElementToolLibraryClicked( e ) && !this.isStaticElementViewClicked( e ) )
			{
				this.createStaticElementView( this._selectedElementName, this._staticElementPreview.x, this._staticElementPreview.y );
			}

			if( this._staticElementToolMenu.parent && !this.isStaticElementToolMenuClicked( e ) )
			{
				this.closeStaticElementToolMenu();
			}
		}

		private function createStaticElementView( elementId:String, x:Number, y:Number, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1 ):void
		{
			var staticElementView:ElementView = new ElementView( elementId );
			staticElementView.x = x;
			staticElementView.y = y;
			staticElementView.rotation = rotation;
			staticElementView.scaleX = scaleX;
			staticElementView.scaleY = scaleY;

			staticElementView.addEventListener( MouseEvent.MOUSE_DOWN, this.onStaticElementViewMouseDownHandler );
			staticElementView.addEventListener( MouseEvent.CLICK, this.onStaticElementViewClickHandler );

			this._staticElementViews.push( staticElementView );
			this._staticElementContainer.addChild( staticElementView );

			if( !this._isActivated )
			{
				staticElementView.deactivate();
			}
		}

		private function isStaticElementToolLibraryClicked( e:MouseEvent ):Boolean
		{
			if ( !this._staticElementToolLibrary )
			{
				return false;
			}

			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			return this._staticElementToolLibrary.hitTestPoint( mouseX, mouseY );
		}

		private function isStaticElementToolMenuClicked( e:MouseEvent ):Boolean
		{
			if( !this._staticElementToolMenu.parent || !this._staticElementToolMenu.visible )
			{
				return false;
			}

			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			return this._staticElementToolMenu.hitTestPoint( mouseX, mouseY );
		}

		private function isStaticElementViewClicked( e:MouseEvent ):Boolean
		{
			var mouseX:Number = e.currentTarget.mouseX;
			var mouseY:Number = e.currentTarget.mouseY;

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				if( this._staticElementViews[ i ].hitTestPoint( mouseX, mouseY, true ) )
				{
					return true;
				}
			}

			return false;
		}

		private function onStaticElementViewMouseDownHandler( e:MouseEvent ):void
		{
			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );

			this.closeStaticElementToolMenu();

			if( this._selectedStaticElementView )
			{
				this._selectedStaticElementView.unmark();
			}

			this._draggedStaticElementView = e.currentTarget as ElementView;
			this._draggedStaticElementView.startDrag();

			this._dragStartPoint.setTo( this._view.mouseX, this._view.mouseY );

			this._staticElementToolLibrary.deselectAllElement();

			if( this._staticElementPreview.parent )
			{
				this._view.removeChild( this._staticElementPreview );
			}
		}

		private function onStaticElementViewClickHandler( e:MouseEvent ):void
		{
			if( this._selectedStaticElementView )
			{
				this._selectedStaticElementView.unmark();
			}

			if( GeomUtil.simplePointDistance( this._dragStartPoint, new SimplePoint( this._view.mouseX, this._view.mouseY ) ) > 5 )
			{
				return;
			}

			this._selectedStaticElementView = e.currentTarget as ElementView;
			this._selectedStaticElementView.mark();

			this._lastSelectedStaticElementIndex = this._staticElementContainer.getChildIndex( this._selectedStaticElementView );

			this.openStaticElementToolMenu();
		}

		private function openStaticElementToolMenu():void
		{
			this._uiContainer.addChild( this._staticElementToolMenu );

			var globalPoint:Point = this._view.localToGlobal( new Point( this._view.mouseX, this._view.mouseY ) );

			this._staticElementToolMenu.x = globalPoint.x;
			this._staticElementToolMenu.y = globalPoint.y;

			this._staticElementToolMenu.addEventListener( BaseLibraryToolMenuEvent.BRING_FORWARD, this.onBringForwardStaticElementRequestHandler );
			this._staticElementToolMenu.addEventListener( BaseLibraryToolMenuEvent.SEND_BACKWARD, this.onSendBackwardStaticElementRequestHandler );
			this._staticElementToolMenu.addEventListener( BaseLibraryToolMenuEvent.CLOSE_REQUEST, this.onCloseStaticElementRequestHandler );
			this._staticElementToolMenu.addEventListener( BaseLibraryToolMenuEvent.DELETE_REQUEST, this.onDeleteStaticElementRequestHandler );
			this._staticElementToolMenu.enable();
		}

		private function closeStaticElementToolMenu():void
		{
			if( this._staticElementToolMenu.parent )
			{
				this._selectedStaticElementView.unmark();

				this._uiContainer.removeChild( this._staticElementToolMenu );

				this._staticElementToolMenu.removeEventListener( BaseLibraryToolMenuEvent.BRING_FORWARD, this.onBringForwardStaticElementRequestHandler );
				this._staticElementToolMenu.removeEventListener( BaseLibraryToolMenuEvent.SEND_BACKWARD, this.onSendBackwardStaticElementRequestHandler );
				this._staticElementToolMenu.removeEventListener( BaseLibraryToolMenuEvent.CLOSE_REQUEST, this.onCloseStaticElementRequestHandler );
				this._staticElementToolMenu.removeEventListener( BaseLibraryToolMenuEvent.DELETE_REQUEST, this.onDeleteStaticElementRequestHandler );
				this._staticElementToolMenu.disable();
			}
		}

		private function onBringForwardStaticElementRequestHandler( e:BaseLibraryToolMenuEvent ):void
		{
			if( this._lastSelectedStaticElementIndex < this._staticElementContainer.numChildren - 1 )
			{
				this._staticElementContainer.swapChildrenAt( this._lastSelectedStaticElementIndex, this._lastSelectedStaticElementIndex + 1 );

				var savedStaticElementView:ElementView = this._staticElementViews[ this._lastSelectedStaticElementIndex ];
				this._staticElementViews[ this._lastSelectedStaticElementIndex ] = this._staticElementViews[ this._lastSelectedStaticElementIndex + 1 ];
				this._staticElementViews[ this._lastSelectedStaticElementIndex + 1 ] = savedStaticElementView;

				this._lastSelectedStaticElementIndex++;
			}
		}

		private function onSendBackwardStaticElementRequestHandler( e:BaseLibraryToolMenuEvent ):void
		{
			if( this._lastSelectedStaticElementIndex > 0 )
			{
				this._staticElementContainer.swapChildrenAt( this._lastSelectedStaticElementIndex, this._lastSelectedStaticElementIndex - 1 );

				var savedStaticElementView:ElementView = this._staticElementViews[ this._lastSelectedStaticElementIndex ];
				this._staticElementViews[ this._lastSelectedStaticElementIndex ] = this._staticElementViews[ this._lastSelectedStaticElementIndex - 1 ];
				this._staticElementViews[ this._lastSelectedStaticElementIndex - 1 ] = savedStaticElementView;

				this._lastSelectedStaticElementIndex--;
			}
		}

		private function onCloseStaticElementRequestHandler( e:BaseLibraryToolMenuEvent ):void
		{
			this.closeStaticElementToolMenu();
		}

		private function onDeleteStaticElementRequestHandler( e:BaseLibraryToolMenuEvent ):void
		{
			var savedStaticElementView:ElementView = this._staticElementViews[ this._lastSelectedStaticElementIndex ];
			savedStaticElementView.dispose();
			savedStaticElementView.removeEventListener( MouseEvent.CLICK, this.onStaticElementViewClickHandler );

			this._staticElementContainer.removeChild( savedStaticElementView );
			this._staticElementViews.splice( this._lastSelectedStaticElementIndex, 1 );

			savedStaticElementView = null;

			this.closeStaticElementToolMenu();
		}

		private function repositionStaticElementPreview():void
		{
			if( this._staticElementPreview.parent )
			{
				this._staticElementPreview.x = this._view.mouseX - this._staticElementPreview.width / 2;
				this._staticElementPreview.y = this._view.mouseY - this._staticElementPreview.height / 2;
			}
		}

		private function repositionLibrary():void
		{
			if ( this._staticElementToolLibrary )
			{
				this._staticElementToolLibrary.x = 5;
				this._staticElementToolLibrary.y = this._uiContainer.stage.stageHeight - this._staticElementToolLibrary.height - 5;
			}
		}

		override public function setLevelDataVO( levelDataVO:LevelDataVO ):void
		{
			if( !levelDataVO.staticElementData )
			{
				return;
			}

			for( var i:int = 0; i < levelDataVO.staticElementData.length; i++ )
			{
				var staticElementData:StaticElementDataVO = levelDataVO.staticElementData[ i ];

				this.createStaticElementView(
						staticElementData.elementId,
						staticElementData.position.x,
						staticElementData.position.y,
						staticElementData.rotation,
						staticElementData.scaleX,
						staticElementData.scaleY
				);
			}
		}

		override public function getLevelDataVO():LevelDataVO
		{
			var levelDataVO:LevelDataVO = new LevelDataVO();

			var staticElementData:Vector.<StaticElementDataVO> = new <StaticElementDataVO>[];

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				staticElementData.push( new StaticElementDataVO(
						this._staticElementViews[ i ].elementId,
						new SimplePoint( this._staticElementViews[ i ].x, this._staticElementViews[ i ].y ),
						this._staticElementViews[ i ].rotation,
						this._staticElementViews[ i ].scaleX,
						this._staticElementViews[ i ].scaleY
				) );
			}

			levelDataVO.staticElementData = staticElementData;

			return levelDataVO;
		}
	}
}