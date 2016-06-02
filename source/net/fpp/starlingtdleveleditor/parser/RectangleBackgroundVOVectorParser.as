/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.parser
{
	import net.fpp.starlingtdleveleditor.util.ParserUtil;
	import net.fpp.starlingtowerdefense.vo.RectangleBackgroundVO;

	public class RectangleBackgroundVOVectorParser implements IParser
	{
		public function parse( source:Object ):Object
		{
			var result:Vector.<RectangleBackgroundVO> = new Vector.<RectangleBackgroundVO>;
			var convertedSource:Array = source as Array;

			for( var i:int = 0; i < convertedSource.length; i++ )
			{
				var rectangleBackgroundVO:RectangleBackgroundVO = new RectangleBackgroundVO();
				rectangleBackgroundVO.polygon = ParserUtil.objectArrayToSimplePointVector( convertedSource[ i ].polygon as Array );
				rectangleBackgroundVO.terrainTextureId = convertedSource[ i ].terrainTextureId;

				result.push( rectangleBackgroundVO );
			}

			return result;
		}
	}
}