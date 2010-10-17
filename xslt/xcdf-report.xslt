<?xml version="1.0"?>
<!--

    This is xcdf-report.xslt. This is part of kettle-cookbook.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    xcdf-report.xslt - an XSLT transformation that generates HTML documentation
    from a Pentaho Community Dashboard Framework dashboard definition file (xcdf).
    This is part of kettle-cookbook, a pentaho documentation generation framework.

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

<xsl:import href="shared.xslt"/>
<xsl:import href="file.xslt"/>

<xsl:variable name="item-type">cdf dashboard</xsl:variable>

<xsl:template match="/">
<html>    
    <head>
    
        <xsl:copy-of select="$meta"/>
        <xsl:call-template name="favicon">
            <xsl:with-param name="name" select="'cdfFileType'"/>
        </xsl:call-template>

        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'default'"/>
        </xsl:call-template>
        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'cdf'"/>
        </xsl:call-template>
    </head>
    <body>
        <xsl:for-each select="$document">
            <xsl:apply-templates select="cdf"/>
        </xsl:for-each>
    </body>
</html>
</xsl:template>

<xsl:template match="cdf">
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="author"/>
    <xsl:call-template name="description"/>
</xsl:template>

<xsl:template match="title">
    <h1><xsl:copy-of select="node()"/></h1>
</xsl:template>

<xsl:template match="author">
    <div>Author: <xsl:copy-of select="node()"/></div>
</xsl:template>

</xsl:stylesheet>