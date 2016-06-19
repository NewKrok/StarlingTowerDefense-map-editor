/**
 * Created by newkrok on 09/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.dynamicelement
{
	import net.fpp.starlingtdleveleditor.controller.baselibrary.BaseLibraryToolController;

	public class DynamicElementToolController extends BaseLibraryToolController
	{
		public function DynamicElementToolController()
		{
			super();

			this.setLibraryElementList(
					new <String>[
						'bush',
						'tree',
						'building'
					]
			);
		}
	}
}