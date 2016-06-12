/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.staticelement.events.StaticElementToolLibraryEvent;

	public class StaticElementToolController extends AToolController
	{
		private var _staticElementToolLibrary:StaticElementToolLibrary;
		private var _staticElementPreview:Sprite;
		private var _selectedElementName:String;
		private var _staticElementViews:Vector.<StaticElementView> = new <StaticElementView>[];
		private var _selectedStaticElementView:StaticElementView;

		public function StaticElementToolController()
		{
			this._staticElementToolLibrary = new StaticElementToolLibrary();

			this._staticElementPreview = new Sprite();
			this._staticElementPreview.alpha = .5;
			this._staticElementPreview.mouseEnabled = false;
		}

		override public function activate():void
		{
			super.activate();

			this._uiContainer.addChild( this._staticElementToolLibrary );
			this._staticElementToolLibrary.addEventListener( StaticElementToolLibraryEvent.ELEMENT_SELECTED, this.onElementSelectedHandler );
			this._staticElementToolLibrary.addEventListener( StaticElementToolLibraryEvent.ELEMENT_DESELECTED, this.onElementDeselectedHandler );

			this._uiContainer.stage.addEventListener( Event.RESIZE, onStageResizeHandler );
			this._uiContainer.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );
			this._view.addEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			this.repositionLibrary();
		}

		private function onElementSelectedHandler( e:StaticElementToolLibraryEvent ):void
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

		private function onElementDeselectedHandler( e:StaticElementToolLibraryEvent ):void
		{
			this._view.removeChild( this._staticElementPreview );
		}

		override public function deactivate():void
		{
			super.deactivate();

			this._staticElementToolLibrary.deselectAllElement();

			if( this._staticElementToolLibrary.parent )
			{
				this._uiContainer.removeChild( this._staticElementToolLibrary );
				this._staticElementToolLibrary.removeEventListener( StaticElementToolLibraryEvent.ELEMENT_SELECTED, this.onElementSelectedHandler );
				this._staticElementToolLibrary.removeEventListener( StaticElementToolLibraryEvent.ELEMENT_DESELECTED, this.onElementDeselectedHandler );
			}

			this._uiContainer.stage.removeEventListener( Event.RESIZE, this.onStageResizeHandler );
			this._uiContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._view.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler );
			this._view.removeEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			if( this._staticElementPreview.parent )
			{
				this._view.removeChild( this._staticElementPreview );
			}
		}

		private function onStageResizeHandler( e:Event ):void
		{
			this.repositionLibrary();
			this._staticElementToolLibrary.resize();
		}

		private function onStageMouseUpHandler( e:Event ):void
		{
			if( this._selectedStaticElementView )
			{
				this._selectedStaticElementView.stopDrag();

				this._selectedStaticElementView = null;
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STOPPED ) );
		}

		private function onMouseMoveHandler( e:MouseEvent ):void
		{
			this.repositionStaticElementPreview();
		}

		private function onMouseClickHandler( e:MouseEvent ):void
		{
			if( this._staticElementPreview.parent )
			{
				var staticElementView:StaticElementView = new StaticElementView( this._selectedElementName );
				staticElementView.x = this._staticElementPreview.x;
				staticElementView.y = this._staticElementPreview.y;

				staticElementView.addEventListener( MouseEvent.MOUSE_DOWN, this.onStaticElementViewMouseDownHandler );

				this._staticElementViews.push( staticElementView );
				this._view.addChild( staticElementView );
			}
		}

		private function onStaticElementViewMouseDownHandler( e:MouseEvent ):void
		{
			this._selectedStaticElementView = e.currentTarget as StaticElementView;

			this._selectedStaticElementView.startDrag();

			this._staticElementToolLibrary.deselectAllElement();

			if ( this._staticElementPreview.parent )
			{
				this._view.removeChild( this._staticElementPreview );
			}

			this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
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
			this._staticElementToolLibrary.x = 5;
			this._staticElementToolLibrary.y = this._uiContainer.stage.stageHeight - this._staticElementToolLibrary.height - 5;
		}
	}
}