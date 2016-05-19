/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.vo
{
	import net.fpp.starlingtdleveleditor.controller.AToolController;

	public class ToolConfigVO
	{
		public var name:String;
		public var iconImageSrc:String;
		public var toolController:AToolController;
		public var id:String;

		public function ToolConfigVO( id:String, name:String, iconImageSrc:String, toolController:AToolController ):void
		{
			this.id = id;
			this.name = name;
			this.iconImageSrc = iconImageSrc;
			this.toolController = toolController;
		}
	}
}