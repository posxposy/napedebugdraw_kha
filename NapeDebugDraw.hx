package;
import kha.Color;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.Arbiter;
import nape.dynamics.ArbiterList;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.Contact;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.Compound;
import nape.shape.Edge;
import nape.shape.EdgeList;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.ShapeType;
import nape.space.Space;

using kha.graphics2.GraphicsExtension;

/**
 * http://themozokteam.com/
 * @author The Mozok Team - Dmitry Hryppa
 */
class NapeDebugDraw
{

	public var drawCollisionContacts:Bool = false;
	public var drawCollisionEdges:Bool = false;
	public var drawBodyBounds:Bool = false;
	public var drawConstrainAnchors:Bool = false;

	private var objects:Array<Body>;
	private var space:Space;
	private var bodiesList:BodyList;
	
	private var shapeColor:Color;
	private var bodyBoundsColor:Color;
	private var centerColor:Color;
	private var constraintColor:Color;
	private var arbiterEdgeColor:Color;
	private var arbiterContactsColor:Color;
	public function new(space:Space) 
	{
		objects = new Array<Body>();
		this.space = space;
		bodiesList = space.bodies;
		shapeColor = Color.fromBytes(48, 110, 115);
		centerColor = Color.fromBytes(185, 18, 27);
		constraintColor = Color.fromBytes(4, 191, 191);
		arbiterEdgeColor = Color.fromBytes(245, 79, 41);
		bodyBoundsColor = Color.fromBytes(89, 82, 65);	
		arbiterContactsColor = Color.fromBytes(169, 207, 84);
	}
		
	public function draw(graphics:Graphics):Void
	{
		for (i in 0...bodiesList.length) {
			var body:Body = bodiesList.at(i);
			if (drawBodyBounds){
				graphics.color = bodyBoundsColor;
				graphics.drawRect(body.bounds.x, body.bounds.y, body.bounds.width, body.bounds.height);
			}
			
			for (j in 0...body.shapes.length) {			
				var shape:Shape = body.shapes.at(j);								
				graphics.color = shapeColor;
				if (shape.type == ShapeType.POLYGON) {			
					var edgeList:EdgeList = shape.castPolygon.edges;					
					for (e in 0...edgeList.length) {
						var edge:Edge = edgeList.at(e);
						graphics.drawLine(edge.worldVertex1.x, edge.worldVertex1.y, edge.worldVertex2.x, edge.worldVertex2.y);									
					}					
				} else {					
					graphics.drawCircle(body.worldCOM.x, body.worldCOM.y, shape.castCircle.radius);
				}
				
				graphics.color = centerColor;
				graphics.fillCircle(body.worldCOM.x, body.worldCOM.y, 2);
			}
			
			if (drawConstrainAnchors){
				graphics.color = constraintColor;
				for (k in 0...body.constraints.length) {
					if (Std.is(body.constraints.at(k), PivotJoint)) {
						var joint:PivotJoint = cast(body.constraints.at(k), PivotJoint);
						if (joint.active){
							graphics.fillCircle(joint.anchor1.x, joint.anchor1.y, 2);
							graphics.pushTransformation(graphics.transformation.multmat(FastMatrix3.translation(body.position.x, body.position.y)).multmat(FastMatrix3.rotation(body.rotation)).multmat(FastMatrix3.translation( -body.position.x, -body.position.y)));							
							graphics.fillCircle(joint.anchor2.x + body.position.x, joint.anchor2.y + body.position.y, 2);
							graphics.popTransformation();
						}
					}
				}
			}
		}	
				
		for (a in 0...space.arbiters.length) {
			if (space.arbiters.at(a).collisionArbiter != null){
				var arbiter:CollisionArbiter = space.arbiters.at(a).collisionArbiter;				
				if (drawCollisionEdges) {
					if (arbiter.referenceEdge1 != null && arbiter.referenceEdge2 != null){
						var edge1:Edge = arbiter.referenceEdge1;
						var edge2:Edge = arbiter.referenceEdge2;
						graphics.color = arbiterEdgeColor;
						graphics.drawLine(edge1.worldVertex1.x, edge1.worldVertex1.y, edge1.worldVertex2.x, edge1.worldVertex2.y);
						graphics.drawLine(edge2.worldVertex1.x, edge2.worldVertex1.y, edge2.worldVertex2.x, edge2.worldVertex2.y);
					} else {
						//for circle...						
					}
				}
				
				if (drawCollisionContacts){
					for (c in 0...arbiter.contacts.length) {
						var contact:Contact = arbiter.contacts.at(c);
						graphics.color = arbiterContactsColor;
						graphics.fillCircle(contact.position.x, contact.position.y, 2);
					}
				}
			}
		}		
	}	
}