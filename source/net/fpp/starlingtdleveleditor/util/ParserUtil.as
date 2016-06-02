/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.util
{
	import net.fpp.common.geom.SimplePoint;

	public class ParserUtil
	{
		public static function objectArrayToSimplePointVector( array:Array ):Vector.<SimplePoint>
		{
			var simplePointVector:Vector.<SimplePoint> = new <SimplePoint>[];

			for( var i:int = 0; i < array.length; i++ )
			{
				simplePointVector.push( new SimplePoint( array[ i ].x, array[ i ].y ) );
			}

			return simplePointVector;
		}
	}
}