
function alignTowardsLine(array_x, array_y, origin_x, origin_y, line_x1, line_y1, line_x2, line_y2){
	
	// line vector
	var vx = line_x2-line_x1;
	var vy = line_y2-line_y1;
	
	// normalize it
	var vlen = Math.sqrt(vx*vx+vy*vy);
	vx /= vlen;
	vy /= vlen;
	
	// determine angle
	var angle = Math.acos(vy);
	if (vx > 0){
		angle = -angle;
	}
	
	// apply same angle to all points
	var res_x = [];
	var res_y = [];
	
	for(var i=0;i<array_x.length;i++){
		// center of object
		var cx = array_x[i] - origin_x;
		var cy = array_y[i] - origin_y;
		
		// rotate and offset to position
		res_x[i] = cx * Math.cos(angle) - cy * Math.sin(angle) + origin_x;
		res_y[i] = cx * Math.sin(angle) + cy * Math.cos(angle) + origin_y;
		
	}

	return {
		array_x: res_x,
		array_y: res_y
	};
	
}

function drawHops(){
    var id = "diagram",
        jsg = new jsGraphics(id),
        diagram = document.getElementById(id),
        childNodes = diagram.childNodes,
        numChildNodes = childNodes.length,
        from,
        i,
        hops,
        j,
        numHops,
        hop,
        to,
		offset = 16,
		x1, y1, x2, y2,
		x, y,
		m = Math, pi2 = 2 * m.PI,
		angle,
		arrowWidth = 10,
		arrowHeight = 20,
		arrowPos = 0.59
    ;
    jsg.setClassNames("kettle-hop");
    for (i = 0; i<numChildNodes; i++) {
        from = childNodes.item(i);
        if (from.nodeType !== 1
        ||  from.tagName  !== "DIV"
		||	from.className==="note"
        ) {
            continue;
        }
		x1 = parseInt(from.style.left, 10) + offset;
		y1 = parseInt(from.style.top, 10)  + offset;
        hops = from.getElementsByTagName("DIV").item(0);
        hops = hops.getElementsByTagName("A");
        numHops = hops.length;
        for (j = 0; j < numHops; j++){
            hop = hops.item(j);
            to = hop.getAttribute("href");
            to = to.substring(1);
            to = document.getElementById(to);
			x2 = parseInt(to.style.left, 10) + offset;
			y2 = parseInt(to.style.top, 10) + offset;
            jsg.setClassNames(hop.getAttribute("class"));
            jsg.drawLine(x1, y1, x2, y2);
			
			// calculate placement the way from source to target
			var xMid = x1 + arrowPos*(x2-x1);
			var yMid = y1 + arrowPos*(y2-y1);
			
			// place a triangle there
			var xLeft = xMid - arrowWidth/2;
			var yLeft = yMid;
			
			var xRight = xMid + arrowWidth/2;
			var yRight = yMid;
			
			var xTop = xMid;
			var yTop = yMid + arrowHeight;
			
			var polygon_x = [xLeft, xTop, xRight];
			var polygon_y = [yLeft, yTop, yRight];
			
			var aligned = alignTowardsLine(polygon_x, polygon_y, xMid, yMid, x1, y1, x2, y2);
			jsg.fillPolygon(aligned.array_x, aligned.array_y);
			
            //jsg.drawLine(x1 + (x2 - x1), y1 + 5, x2, y2);
        }
    }
    jsg.paint();
}
