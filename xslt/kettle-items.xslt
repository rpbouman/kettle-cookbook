<?xml version="1.0"?>
<!--

This is kettle-items.xslt. This is part of kettle-cookbook.
Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

kettle-items.xslt - an XSLT transformation that generates the table of contents
for Kettle (aka Pentaho Data Integration) documentation.
This is part of kettle-cookbook, a kettle documentation generation framework.

Copyright (C) 2010 Roland Bouman
Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/

This library is free software; you can redistribute it and/or modify it under 
the terms of the GNU Lesser General Public License as published by the 
Free Software Foundation; either version 2.1 of the License, or (at your option)
any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with this library; if not, write to 
the Free Software Foundation, Inc., 
59 Temple Place, Suite 330, 
Boston, MA 02111-1307 USA

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
    method="html"
    version="4.0"
    encoding="UTF-8"
    omit-xml-declaration="yes"
    media-type="text/html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"    
/>

<xsl:variable name="input-dir" select="/index/@input_dir"/>
<xsl:variable name="output-dir" select="/index/@output_dir"/>

<xsl:template match="/">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Kettle Documentation: Items</title>
        <link rel="stylesheet" type="text/css" href="css/kettle.css"/>
        <link rel="shortcut icon" type="image/x-icon" href="images/spoon.png" />
    </head>
    <body class="kettle-items">
        <xsl:apply-templates select="index"/>
    </body>
</html>
</xsl:template>

<xsl:template match="/index">
    <div>
        <!--
        
            TODO: toolbar to switch between categorical and hierarchical view
            
        -->
    </div>
    <div id="toc-by-category">
        <h3>Connections</h3>
        t.b.d.
        <h3>Files</h3>    
        t.b.d.

        <xsl:if test="file[extension[text()='kjb']]">
            <h3>Jobs</h3>
            <ul>
                <xsl:apply-templates select="file[extension[text()='kjb']]"/>
            </ul>
        </xsl:if>

        <xsl:if test="file[extension[text()='ktr']]">
            <h3>Transformations</h3>
            <ul>
                <xsl:apply-templates select="file[extension[text()='ktr']]"/>
            </ul>
        </xsl:if>
    </div>
    <div id="toc-by-path">
        <!--
        
            TODO: treeview by directory
        
        -->
    </div>
</xsl:template>

<xsl:template match="file">
    <xsl:variable name="relative-path" select="substring-after(filename/text(), $input-dir)"/>
    <li>
        <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
        <a target="main">
            <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="concat('html', $relative-path, '.html')"/></xsl:attribute>
            <xsl:value-of select="short_filename"/>
        </a>
    </li>
</xsl:template>

</xsl:stylesheet>