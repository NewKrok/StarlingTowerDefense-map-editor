/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class Button extends Sprite
	{
		protected const NORMAL_STATE:String = 'Button.NORMAL_STATE';
		protected const OVER_STATE:String = 'Button.OVER_STATE';

		private var _hitArea:Sprite;
		private var _upSkin:DisplayObject;
		private var _downSkin:DisplayObject;

		protected var _activeSkin:DisplayObject;

		private var _text:String;

		protected var _width:Number;
		protected var _height:Number;

		protected var _state:String = NORMAL_STATE;
		protected var _stateViewManifest:Dictionary;
		private var _textField:TextField;

		public var data:Object;

		public function Button( upSkin:DisplayObject, downSkin:DisplayObject, text:String = '', width:Number = 100, height:Number = 25 )
		{
			this._upSkin = upSkin;
			this._downSkin = downSkin;
			this._text = text;
			this._width = width;
			this._height = height;

			this.mouseChildren = false;

			this.createText();
			this.createMouseHandler();
			this.createStateViewManifest();

			this.updateView();
			this.updateSize();

			this.enable();
		}

		private function createText():void
		{
			this._textField = new TextField();
			this.addChild( this._textField );

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 11;
			textFormat.color = 0xFFFFFF;
			textFormat.font = 'Verdana';

			this._textField.defaultTextFormat = textFormat;

			this._textField.autoSize = TextFieldAutoSize.CENTER;
			this._textField.text = this._text;
		}

		private function createMouseHandler():void
		{
			this._hitArea = this;
		}

		private function updateHitAreaView():void
		{
			this._hitArea.graphics.clear();

			this._hitArea.graphics.beginFill( 0, 0 );
			this._hitArea.graphics.drawRect( 0, 0, this._width, this._height );
			this._hitArea.graphics.endFill();
		}

		protected function updateView():void
		{
			if ( this._activeSkin && this._activeSkin.parent )
			{
				this.removeChild( this._activeSkin );
			}

			this._stateViewManifest[this._state].call();

			if ( this._activeSkin )
			{
				this.addChildAt( this._activeSkin, 0 );
			}
		}

		protected function updateSize():void
		{
			this.updateHitAreaView();

			this._textField.x = this._width / 2 - this._textField.width / 2;
			this._textField.y = this._height / 2 - this._textField.height / 2;

			this._upSkin.width = this._width;
			this._upSkin.height = this._height;

			this._downSkin.width = this._width;
			this._downSkin.height = this._height;
		}

		private function createStateViewManifest():void
		{
			this._stateViewManifest = new Dictionary();
			this._stateViewManifest[NORMAL_STATE] = this.updateNormalStateView;
			this._stateViewManifest[OVER_STATE] = this.updateOverStateView;
		}

		private function updateNormalStateView():void
		{
			this._activeSkin = this._upSkin;
		}

		private function updateOverStateView():void
		{
			this._activeSkin = this._downSkin;
		}

		public function enable():void
		{
			this._hitArea.buttonMode = true;
			this._hitArea.addEventListener( MouseEvent.MOUSE_OVER, this.mouseOverHandler );
			this._hitArea.addEventListener( MouseEvent.MOUSE_OUT, this.mouseOutHandler );

			this.mouseEnabled = true;
			this.useHandCursor = true;
		}

		public function disable():void
		{
			this._hitArea.buttonMode = false;
			this._hitArea.removeEventListener( MouseEvent.MOUSE_OVER, this.mouseOverHandler );
			this._hitArea.removeEventListener( MouseEvent.MOUSE_OUT, this.mouseOutHandler );

			this._state = this.NORMAL_STATE;
			this.updateView();

			this.mouseEnabled = false;
			this.useHandCursor = false;
		}

		protected function mouseOverHandler( e:MouseEvent ):void
		{
			this._state = this.OVER_STATE;
			this.updateView();
		}

		protected function mouseOutHandler( e:MouseEvent ):void
		{
			this._state = this.NORMAL_STATE;
			this.updateView();
		}

		override public function set width( value:Number ):void
		{
			this._width = value;

			this.updateSize();
		}

		override public function set height( value:Number ):void
		{
			this._height = value;

			this.updateSize();
		}
	}
}