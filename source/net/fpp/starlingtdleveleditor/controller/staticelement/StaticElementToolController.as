/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import com.senocular.display.transform.ControlRegistration;
	import com.senocular.display.transform.ControlUVRotate;
	import com.senocular.display.transform.ControlUVScale;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.common.events.ToolControllerEvent;
	import net.fpp.starlingtdleveleditor.controller.staticelement.events.StaticElementToolLibraryEvent;
	import net.fpp.starlingtowerdefense.vo.LevelDataVO;
	import net.fpp.starlingtowerdefense.vo.StaticElementDataVO;

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
			this._view.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this._view.addEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			this.repositionLibrary();

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				this._staticElementViews[i].activate();
			}
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
			this._view.removeEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDownHandler );
			this._view.removeEventListener( MouseEvent.CLICK, this.onMouseClickHandler );

			if( this._staticElementPreview.parent )
			{
				this._view.removeChild( this._staticElementPreview );
			}

			for( var i:int = 0; i < this._staticElementViews.length; i++ )
			{
				this._staticElementViews[i].deactivate();
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

		private function onMouseDownHandler( e:MouseEvent ):void
		{
			if ( 	e.target is ControlUVScale ||
					e.target is ControlUVRotate ||
					e.target is ControlRegistration
			)
			{
				this.dispatchEvent( new ToolControllerEvent( ToolControllerEvent.MOUSE_ACTION_STARTED ) );
			}
		}

		private function onMouseClickHandler( e:MouseEvent ):void
		{
			if( this._staticElementPreview.parent )
			{
				this.createStaticElementView( this._selectedElementName, this._staticElementPreview.x, this._staticElementPreview.y );
			}
		}

		private function createStaticElementView( elementId:String, x:Number, y:Number, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1 ):void
		{
			var staticElementView:StaticElementView = new StaticElementView( elementId );
			staticElementView.x = x;
			staticElementView.y = y;
			staticElementView.rotation = rotation;
			staticElementView.scaleX = scaleX;
			staticElementView.scaleY = scaleY;

			staticElementView.addEventListener( MouseEvent.MOUSE_DOWN, this.onStaticElementViewMouseDownHandler );

			this._staticElementViews.push( staticElementView );
			this._view.addChild( staticElementView );

			if ( !this._isActivated )
			{
				staticElementView.deactivate();
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

		override public function setLevelDataVO( levelDataVO:LevelDataVO ):void
		{
			if( !levelDataVO.staticElementData )
			{
				return
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
						this._staticElementViews[i].elementId,
						new SimplePoint( this._staticElementViews[i].x, this._staticElementViews[i].y ),
						this._staticElementViews[i].rotation,
						this._staticElementViews[i].scaleX,
						this._staticElementViews[i].scaleY
				) );
			}

			levelDataVO.staticElementData = staticElementData;

			return levelDataVO;
		}
	}
}