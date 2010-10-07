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

<xsl:variable name="input_dir" select="/index/@input_dir"/>
<xsl:variable name="output_dir" select="/index/@output_dir"/>

<xsl:template match="/">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Kettle Documentation: Items</title>
        <link rel="stylesheet" type="text/css" href="css/kettle.css"/>
        <link rel="stylesheet" type="text/css" href="css/kettle-toc.css"/>
        <link rel="shortcut icon" type="image/x-icon" href="images/spoon.png" />
    </head>
    <body class="kettle-items">
        <xsl:apply-templates select="index"/>
        <script type="text/javascript" src="js/kettle-toc.js"></script>
    </body>
</html>
</xsl:template>

<xsl:template match="/index">
    <div id="tab-strip">
        <!--
        
            TODO: toolbar to switch between categorical and hierarchical view
            
        -->
        <div id="tab-spacer-left" class="tab-spacer">&#160;</div>
        <div id="tab-toc-by-category" class="tab tab-active">
            <a href="#_tab-toc-by-category" onclick="tabClicked(this)">Categorical</a>
        </div>
        <div id="tab-toc-by-path" class="tab">
            <a href="#_tab-toc-by-path" onclick="tabClicked(this)">Hierarchical</a>            
        </div>
        <div id="tab-spacer-right" class="tab-spacer">&#160;</div>
    </div>
    <div id="tab-pages">
        <div id="tab-toc-by-category-page">
            <!-- <a name="toc-by-category"></a> -->
            <xsl:if test="file[extension[text()='kjb']]">
                <h3>Jobs</h3>
                <ul>
                    <xsl:for-each select="file[extension[text()='kjb']]">
                        <xsl:sort select="short_filename/text()"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </ul>
            </xsl:if>

            <xsl:if test="file[extension[text()='ktr']]">
                <h3>Transformations</h3>
                <ul>
                    <xsl:for-each select="file[extension[text()='ktr']]">
                        <xsl:sort select="short_filename/text()"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </div>
        <div id="tab-toc-by-path-page" style="hidden">
            <!-- <a name="toc-by-path"></a> -->
            <br />
            <div class="folder">
                <div class="folder-head">
                    <span class="folder-toggle">-</span>
                    <span class="folder-icon-open"></span>
                    <span class="folder-icon-closed"></span>
                    <span class="folder-label"><xsl:value-of select="$input_dir"/></span>
                </div>
                <div class="folder-body">
                    <xsl:call-template name="sub-folders"/>
                    <xsl:call-template name="folder-files">
                        <xsl:with-param name="folder" select="$input_dir"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<xsl:template match="file">
    <xsl:variable name="relative-path" select="substring-after(filename/text(), $input_dir)"/>
    <li>
        <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
        <a target="main">
            <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="concat('html', $relative-path, '.html')"/></xsl:attribute>
            <xsl:value-of select="short_filename/text()"/>
        </a>
    </li>
</xsl:template>


<xsl:variable name="folders" select="/index/folder"/>
<xsl:variable name="files" select="/index/file"/>

<xsl:template name="folder-files">
    <xsl:param name="folder"/>
    <xsl:if test="$files[path/text() = $folder]">
        <ul>
            <xsl:for-each select="$files[path/text() = $folder]">
                <xsl:sort select="short_filename/text()"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </ul>
    </xsl:if>
</xsl:template>

<xsl:template name="folder">
    <xsl:param name="folder"/>
    <xsl:variable name="full-name" select="$folder/@full-name"/>
    <xsl:if test="$files[starts-with(path/text(), $full-name)]">    
        <div class="folder">
            <div class="folder-head">
                <span class="folder-toggle" onclick="toggleTreeNode(this)">-</span>
                <span class="folder-icon-open"></span>
                <span class="folder-label"><xsl:value-of select="$folder/@short-name"/></span>
            </div>
            <div class="folder-body">
                <xsl:call-template name="sub-folders">
                    <xsl:with-param name="parent-folder" select="$full-name"/>
                </xsl:call-template>
                <xsl:call-template name="folder-files">
                    <xsl:with-param name="folder" select="$full-name"/>
                </xsl:call-template>
            </div>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template name="sub-folders">
    <xsl:param name="parent-folder" select="$input_dir"/>
    <xsl:for-each select="$folders[@parent-folder = $parent-folder]">
        <xsl:sort select="@short-name"/>
        <xsl:call-template name="folder">
            <xsl:with-param name="folder" select="."/>
        </xsl:call-template>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>