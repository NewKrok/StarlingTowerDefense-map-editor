package leveleditor.controller
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import leveleditor.EditorWorld;

	import starlingtowerdefense.utils.BrushPattern;

	public class PolygonToolController
	{
		private const MIN_DISTANCE:Number = 100;

		protected var _polygonNodePoints:Vector.<Vector.<NodeView>> = new Vector.<Vector.<NodeView>>();
		protected var _polygonContainer:Vector.<Sprite> = new <Sprite>[];

		protected var _editorWorld:EditorWorld;
		protected var _elementContainer:Sprite;
		protected var _draggedNode:NodeView;

		protected var _isActivated:Boolean = false;

		private var _lastAddedNodeTime:Number = 0;

		public function PolygonToolController( editorWorld:EditorWorld, elementContainer:Sprite )
		{
			this._editorWorld = editorWorld;
			this._elementContainer = elementContainer;
		}

		public function activate():void
		{
			this._isActivated = true;

			this._editorWorld.addEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._editorWorld.addEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._editorWorld.stage.addEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._elementContainer.addEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		public function deactivate():void
		{
			this._isActivated = false;

			this._editorWorld.removeEventListener( MouseEvent.CLICK, this.addPolygonRequest );
			this._editorWorld.removeEventListener( MouseEvent.MOUSE_MOVE, this.onRouteMouseMove );
			this._editorWorld.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onStageMouseUpHandler );

			this._elementContainer.removeEventListener( MouseEvent.MOUSE_DOWN, this.onRouteMouseDown );
		}

		protected function onRouteMouseMove( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				this.draw();
			}
		}

		protected function onRouteMouseDown( e:MouseEvent ):void
		{
			if( e.target is NodeView )
			{
				this._editorWorld.blockWorldDrag = true;

				this._draggedNode = e.target as NodeView;
				( this._draggedNode as Sprite ).startDrag();
			}
		}

		protected function onStageMouseUpHandler( e:MouseEvent ):void
		{
			if( this._draggedNode )
			{
				( this._draggedNode as Sprite ).stopDrag();
				this._draggedNode = null;

				this.calculatePolygonNodes();

				this.draw();

				this._lastAddedNodeTime = new Date().time;
			}

			this._editorWorld.blockWorldDrag = false;
		}

		private function calculatePolygonNodes():void
		{
			for( var i:int = 0; i < this._polygonNodePoints.length; i++ )
			{
				var route:Vector.<NodeView> = this._polygonNodePoints[ i ];

				for( var j:int = 0; j < route.length; j++ )
				{
					var distance:Number;
					var xLength:Number;
					var yLength:Number;
					var angle:Number;
					var newPoint:Point;
					var index:int;

					if( j == 0 )
					{
						xLength = route[ j ].x - route[ route.length - 1 ].x;
						yLength = route[ j ].y - route[ route.length - 1 ].y;
						index = route.length - 1;
					}
					else
					{
						xLength = route[ j ].x - route[ j - 1 ].x;
						yLength = route[ j ].y - route[ j - 1 ].y;
						index = j - 1;
					}

					distance = Math.sqrt( Math.pow( xLength, 2 ) + Math.pow( yLength, 2 ) );

					if( distance > MIN_DISTANCE * 2 )
					{
						angle = Math.atan2( yLength, xLength );

						newPoint = new Point(
								route[ j ].x + MIN_DISTANCE * Math.cos( angle ),
								route[ j ].y + MIN_DISTANCE * Math.sin( angle )
						);

						this._polygonNodePoints[ i ] = this.addNodeView( route, this._polygonContainer[ i ], newPoint, index );

						if( index == j - 1 )
						{
							j--;
						}
					}

					var nextDistance:Number;
					if( j == route.length - 1 )
					{
						xLength = route[ j ].x - route[ 0 ].x;
						yLength = route[ j ].y - route[ 0 ].y;
						index = 0;
					}
					else
					{
						xLength = route[ j ].x - route[ j + 1 ].x;
						yLength = route[ j ].y - route[ j + 1 ].y;
						index = j + 1;
					}

					distance = Math.sqrt( Math.pow( xLength, 2 ) + Math.pow( yLength, 2 ) );

					if( distance > MIN_DISTANCE * 2 )
					{
						angle = Math.atan2( yLength, xLength );

						if( angle > Math.PI )
						{
							angle += Math.PI * 2;
						}

						newPoint = new Point(
								route[ j ].x - MIN_DISTANCE * Math.cos( angle ),
								route[ j ].y - MIN_DISTANCE * Math.sin( angle )
						);

						this._polygonNodePoints[ i ] = this.addNodeView( route, this._polygonContainer[ i ], newPoint, index );
					}

					route = this._polygonNodePoints[ i ];
				}
			}
		}

		protected function addPolygonRequest( e:MouseEvent ):void
		{
			// Currently limited for just 1 polygon
			if( this._polygonNodePoints.length < 1 && !this._editorWorld.isWorldDragged() && !this._draggedNode && new Date().time - this._lastAddedNodeTime > 1000 )
			{
				this.addNewPolygonToPoint( _editorWorld.mouseX, _editorWorld.mouseY );
				this.draw();
			}
		}

		protected function addNewPolygonToPoint( x:Number, y:Number ):void
		{
			var newPolygon:Vector.<Point> = new <Point>[
				new Point( x - this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y - this.MIN_DISTANCE / 2 ),
				new Point( x + this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 ),
				new Point( x - this.MIN_DISTANCE / 2, y + this.MIN_DISTANCE / 2 )
			];

			this.addNewPolygon( newPolygon );
		}

		private function addNewPolygon( polygon:Vector.<Point> ):void
		{
			var container:Sprite = new Sprite();
			this._elementContainer.addChild( container );
			this._polygonContainer.push( container );

			this._polygonNodePoints.push( new Vector.<NodeView> );

			this.addNodeViews( this._polygonNodePoints[ this._polygonNodePoints.length - 1 ], container, polygon );
		}

		private function addNodeViews( target:Vector.<NodeView>, container:Sprite, points:Vector.<Point> ):void
		{
			for( var i:int = 0; i < points.length; i++ )
			{
				this.addNodeView( target, container, points[ i ] );
			}
		}

		private function addNodeView( target:Vector.<NodeView>, container:Sprite, point:Point, index:int = -1 ):Vector.<NodeView>
		{
			var nodeView:NodeView = new NodeView();
			nodeView.buttonMode = true;
			container.addChild( nodeView );

			nodeView.x = point.x;
			nodeView.y = point.y;

			if( index == -1 )
			{
				target.push( nodeView );
			}
			else
			{
				var newOrderedTarget:Vector.<NodeView> = new <NodeView>[];
				for( var i:int = 0; i < target.length; i++ )
				{
					if( i == index )
					{
						newOrderedTarget.push( nodeView )
					}
					newOrderedTarget.push( target[ i ] );
				}
				target = newOrderedTarget;
			}

			return target;
		}

		private function draw():void
		{
			for( var i:int = 0; i < this._polygonNodePoints.length; i++ )
			{
				var points:Vector.<Point> = new <Point>[];

				this._polygonContainer[ i ].graphics.clear();
				this._polygonContainer[ i ].graphics.lineStyle( 1 );
				this._polygonContainer[ i ].graphics.beginFill( 0, .1 );

				var polygon:Vector.<NodeView> = this._polygonNodePoints[ i ];
				this._polygonContainer[ i ].graphics.moveTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new Point( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				for( var j:int = 1; j < polygon.length; j++ )
				{
					this._polygonContainer[ i ].graphics.lineTo( polygon[ j ].x, polygon[ j ].y );
					points.push( new Point( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
					points.push( new Point( polygon[ j ].x / 2, polygon[ j ].y / 2 ) );
				}

				this._polygonContainer[ i ].graphics.lineTo( polygon[ 0 ].x, polygon[ 0 ].y );
				points.push( new Point( polygon[ j - 1 ].x / 2, polygon[ j - 1 ].y / 2 ) );
				points.push( new Point( polygon[ 0 ].x / 2, polygon[ 0 ].y / 2 ) );

				this._polygonContainer[ i ].graphics.endFill();

				if( !(this._polygonContainer[ i ].getChildAt( 0 ) is NodeView ) )
				{
					this._polygonContainer[ i ].removeChildAt( 0 );
				}

				this._polygonContainer[ i ].addChildAt( this.createIngameGraphics( points ), 0 );
			}
		}

		private function createIngameGraphics( points:Vector.<Point> ):DisplayObject
		{
			// Temporary constants
			var ingameGraphics:Sprite = new BrushPattern( points, new terrain_1, new terrain_0_content, 30, 40 );

			return ingameGraphics;
		}

		public function loadPolygons( polygons:Array ):void
		{
			for( var i:int = 0; i < polygons.length; i++ )
			{
				var newPolygon:Vector.<Point> = new <Point>[];

				for( var j:int = 0; j < polygons[i].length; j++ )
				{
					newPolygon.push( new Point( polygons[i][j].x, polygons[i][j].y ) );
				}

				this.addNewPolygon( newPolygon );
			}

			this.draw();
		}

		public function getPolygons():Array
		{
			var polygons:Array = [];

			for( var i:int = 0; i < this._polygonNodePoints.length; i++ )
			{
				var polygonElements:Array = [];

				for( var j:int = 0; j < this._polygonNodePoints[ i ].length; j++ )
				{
					polygonElements.push( {
						x: this._polygonNodePoints[ i ][ j ].x,
						y: this._polygonNodePoints[ i ][ j ].y
					} );
				}

				polygons.push( polygonElements );
			}

			return polygons;
		}
	}
}