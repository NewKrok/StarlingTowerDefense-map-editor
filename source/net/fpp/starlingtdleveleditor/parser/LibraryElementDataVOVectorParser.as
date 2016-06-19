/**
 * Created by newkrok on 15/06/16.
 */
package net.fpp.starlingtdleveleditor.parser
{
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtowerdefense.vo.LibraryElementDataVO;

	public class LibraryElementDataVOVectorParser implements IParser
	{
		public function parse( source:Object ):Object
		{
			var result:Vector.<LibraryElementDataVO> = new Vector.<LibraryElementDataVO>;
			var convertedSource:Array = source as Array;

			for( var i:int = 0; i < convertedSource.length; i++ )
			{
				var staticElementDataVO:LibraryElementDataVO = new LibraryElementDataVO();
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