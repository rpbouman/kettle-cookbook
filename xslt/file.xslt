<?xml version="1.0"?>
<!--

    This is file.xslt. This is part of kettle-cookbook.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    file.xslt - an XSLT transformation to work with an individual file specified by
    the parameter param_filename

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
    XSLT PARAMETERS
========================================================================== -->
<xsl:param name="param_filename" select="''"/>

<!-- =========================================================================
    XSLT VARIABLES
========================================================================== -->
<xsl:variable name="normalized_filename" select="normalize-space($param_filename)"/>
<xsl:variable name="file-separator" select="/index/@file_separator"/>

<xsl:variable name="file" select="/index/file[filename/text() = $normalized_filename]"/>
<xsl:variable name="relative-path" select="substring-after($file/path/text(), $input-dir)"/>
<!--
    This opens the document that is the real subject of the transformation.
    By transforming index.xml, we have the opportunity to query other docs
    as well which may be useful for cross reference reports. 
    Currently, we are not actually using that, but this is why it was built 
    this way.
-->
<xsl:variable name="document" select="document($file/uri/text())"/>
<xsl:variable name="file-type" select="$file/extension/text()"/>

<!--
    This gets the relattive location of the root of the documentation.
    This is required to build paths to static resources like css and javascript files.
-->
<xsl:template name="get-documentation-root">
    <xsl:param name="path" select="$relative-path"/>
    <xsl:param name="documentation-root" select="'..'"/>
    <xsl:choose>
        <xsl:when test="contains($path, $file-separator)">
            <xsl:call-template name="get-documentation-root">
                <xsl:with-param name="path" select="substring-after($path, $file-separator)"/>
                <xsl:with-param name="documentation-root" select="concat($documentation-root, '/..')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$documentation-root"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
    Paths
-->
<xsl:variable name="documentation-root"><xsl:call-template name="get-documentation-root"/></xsl:variable>
<xsl:variable name="css-dir" select="concat($documentation-root, '/css/')"/>
<xsl:variable name="js-dir" select="concat($documentation-root, '/js/')"/>
<xsl:variable name="images-dir" select="concat($documentation-root, '/images/')"/>

</xsl:stylesheet>