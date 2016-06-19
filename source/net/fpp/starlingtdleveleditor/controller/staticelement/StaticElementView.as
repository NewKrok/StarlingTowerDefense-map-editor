/**
 * Created by newkrok on 12/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import com.senocular.display.transform.ControlBoundingBox;
	import com.senocular.display.transform.ControlReset;
	import com.senocular.display.transform.ControlSetStandard;
	import com.senocular.display.transform.TransformTool;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;

	public class StaticElementView extends Sprite
	{
		private var _elementId:String;

		private var _transformTool:TransformTool;

		public function StaticElementView( elementName:String )
		{
			this._elementId = elementName;

			this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, this.onAddedToStageHandler );

			this.addChild( StaticBitmapAssetManager.instance.getBitmap( this._elementId ) );

			var _controlSetStandard:ControlSetStandard = new ControlSetStandard();
			_controlSetStandard.push( new ControlReset() );
			_controlSetStandard.push( new ControlBoundingBox() );

			this._transformTool = new TransformTool( _controlSetStandard as Array );
			this.parent.parent.addChild( this._transformTool );
			this._transformTool.target = this;

			this.buttonMode = true;
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
			this._transformTool.parent.removeChild( _transformTool );
			this._transformTool = null;
		}
	}
}