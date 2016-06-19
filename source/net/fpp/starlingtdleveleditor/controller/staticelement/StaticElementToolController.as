/**
 * Created by newkrok on 19/06/16.
 */
package net.fpp.starlingtdleveleditor.controller.staticelement
{
	import net.fpp.starlingtdleveleditor.controller.baselibrary.BaseLibraryToolController;

	public class StaticElementToolController extends BaseLibraryToolController
	{
		public function StaticElementToolController()
		{
			super();

			this.setLibraryElementList(
				new <String>[
					'crater_0',
					'crater_1',
					'crater_2',
					'crater_3',
					'crater_4'
				]
			);
		}
	}
}