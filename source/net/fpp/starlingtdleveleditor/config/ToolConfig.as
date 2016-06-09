/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.config
{
	import net.fpp.starlingtdleveleditor.config.vo.ToolConfigVO;
	import net.fpp.starlingtdleveleditor.constant.CToolId;
	import net.fpp.starlingtdleveleditor.constant.CToolType;
	import net.fpp.starlingtdleveleditor.controller.common.AToolController;
	import net.fpp.starlingtdleveleditor.controller.dynamicelement.DynamicElementToolController;
	import net.fpp.starlingtdleveleditor.controller.enemypath.EnemyPathToolController;
	import net.fpp.starlingtdleveleditor.controller.exportlevel.ExportToolController;
	import net.fpp.starlingtdleveleditor.controller.importlevel.ImportToolController;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.PolygonBackgroundToolController;
	import net.fpp.starlingtdleveleditor.controller.rectanglebackground.RectangleBackgroundToolController;
	import net.fpp.starlingtdleveleditor.controller.staticelement.StaticElementToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomin.ZoomInToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomout.ZoomOutToolController;

	public class ToolConfig
	{
		public const configs:Vector.<ToolConfigVO> = new <ToolConfigVO>
						[
							new ToolConfigVO
							(
									CToolId.IMPORT,
									'Import',
									'ImportButtonIcon',
									ImportToolController,
									CToolType.IS_NOT_SELECTABLE,
									new ImportParserConfig()
							),

							new ToolConfigVO
							(
									CToolId.EXPORT,
									'Export',
									'ExportButtonIcon',
									ExportToolController,
									CToolType.IS_NOT_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.ZOOM_IN,
									'Zoom In',
									'ZoomInButtonIcon',
									ZoomInToolController,
									CToolType.IS_NOT_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.ZOOM_OUT,
									'Zoom Out',
									'ZoomOutButtonIcon',
									ZoomOutToolController,
									CToolType.IS_NOT_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.DRAG,
									'Drag',
									'DragButtonIcon',
									AToolController,
									CToolType.IS_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.RECTANGLE_BACKGROUND,
									'Rectangle Background',
									'RectangleBackgroundButtonIcon',
									RectangleBackgroundToolController,
									CToolType.IS_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.POLYGON_BACKGROUND,
									'Polygon Background',
									'PolygonBackgroundButtonIcon',
									PolygonBackgroundToolController,
									CToolType.IS_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.STATIC_ELEMENT,
									'Static Element',
									'StaticElementButtonIcon',
									StaticElementToolController,
									CToolType.IS_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.DYNAMIC_ELEMENT,
									'Dynamic Element',
									'DynamicElementButtonIcon',
									DynamicElementToolController,
									CToolType.IS_SELECTABLE
							),

							new ToolConfigVO
							(
									CToolId.ENEMY_PATH,
									'Enemy Path',
									'EnemyPathIcon',
									EnemyPathToolController,
									CToolType.IS_SELECTABLE
							)
						]
				;
	}
}