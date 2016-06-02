/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.parser
{
	import net.fpp.starlingtdleveleditor.util.ParserUtil;
	import net.fpp.starlingtowerdefense.vo.PolygonBackgroundVO;

	public class PolygonBackgroundVOVectorParser implements IParser
	{
		public function parse( source:Object ):Object
		{
			var result:Vector.<PolygonBackgroundVO> = new Vector.<PolygonBackgroundVO>;
			var convertedSource:Array = source as Array;

			for( var i:int = 0; i < convertedSource.length; i++ )
			{
				var polygonBackgroundVO:PolygonBackgroundVO = new PolygonBackgroundVO();
				polygonBackgroundVO.polygon = ParserUtil.objectArrayToSimplePointVector( convertedSource[ i ].polygon as Array );
				polygonBackgroundVO.terrainTextureId = convertedSource[ i ].terrainTextureId;

				result.push( polygonBackgroundVO );
			}

			return result;
		}
	}
}