/**
 * Created by newkrok on 28/05/16.
 */
package net.fpp.starlingtdleveleditor.controller.enemypath
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.fpp.common.display.VUIBox;
	import net.fpp.starlingtdleveleditor.assets.skin.CSkinAsset;
	import net.fpp.starlingtdleveleditor.assets.skin.SkinManager;
	import net.fpp.starlingtdleveleditor.controller.enemypath.events.EnemyPathToolMenuEvent;

	public class EnemyPathToolMenu extends Sprite
	{
		private const _padding:Number = 5;

		private var _enemyPathEntryViews:Vector.<EnemyPathEntryView> = new <EnemyPathEntryView>[];

		private var _background:DisplayObject;
		private var _container:VUIBox;

		public function EnemyPathToolMenu()
		{
			this._background = SkinManager.getSkin( CSkinAsset.TRANSPARENT_BACKGROUND );
			this.addChild( this._background );

			this._container = new VUIBox();
			this._container.horizontalAlign = VUIBox.HORIZONTAL_ALIGN_LEFT;
			this._container.gap = 5;
			this.addChild( this._container );

			this.createTitle();

			this._background.width = this.width + _padding * 2;
			this._background.height = this.height + _padding * 2;

			this._container.x = _padding;
			this._container.y = _padding;
		}

		private function createTitle():void
		{
			var textField:TextField = new TextField();

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 11;
			textFormat.color = 0x0;
			textFormat.font = 'Verdana';

			textField.defaultTextFormat = textFormat;

			textField.mouseEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = 'Enemy Paths';

			this._container.addChild( textField );
		}

		public function enable():void
		{
		}

		public function disable():void
		{
		}

		public function setEnemyPaths( enemyPaths:Vector.<EnemyPathVO> ):void
		{
			this.clearEnemyPaths();

			for( var i:int = 0; i < enemyPaths.length; i++ )
			{
				var enemyPathEntryView:EnemyPathEntryView = new EnemyPathEntryView( enemyPaths[ i ] )
				enemyPathEntryView.addEventListener( EnemyPathToolMenuEvent.RESIZE_REQUEST, this.onResizeRequest );
				enemyPathEntryView.addEventListener( EnemyPathToolMenuEvent.RENAME_REQUEST, this.onRenameRequest );
				enemyPathEntryView.addEventListener( EnemyPathToolMenuEvent.REMOVE_REQUEST, this.onRemoveRequest );

				this._container.addChild( enemyPathEntryView );
				this._enemyPathEntryViews.push( enemyPathEntryView );
			}

			this.resize();
		}

		private function resize():void
		{
			this._background.width = this._container.width + _padding * 2;
			this._background.height = this._container.height + _padding * 2;

			this._container.draw();
		}

		private function onResizeRequest( e:EnemyPathToolMenuEvent ):void
		{
			var enemyPathEntryView:EnemyPathEntryView = ( e.currentTarget as EnemyPathEntryView );
			enemyPathEntryView.draw();

			this.resize();
		}

		private function onRenameRequest( e:EnemyPathToolMenuEvent ):void
		{
			var selectedEnemyPathEntryView:EnemyPathEntryView = ( e.currentTarget as EnemyPathEntryView );
			var selectedPathVOName:EnemyPathVO = selectedEnemyPathEntryView.enemyPathVO;

			if( e.data == '' )
			{
				selectedEnemyPathEntryView.refreshView();
			}
			else
			{
				for( var i:int = 0; i < this._enemyPathEntryViews.length; i++ )
				{
					if( this._enemyPathEntryViews[ i ] != selectedEnemyPathEntryView && this._enemyPathEntryViews[ i ].enemyPathVO.name == e.data )
					{
						selectedEnemyPathEntryView.refreshView();
						break;
					}
				}

				if( i == this._enemyPathEntryViews.length )
				{
					selectedPathVOName.name = e.data as String;
				}
			}
		}

		private function onRemoveRequest( e:EnemyPathToolMenuEvent ):void
		{
			this.dispatchEvent( e );
		}

		private function clearEnemyPaths():void
		{
			while( this._container.numChildren > 1 )
			{
				var child:DisplayObject = this._container.getChildAt( 1 );

				child.removeEventListener( EnemyPathToolMenuEvent.RESIZE_REQUEST, this.onResizeRequest );
				this._container.removeChild( child );
			}

			this._enemyPathEntryViews.length = 0;
		}
	}
}