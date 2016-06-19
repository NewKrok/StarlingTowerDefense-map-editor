/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.config.vo
{
	public class ToolConfigVO
	{
		public var name:String;
		public var iconImageSrc:String;
		public var toolControllerClass:Class;
		public var id:String;
		public var isSelectable:Boolean;

		public function ToolConfigVO( id:String, name:String, iconImageSrc:String, toolControllerClass:Class, isSelectable:Boolean ):void
		{
			this.id = id;
			this.name = name;
			this.iconImageSrc = iconImageSrc;
			this.toolControllerClass = toolControllerClass;
			this.isSelectable = isSelectable;
		}
	}
}