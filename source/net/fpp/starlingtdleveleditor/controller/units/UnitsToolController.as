/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.units
{
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;

	import net.fpp.common.bitmap.StaticBitmapAssetManager;
	import net.fpp.starlingtdleveleditor.controller.baselibrary.BaseLibraryToolController;
	import net.fpp.starlingtowerdefense.game.config.unit.UnitTypeList;

	public class UnitsToolController extends BaseLibraryToolController
	{
		public function UnitsToolController()
		{
			super();

			this._isTransformToolEnabled = false;

			var unitNameList:Vector.<String> = new <String>[];

			for( var i:int = 0; i < UnitTypeList.list.length; i++ )
			{
				var unitName:String = UnitTypeList.list[ i ].name;
				unitNameList.push( unitName );

				var bitmapClass:Class = getDefinitionByName( unitName ) as Class;
				StaticBitmapAssetManager.instance.addBitmapData( unitName, new bitmapClass() as BitmapData );
			}

			this.setLibraryElementList( unitNameList );

			this.setLevelDataId( 'unitsData' );
		}
	}
}