/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.config
{
	import net.fpp.starlingtdleveleditor.constant.CToolId;
	import net.fpp.starlingtdleveleditor.controller.exportlevel.ExportToolController;
	import net.fpp.starlingtdleveleditor.controller.importlevel.ImportToolController;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.PolygonToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomin.ZoomInToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomout.ZoomOutToolController;
	import net.fpp.starlingtdleveleditor.vo.ToolConfigVO;

	public class ToolConfig
	{
		public const configs:Vector.<ToolConfigVO> = new <ToolConfigVO>[
			new ToolConfigVO( CToolId.IMPORT, 'Import', 'ImportButtonIcon', new ImportToolController ),
			new ToolConfigVO( CToolId.EXPORT, 'Export', 'ExportButtonIcon', new ExportToolController ),
			new ToolConfigVO( CToolId.ZOOM_IN, 'Zoom In', 'ZoomInButtonIcon', new ZoomInToolController ),
			new ToolConfigVO( CToolId.ZOOM_OUT, 'Zoom Out', 'ZoomOutButtonIcon', new ZoomOutToolController ),
			new ToolConfigVO( CToolId.POLYGON_BACKGROUND, 'Polygon Background', 'PolygonBackgroundButtonIcon', new PolygonToolController )
		];
	}
}