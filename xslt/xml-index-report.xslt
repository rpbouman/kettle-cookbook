<?xml version="1.0"?>
<!--

    This is xcdf-report.xslt. 
    xcdf-report.xslt - an XSLT transformation that generates HTML documentation
    from a Pentaho Community Dashboard Framework dashboard definition file (xcdf).

    This is part of kettle-cookbook, a documentation generation framework for 
    the Pentaho Business Intelligence Suite.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

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

<xsl:variable name="item-type">folder index file</xsl:variable>

<xsl:template match="index">
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
        SCHEMA
    </body>
</html>    
</xsl:template>

</xsl:stylesheet>