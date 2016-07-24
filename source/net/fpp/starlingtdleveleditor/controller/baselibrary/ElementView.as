/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.baselibrary
{
	import com.senocular.display.transform.ControlBoundingBox;
	import com.senocular.display.transform.ControlReset;
	import com.senocular.display.transform.ControlSetStandard;
	import com.senocular.display.transform.RegistrationManager;
	import com.senocular.display.transform.TransformTool;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;

	public class ElementView extends Sprite
	{
		private var _elementId:String;

		private var _transformTool:TransformTool;
		public var isTransformToolEnabled:Boolean;

		public function ElementView( elementId:String )
		{
			this._elementId = elementId;

			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._elementId ) );

			var _controlSetStandard:ControlSetStandard = new ControlSetStandard();
			_controlSetStandard.push( new ControlReset() );
			_controlSetStandard.push( new ControlBoundingBox() );

			var registrationManager:RegistrationManager = new RegistrationManager();
			registrationManager.setRegistration( this, new Point( this.width / 2, this.height / 2 ) );

			this._transformTool = new TransformTool( _controlSetStandard as Array, registrationManager );
			this._transformTool.alpha = .2;

			if ( this.isTransformToolEnabled )
			{
				this.parent.parent.addChild( this._transformTool );
			}

			this._transformTool.target = this;

			this.addEventListener( MouseEvent.MOUSE_OVER, this.onMouseUp );
			this._transformTool.addEventListener( MouseEvent.MOUSE_OVER, this.onMouseUp );

			this.addEventListener( MouseEvent.MOUSE_OUT, this.onMouseDown );
			this._transformTool.addEventListener( MouseEvent.MOUSE_OUT, this.onMouseDown );

			this.buttonMode = true;
		}

		private function onMouseUp( e:MouseEvent ):void
		{
			this._transformTool.alpha = 1;
		}

		private function onMouseDown( e:MouseEvent ):void
		{
			this._transformTool.alpha = .2;
		}

		public function activate():void
		{
			this._transformTool.visible = true;
		}

		public function deactivate():void
		{
			this._transformTool.visible = false;
		}

		public function mark():void
		{
			this.filters = [ new GlowFilter( 0xFFFFFF, 1, 5, 5, 100 ) ];
		}

		public function unmark():void
		{
			this.filters = [];
		}

		public function get elementId():String
		{
			return this._elementId;
		}

		override public function get x():Number
		{
			return Math.floor( super.x );
		}

		override public function get y():Number
		{
			return Math.floor( super.y );
		}

		override public function get scaleX():Number
		{
			return Math.floor( super.scaleX * 100 ) / 100;
		}

		override public function get scaleY():Number
		{
			return Math.floor( super.scaleY * 100 ) / 100;
		}

		override public function set rotation( value:Number ):void
		{
			super.rotation = Math.floor( value * 100 ) / 100;
		}

		public function dispose():void
		{
			this.removeEventListener( MouseEvent.MOUSE_OVER, this.onMouseUp );
			this._transformTool.removeEventListener( MouseEvent.MOUSE_OVER, this.onMouseUp );

			this.removeEventListener( MouseEvent.MOUSE_OUT, this.onMouseDown );
			this._transformTool.removeEventListener( MouseEvent.MOUSE_OUT, this.onMouseDown );

			this._transformTool.parent.removeChild( _transformTool );
			this._transformTool = null;
		}
	}
}