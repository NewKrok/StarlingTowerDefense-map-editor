/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.config
{
	import net.fpp.starlingtdleveleditor.config.vo.ImportParserConfigVO;
	import net.fpp.starlingtdleveleditor.parser.EnemyPathDataVOVectorParser;
	import net.fpp.starlingtdleveleditor.parser.PolygonBackgroundVOVectorParser;
	import net.fpp.starlingtdleveleditor.parser.RectangleBackgroundVOVectorParser;
	import net.fpp.starlingtowerdefense.vo.EnemyPathDataVO;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;
	import net.fpp.starlingtowerdefense.vo.RectangleBackgroundVO;

	public class ImportParserConfig implements IToolConfig
	{
		private const _rule:Vector.<ImportParserConfigVO> = new <ImportParserConfigVO>[
			new ImportParserConfigVO( new Vector.<PolygonBackgroundVO>, PolygonBackgroundVOVectorParser ),
			new ImportParserConfigVO( new Vector.<RectangleBackgroundVO>, RectangleBackgroundVOVectorParser ),
			new ImportParserConfigVO( new Vector.<EnemyPathDataVO>, EnemyPathDataVOVectorParser )
		];

		public function get rule():Object
		{
			return this._rule;
		}
	}
}