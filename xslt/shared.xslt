<?xml version="1.0"?>
<!--

    This is shared.xslt. This is part of kettle-cookbook.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    shared.xslt - an XSLT transformation that defines variables, parameters, templets etc
    required for each specific xslt file in kettle-cookbook.
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

<!-- =========================================================================
    Output
========================================================================== -->
<xsl:output
    method="html"
    version="4.0"
    encoding="UTF-8"
    omit-xml-declaration="yes"
    media-type="text/html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
/>


<!-- =========================================================================
    XSLT VARIABLES
========================================================================== -->
<xsl:variable name="input-dir" select="/index/@input_dir"/>
<xsl:variable name="output-dir" select="/index/@output_dir"/>

<xsl:variable name="css-dir" select="'css/'"/>
<xsl:variable name="js-dir" select="'js/'"/>
<xsl:variable name="images-dir" select="'images/'"/>

<!--
    String utilities
-->
<xsl:variable name="lower-case-alphabet" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="upper-case-alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template name="lower-case">
	<xsl:param name="text"/>
	<xsl:value-of select="translate($text, $upper-case-alphabet, $lower-case-alphabet)"/>
</xsl:template>

<xsl:template name="upper-case">
	<xsl:param name="text"/>
	<xsl:value-of select="translate($text, $lower-case-alphabet, $upper-case-alphabet)"/>
</xsl:template>

<xsl:template name="replace">
	<xsl:param name="text"/>
	<xsl:param name="search"/>
	<xsl:param name="replace" select="''"/>
	<xsl:choose>
		<xsl:when test="contains($text, $search)">
			<xsl:call-template name="replace">
				<xsl:with-param 
					name="text" 
					select="
						concat(
							substring-before($text, $search)
						,	$replace
						,	substring-after($text, $search)
						)
					"
				/>
				<xsl:with-param name="search" select="$search"/>
				<xsl:with-param name="replace" select="$replace"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="replace-backslashes-with-slash">
	<xsl:param name="text"/>
	<xsl:call-template name="replace">
		<xsl:with-param name="text" select="$text"/>
		<xsl:with-param name="search" select="'\'"/>
		<xsl:with-param name="replace" select="'/'"/>
	</xsl:call-template>
</xsl:template>


<!--
    Number utilities
-->
<xsl:template name="max">
    <xsl:param name="values"/>
    <xsl:for-each select="$values">
        <xsl:sort data-type="number" order="descending"/>
        <xsl:if test="position()=1">
          <xsl:value-of select="."/>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template name="min">
    <xsl:param name="values"/>
    <xsl:for-each select="$values">
        <xsl:sort data-type="number"/>
        <xsl:if test="position()=1">
          <xsl:value-of select="."/>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
    Generic templates
-->
<xsl:template name="copy-contents">
    <xsl:param name="parent" select="."/>
    <xsl:for-each select="$parent/node()"><xsl:copy-of select="."/></xsl:for-each>
</xsl:template>


<xsl:template name="description">
    <xsl:param name="node" select="."/>
    <xsl:param name="type" select="$item-type"/>
    <xsl:for-each select="$node">
        <p>
            <xsl:choose>
                <xsl:when test="$node/description[text()]">
                    <xsl:value-of select="$node/description"/>
                </xsl:when>
                <xsl:otherwise>
                    This <xsl:value-of select="$type"/> does not have a description.
                </xsl:otherwise>
            </xsl:choose>
        </p>
        <xsl:if test="$node/extended_description[text()]">
            <p>
                <xsl:value-of select="$node/extended_description"/>
            </p>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:variable name="meta">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="Generator" content="kettle-cookbook - see http://code.google.com/p/kettle-cookbook/" />
</xsl:variable>

<xsl:template name="stylesheet">
    <xsl:param name="name"/>
    <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
            <xsl:value-of select="concat($css-dir, $name, '.css')"/>
        </xsl:attribute>
    </link>
</xsl:template>

<xsl:template name="favicon">
    <xsl:param name="name"/>
    <link rel="shortcut icon" type="image/x-icon">
        <xsl:attribute name="href">
            <xsl:value-of select="concat($images-dir, $name, '.png')"/>
        </xsl:attribute>
    </link>
</xsl:template>

<xsl:template name="script">
    <xsl:param name="name"/>
    <script type="text/javascript">
        <xsl:attribute name="src">
            <xsl:value-of select="concat($js-dir, $name, '.js')"/>
        </xsl:attribute>
    </script>
</xsl:template>

</xsl:stylesheet>