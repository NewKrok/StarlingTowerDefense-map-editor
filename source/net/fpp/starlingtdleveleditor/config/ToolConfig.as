/**
 * Created by newkrok on 17/05/16.
 */
package net.fpp.starlingtdleveleditor.config
{
	import net.fpp.starlingtdleveleditor.constant.CToolId;
	import net.fpp.starlingtdleveleditor.controller.exportlevel.ExportToolController;
	import net.fpp.starlingtdleveleditor.controller.importlevel.ImportToolController;
	import net.fpp.starlingtdleveleditor.controller.polygonbackground.PolygonBackgroundToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomin.ZoomInToolController;
	import net.fpp.starlingtdleveleditor.controller.zoomout.ZoomOutToolController;
	import net.fpp.starlingtdleveleditor.vo.ToolConfigVO;

	public class ToolConfig
	{
		public const configs:Vector.<ToolConfigVO> = new <ToolConfigVO>[
			new ToolConfigVO( CToolId.IMPORT, 'Import', 'ImportButtonIcon', ImportToolController, false ),
			new ToolConfigVO( CToolId.EXPORT, 'Export', 'ExportButtonIcon', ExportToolController, false ),
			new ToolConfigVO( CToolId.ZOOM_IN, 'Zoom In', 'ZoomInButtonIcon', ZoomInToolController, false ),
			new ToolConfigVO( CToolId.ZOOM_OUT, 'Zoom Out', 'ZoomOutButtonIcon', ZoomOutToolController, false ),
			new ToolConfigVO( CToolId.POLYGON_BACKGROUND, 'Polygon Background', 'PolygonBackgroundButtonIcon', PolygonBackgroundToolController, true )
		];
	}
}