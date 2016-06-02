/**
 * Created by newkrok on 02/06/16.
 */
package net.fpp.starlingtdleveleditor.parser
{
	import net.fpp.common.geom.SimplePoint;
	import net.fpp.starlingtowerdefense.vo.EnemyPathDataVO;
	import net.fpp.starlingtowerdefense.vo.EnemyPathPointVO;

	public class EnemyPathDataVOVectorParser implements IParser
	{
		public function parse( source:Object ):Object
		{
			var result:Vector.<EnemyPathDataVO> = new Vector.<EnemyPathDataVO>;
			var convertedSource:Array = source as Array;

			for( var i:int = 0; i < convertedSource.length; i++ )
			{
				var enemyPathDataVO:EnemyPathDataVO = new EnemyPathDataVO();
				enemyPathDataVO.id = convertedSource[ i ].id;
				enemyPathDataVO.enemyPathPoints = new <EnemyPathPointVO>[];

				for( var j:int = 0; j < convertedSource[ i ].enemyPathPoints.length; j++ )
				{
					var enemyPathPointData:Object = convertedSource[ i ].enemyPathPoints[ j ];
					enemyPathDataVO.enemyPathPoints.push
					(
							new EnemyPathPointVO
							(
									enemyPathPointData.radius,
									new SimplePoint( enemyPathPointData.point.x, enemyPathPointData.point.y )
							)
					);
				}

				result.push( enemyPathDataVO );
			}

			return result;
		}
	}
}