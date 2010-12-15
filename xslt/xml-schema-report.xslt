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
        <xsl:when test="$node/@name"><xsl:value-of select="$node/@name"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="tablename">
    <xsl:param name="node" select="."/>
    <code><xsl:if test="$node/@schema"><xsl:value-of select="$node/@schema"/>.</xsl:if><xsl:value-of select="$node/@name"/></code>
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
    <xsl:variable name="dimensions" select="Dimension | DimensionUsage"/>
    <xsl:variable name="measures" select="Measure"/>
    <a>
        <xsl:attribute name="name">cube-<xsl:value-of select="$name"/></xsl:attribute>
    </a>
    <h2 class="cube"><xsl:value-of select="$caption"/></h2>
    <p>
        This cube is based on the fact table <code><xsl:value-of select="Table/@name"/></code>.
    </p>
    <xsl:call-template name="cube-diagram"/>
    <h3 class="dimension">Dimensions</h3>
    <xsl:choose>
        <xsl:when test="$dimensions">
            <xsl:for-each select="$dimensions">
                <xsl:sort select="@name"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            This does not use or define any dimensions. 
            This probably means that this cube still requires some design efforts.
        </xsl:otherwise>
    </xsl:choose>
    <h3 class="measures">Measures</h3>
    <xsl:choose>
        <xsl:when test="$measures">
            <xsl:for-each select="$measures">
                <xsl:sort select="@name"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            This does not use or define any measures. 
            This probably means that this cube still requires some design efforts.
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="DimensionUsage">
    <xsl:variable name="caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <h4 class="dimension-usage"><xsl:value-of select="$caption"/></h4>
    <p>
        This shared dimension is 
        <a>
            <xsl:attribute name="href">#shared-dimension-<xsl:value-of select="@source"/></xsl:attribute>
            documented elsewhere
        </a>.
    </p>
</xsl:template>

<xsl:template match="Dimension">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="usages" select="..//DimensionUsage[@source = $name]"/>
    <xsl:variable name="caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="local-name(..)='Schema'">            
            <h2 class="dimension shared-dimension">
                <a>
                    <xsl:attribute name="name">shared-dimension-<xsl:value-of select="$name"/></xsl:attribute>
                    <xsl:value-of select="$caption"/>
                </a>
            </h2>            
            <h3>Usages</h3>
            <xsl:choose>
                <xsl:when test="$usages">
                    <p>
                        This shared dimension is used in the following cubes:
                    </p>
                    <ul>
                        <xsl:for-each select="$usages">
                            <li>
                                In the cube                                 
                                <xsl:for-each select="..">
                                    <a>
                                        <xsl:attribute name="href">#cube-<xsl:value-of select="@name"/></xsl:attribute>
                                        <xsl:call-template name="caption"/>
                                    </a>
                                </xsl:for-each>
                                as the dimension 
                                <a>
                                    <xsl:attribute name="href">#cube-<xsl:value-of select="@name"/></xsl:attribute>
                                    <xsl:call-template name="caption"/>
                                </a>.
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        Currently this dimension is not used in any cubes.
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="local-name(..)='Cube'">
            <h4 class="dimension cube-dimension"><xsl:value-of select="$caption"/></h4>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template name="dimension">
    <xsl:variable name="source" select="@source"/>
    <xsl:variable 
        name="dimension" 
        select="
            .[local-name()='Dimension']
        |   ../../Dimension[@name = $source]
        "
    />
    <xsl:variable name="dimension-caption">
        <xsl:call-template name="caption"/>
    </xsl:variable>
    <table class="dimension" cellpadding="0" cellspacing="0">
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="$source">dimension-usage</xsl:when>
                <xsl:otherwise>dimension</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <thead>
            <tr>
                <th colspan="100%">
                    <a>
                        <xsl:if test="$source">
                            <xsl:attribute name="href">
                                <xsl:attribute name="href">#shared-dimension-<xsl:value-of select="$source"/></xsl:attribute>                            
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$dimension-caption"/>
                    </a>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <xsl:for-each select="$dimension/Hierarchy">
                    <xsl:variable name="caption"><xsl:call-template name="caption"/></xsl:variable>
                    <xsl:variable name="hierarchy-caption">
                        <xsl:choose>
                            <xsl:when test="$caption!=''"><xsl:value-of select="$caption"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$dimension-caption"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <td class="hierarchy">
                        <table class="hierarchy">
                            <thead>
                                <tr>
                                    <th colspan="100%">
                                        <xsl:value-of select="$hierarchy-caption"/>
                                        <xsl:choose> 
                                            <xsl:when test="Table">
                                                (<xsl:for-each select="Table">
                                                    <xsl:call-template name="tablename"/>
                                                </xsl:for-each>)
                                            </xsl:when>
                                            <xsl:when test="Join">
                                                (<xsl:for-each select=".//Table">
                                                    <xsl:if test="position() != 1">, </xsl:if>
                                                    <xsl:call-template name="tablename"/>
                                                </xsl:for-each>)
                                            </xsl:when>
                                        </xsl:choose>
                                    </th>
                                </tr>
                                <xsl:if test="@hasAll='true'">
                                    <tr>
                                        <td class="level">
                                            <xsl:choose>
                                                <xsl:when test="@allMemberCaption"><xsl:value-of select="@allMemberCaption"/></xsl:when>
                                                <xsl:when test="@allMemberName"><xsl:value-of select="@allMemberName"/></xsl:when>
                                                <xsl:otherwise>All <xsl:value-of select="$hierarchy-caption"/>s</xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>                                                        
                                </xsl:if>
                                <xsl:for-each select="Level">
                                    <tr>
                                        <td class="level">
                                            <xsl:value-of select="@name"/>
                                            (<code><xsl:if test="@table"><xsl:value-of select="@table"/>.</xsl:if><xsl:value-of select="@column"/></code>)
                                        </td>                                                            
                                    </tr>
                                </xsl:for-each>
                            </thead>
                        </table>
                    </td>
                </xsl:for-each>
            </tr>
        </tbody>
    </table>
</xsl:template>

<xsl:template name="cube-diagram">
    <xsl:variable name="dimensions" select="Dimension | DimensionUsage"/>
    <xsl:variable name="num-dimensions" select="count($dimensions)"/>

    <xsl:variable name="top-dimensions" select="$dimensions[position() &lt;= $num-dimensions div 4]"/>
    <xsl:variable name="right-dimensions" select="$dimensions[position() &gt; $num-dimensions div 4 and position() &lt;= 2 * $num-dimensions div 4]"/>
    <xsl:variable name="bottom-dimensions" select="$dimensions[position() &gt; 2 * $num-dimensions div 4  and position() &lt;= 3 * $num-dimensions div 4]"/>
    <xsl:variable name="left-dimensions" select="$dimensions[position() &gt; 3 * $num-dimensions div 4]"/>

    <h3>Multidimensional Model</h3>
    <table class="diagram" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <td>
                </td>
                <td class="top dimensions">
                    <xsl:for-each select="$top-dimensions">
                        <xsl:call-template name="dimension"/>
                    </xsl:for-each>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td class="left dimensions">
                    <xsl:for-each select="$left-dimensions">
                        <xsl:call-template name="dimension"/>
                    </xsl:for-each>
                </td>
                <td class="measures">
                    <center>
                        <table class="measures" cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <th colspan="100%">
                                        Measures 
                                        (<xsl:for-each select="Table">
                                            <xsl:call-template name="tablename"/>
                                        </xsl:for-each>)
                                    </th>
                                </tr>
                                <tr>
                                    <th>Name</th>
                                    <th>Expression</th>
                                    <th>Aggregator</th>
                                    <th>Type</th>
                                    <th>Format</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="Measure">
                                    <tr>
                                        <th><xsl:value-of select="@name"/></th>
                                        <td><code><xsl:value-of select="@column"/></code></td>
                                        <td><code><xsl:value-of select="@aggregator"/></code></td>
                                        <td><code><xsl:value-of select="@datatype"/></code></td>
                                        <td><code><xsl:value-of select="@formatString"/></code></td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </center>
                </td>
                <td class="right dimensions">
                    <xsl:for-each select="$right-dimensions">
                        <xsl:call-template name="dimension"/>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td></td>
                <td class="bottom dimensions">
                    <xsl:for-each select="$bottom-dimensions">
                        <xsl:call-template name="dimension"/>
                    </xsl:for-each>
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>
</xsl:template>

</xsl:stylesheet>