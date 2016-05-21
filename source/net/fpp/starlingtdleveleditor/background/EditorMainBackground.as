/**
 * Created by newkrok on 21/05/16.
 */
package net.fpp.starlingtdleveleditor.background
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import net.fpp.starlingtdleveleditor.constant.CEditor;

	public class EditorMainBackground extends Sprite
	{
		private var _markerContainer:Sprite;

		private var _sizeMarkers:Vector.<TextField> = new Vector.<TextField>;

		public function EditorMainBackground()
		{
			this._markerContainer = new Sprite();
			this.addChild( this._markerContainer );

			this.removeSizeMarkers();
			this.redrawBaseGraphic();
			this.generateSizeMarkers();
		}

		private function redrawBaseGraphic():void
		{
			this.graphics.clear();
			this.graphics.beginFill( 0xFFFFFF, .2 );
			this.graphics.drawRect( 0, 0, CEditor.EDITOR_WORLD_SIZE.x, CEditor.EDITOR_WORLD_SIZE.y );
			this.graphics.endFill();
		}

		private function removeSizeMarkers():void
		{
			for( var i:int = 0; i < this._sizeMarkers.length; i++ )
			{
				this._markerContainer.removeChild( this._sizeMarkers[ i ] );
				this._sizeMarkers[ i ] = null;
			}
			this._sizeMarkers.length = 0;
		}

		private function generateSizeMarkers():void
		{
			var markerCount:int = Math.floor( this.width / 200 );

			for( var i:int = 0; i < markerCount; i++ )
			{
				this.addSizeMarker( i * 200, 0 );
				this.addSizeMarker( i * 200, this.height - this._sizeMarkers[ 0 ].height );
			}
		}

		private function addSizeMarker( xPosition:uint, yPosition:uint ):void
		{
			var marker:TextField = this.createMarkerText( xPosition );
			marker.y = yPosition;

			this._markerContainer.addChild( marker );
			this._sizeMarkers.push( marker );
		}

		private function createMarkerText( xPosition:uint ):TextField
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
	}
}