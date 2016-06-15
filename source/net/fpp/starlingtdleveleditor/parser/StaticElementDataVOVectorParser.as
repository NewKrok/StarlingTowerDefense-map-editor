/**
 * Created by newkrok on 15/06/16.
 */
package net.fpp.starlingtdleveleditor.parser
{
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtowerdefense.vo.StaticElementDataVO;

	public class StaticElementDataVOVectorParser implements IParser
	{
		public function parse( source:Object ):Object
		{
			var result:Vector.<StaticElementDataVO> = new Vector.<StaticElementDataVO>;
			var convertedSource:Array = source as Array;

			for( var i:int = 0; i < convertedSource.length; i++ )
			{
				var staticElementDataVO:StaticElementDataVO = new StaticElementDataVO();
				staticElementDataVO.elementId = convertedSource[ i ].elementId;
				staticElementDataVO.position = new SimplePoint( convertedSource[ i ].position.x, convertedSource[ i ].position.y );
				staticElementDataVO.rotation = convertedSource[ i ].rotation;
				staticElementDataVO.scaleX = convertedSource[ i ].scaleX;
				staticElementDataVO.scaleY = convertedSource[ i ].scaleY;

				result.push( staticElementDataVO );
			}

			return result;
		}
	}
}