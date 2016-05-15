/**
 * Created by newkrok on 15/05/16.
 */
package net.fpp.starlingtdleveleditor.assets.skin
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	public class SkinManager
	{
		public static function getSkin( id:String ):DisplayObject
		{
			var type:Class = getDefinitionByName( id ) as Class;
			var instance:DisplayObject = new type();

			return instance;
		}
	}
}