/**
*   This is kettle-toc.js. This is part of kettle-cookbook.
*   Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/
*   
*   kettle-toc.js - javascript to implement tab page and treeview interactivity
*   for the table of contents (toc)
*   
*   Copyright (C) 2010 
*   Roland Bouman Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/
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

function tabClicked(tabLink) {
    var pageId = tabLink.getAttribute("href").substr(2) + "-page",
        tab = tabLink.parentNode,
        tabs = document.getElementById("tab-strip").childNodes,
        pages = document.getElementById("tab-pages").childNodes,
        numPages, el, pageIndex, display
    ;
    
    for (pageIndex = 0, numPages = tabs.length; pageIndex < numPages; pageIndex++){
        el = tabs.item(pageIndex);
        if (el.nodeType!==1 || el.className==="tab-spacer") {
            continue;
        }
        el.className = ((el===tab) ? "tab tab-active" : "tab");
    }

    for (pageIndex = 0, numPages = pages.length; pageIndex < numPages; pageIndex++){
        el = pages.item(pageIndex);
        if (el.nodeType!==1) {
            continue;
        }
        el.style.display = ((el.id === pageId) ? "" : "none");
    }
}

function toggleTreeNode(toggle) {
    var els, numEls, el, elIndex,
        oldState, newState, oldIconClass, newIconClass, display
    ;
    switch (oldState = toggle.innerHTML){
        case "+":
            oldIconClass = "folder-icon-closed";
            newIconClass = "folder-icon-open";
            newState = "-";
            display = "";
            break;
        case "-":
            oldIconClass = "folder-icon-open";
            newIconClass = "folder-icon-closed";
            newState = "+";
            display = "none";
            break;
    }
    
    els = toggle.parentNode.childNodes, numEls = els.length;
    for (elIndex = 0; elIndex < numEls; elIndex++){
        el = els.item(elIndex);
        if  (el.nodeType!==1 || el.className!==oldIconClass) {
            continue;
        }
        el.className = newIconClass;
        break;
    }
    
    els = toggle.parentNode.parentNode.childNodes, numEls = els.length;
    for (elIndex = 0; elIndex < numEls; elIndex++){
        el = els.item(elIndex);
        if (el.nodeType!==1 || el.className!=="folder-body"){
            continue;
        }
        el.style.display = display;
        break;
    }
    toggle.innerHTML = newState;
}