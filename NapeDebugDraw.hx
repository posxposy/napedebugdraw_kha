package;

import kha.Color;
import kha.graphics2.Graphics;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Edge;
import nape.shape.EdgeList;
import nape.shape.Shape;
import nape.shape.ShapeType;
import nape.space.Space;

using kha.graphics2.GraphicsExtension;
/**
 * themozokteam.com
 * @author The Mozok Team - Dmitry Hryppa
 */
class NapeDebugDraw
{


	private var objects:Array<Body>;
	private var space:Space;
	private var bodiesList:BodyList;
	public function new(space:Space) 
	{
		objects = new Array<Body>();
		this.space = space;
		bodiesList = space.bodies;
	}
		
	public function draw(graphics:Graphics):Void
	{
		for (i in 0...bodiesList.length) {
			var body:Body = bodiesList.at(i);		
			
			for (j in 0...body.shapes.length) {			
				var shape:Shape = body.shapes.at(j);
							
				graphics.color = Color.fromBytes(102, 102, 102);
				if (shape.type == ShapeType.POLYGON) {			
					var edgeList:EdgeList = shape.castPolygon.edges;		
					for (e in 0...edgeList.length) {
						var edge:Edge = edgeList.at(e);
						graphics.drawLine(edge.worldVertex1.x, edge.worldVertex1.y, edge.worldVertex2.x, edge.worldVertex2.y); 
					}
				} else {					
					graphics.drawCircle(body.worldCOM.x, body.worldCOM.y, shape.castCircle.radius);
				}
				
				graphics.color = Color.fromBytes(240, 81, 51);
				graphics.drawCircle(body.worldCOM.x, body.worldCOM.y, 1);			
			}
		}
	}
}