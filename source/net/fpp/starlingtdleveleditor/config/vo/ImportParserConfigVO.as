/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.config.vo
{
	public class ImportParserConfigVO
	{
		public var entryType:Object;
		public var parserClass:Class;

		public function ImportParserConfigVO( entryType:Object, parserClass:Class )
		{
			this.entryType = entryType;
			this.parserClass = parserClass;
		}
	}
}