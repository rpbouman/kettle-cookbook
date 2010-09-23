

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
		angle
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
			
            //jsg.drawLine(x1 + (x2 - x1), y1 + 5, x2, y2);
        }
    }
    jsg.paint();
}
