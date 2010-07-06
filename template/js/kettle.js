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
        to
    ;
    jsg.setClassNames("kettle-hop");
    for (i = 0; i<numChildNodes; i++) {
        from = childNodes.item(i);
        if (from.nodeType !== 1
        ||  from.tagName  !== "DIV"
        ) {
            continue;
        }
        hops = from.getElementsByTagName("DIV").item(0);
        hops = hops.getElementsByTagName("A");
        numHops = hops.length;
        for (j = 0; j < numHops; j++){
            hop = hops.item(j);
            to = hop.getAttribute("href");
            to = to.substring(1);
            to = document.getElementById(to);
            jsg.setClassNames(hop.getAttribute("class"));
            jsg.drawLine(
                parseInt(from.style.left,10) + 16, 
                parseInt(from.style.top,10) + 16, 
                parseInt(to.style.left,10) + 16, 
                parseInt(to.style.top,10) + 16
            );
        }
    }
    jsg.paint();
}
