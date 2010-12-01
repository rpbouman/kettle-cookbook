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

<xsl:variable name="item-type">mondrian schema</xsl:variable>

<xsl:template name="caption">
    <xsl:param name="node" select="."/>
    <xsl:choose>
        <xsl:when test="$node/@caption"><xsl:value-of select="$node/@caption"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$node/@name"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="Schema">
<html>
    <head>
    
        <xsl:copy-of select="$meta"/>
        <xsl:call-template name="favicon">
            <xsl:with-param name="name" select="'schema24'"/>
            <xsl:with-param name="extension" select="'gif'"/>
        </xsl:call-template>

        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'default'"/>
        </xsl:call-template>
        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'schema'"/>
        </xsl:call-template>
    </head>
    <body>
        <h1 class="schema"><xsl:value-of select="@name"/></h1>
        <p>Location: <code><xsl:value-of select="$param_filename"/></code>.</p>
        <xsl:apply-templates select="Cube"/>
        <xsl:apply-templates select="Dimension"/>
    </body>
</html>    
</xsl:template>

<xsl:template match="Cube">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <a>
        <xsl:attribute name="name">cube-<xsl:value-of select="$name"/></xsl:attribute>
    </a>
    <h2 class="cube"><xsl:value-of select="$caption"/></h2>
    <p>
        This cube is based on the fact table <code><xsl:value-of select="Table/@name"/></code>.
    </p>
    <xsl:call-template name="cube-diagram"/>
    <h3 class="dimension">Dimensions</h3>
    <xsl:for-each select="Dimension | DimensionUsage">        
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="."/>
    </xsl:for-each>
    <h3 class="measures">Measures</h3>
</xsl:template>

<xsl:template match="DimensionUsage">
    <xsl:variable name="caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <h4 class="dimension-usage"><xsl:value-of select="$caption"/></h4>
</xsl:template>

<xsl:template match="Dimension">
    <xsl:variable name="caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="local-name(..)='Schema'">
            <h2 class="dimension shared-dimension"><xsl:value-of select="$caption"/></h2>
        </xsl:when>
        <xsl:when test="local-name(..)='Cube'">
            <h4 class="dimension cube-dimension"><xsl:value-of select="$caption"/></h4>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template name="cube-diagram">
    <h3>Diagram</h3>
    <div class="fact-table">
        <div class="fact-table-header">
            <xsl:if test="Table/@schema">
                <xsl:value-of select="Table/@schema"/>.
            </xsl:if><xsl:value-of select="Table/@name"/>
        </div>
        <div class="fact-table-body">
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Expression</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="Measure">
                        <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="@column"/></td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>