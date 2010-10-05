/**
*   This is kettle.js. This is part of kettle-cookbook.
*   Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/
*   
*   kettle.js - a javascript file that helps draw the hops for the diagrams
*   
*   Copyright (C) 2010 
*   Roland Bouman Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/
*   Chodnicki Slawomir
*   
*   This library is free software; you can redistribute it and/or modify it under 
*   the terms of the GNU Lesser General Public License as published by the 
*   Free Software Foundation; either version 2.1 of the License, or (at your option)
*   any later version.

*   This library is distributed in the hope that it will be useful, but WITHOUT ANY 
*   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
*   PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*   
*   You should have received a copy of the GNU Lesser General Public License along 
*   with this library; if not, write to 
*   the Free Software Foundation, Inc., 
*   59 Temple Place, Suite 330, 
*   Boston, MA 02111-1307 USA
*   
*/
var regexpStepHopCopyData = /\bstep-hop-copy-data\b/,               //used for steps that copy data
    regexpStepHopDistributeData = /\bstep-hop-distribute-data\b/,   //used for steps that distribute data
    regexpStepHopTrue = /\b(step|entry)-hop-true\b/,         //used for hops that route "true" data
    regexpStepHopFalse = /\b(step|entry)-hop-false\b/,              //used for hops that route "false" data
    regexpEntryHopUnconditional = /\bentry-hop-unconditional\b/     //used for unconditional job entry hops.
;

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
		xDiff, yDiff,
		m = Math, pi2 = 2 * m.PI,
		angle,
		arrowWidth = 10,
		arrowHeight = 20,
		arrowPos = 0.59,
        className, copyData
    ;
    jsg.setClassNames("kettle-hop");
    for (i = 0; i<numChildNodes; i++) {
        from = childNodes.item(i);
        if (from.nodeType !== 1         //element node
        ||  from.tagName  !== "DIV"
        ||  from.className==="note"
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
            to = decodeURIComponent(to.substring(1));
            to = document.getElementById(to);

			x2 = parseInt(to.style.left, 10) + offset;
            xDiff = x2 - x1;
			y2 = parseInt(to.style.top, 10) + offset;
            yDiff = y2 - y1;

            jsg.setClassNames(hop.getAttribute("class"));
            jsg.drawLine(x1, y1, x2, y2);
			
			// calculate placement the way from source to target
			var xMid = x1 + arrowPos * xDiff;
			var yMid = y1 + arrowPos * yDiff;
			
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
    
            className = hop.className;
            if (regexpStepHopTrue.test(className) ) {
                hopIcon = "hop-true-icon";
            }
            else
            if (regexpStepHopFalse.test(className) ) {
                hopIcon = "hop-false-icon";
            }
            else
            if (regexpEntryHopUnconditional.test(className) ) {
                hopIcon = "entry-hop-unconditional-icon";
            }
            else
            if (regexpStepHopCopyData.test(className) ) {
                hopIcon = "step-hop-copy-data-icon";
            }
            else {
                hopIcon = false;
            }
            
            if (hopIcon) {
                hopIconEl = document.createElement("DIV");
                hopIconEl.className = hopIcon;
                hopIconEl.style.left = x1 + (xDiff * .33) - 8 + "px";
                hopIconEl.style.top = y1 + (yDiff * .33) - 8 + "px";
                diagram.appendChild(hopIconEl);
            }
        }
    }
    jsg.paint();
}
