<?xml version="1.0"?>
<!--

This is kettle-trans-report.xslt. This is part of kettle-cookbook.
Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

kettle-trans-report.xslt - an XSLT transformation that generates HTML 
documentation from a Kettle (aka Pentaho Data Integration) transformation file.

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
/>

<xsl:template match="/">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Kettle Documentation: Main</title>
        <link rel="stylesheet" type="text/css" href="css/kettle.css"/>
        <link rel="shortcut icon" type="image/x-icon" href="images/spoon.png" />        
    </head>
    <body class="kettle-main">
        <xsl:apply-templates select="index"/>
    </body>
</html>
</xsl:template>

<xsl:template match="/index">
    <h1>Documentation for <xsl:value-of select="@input_dir"/></h1>
    <p>
        This documentation was generated <xsl:value-of select="@generated"/>.
    </p>
</xsl:template>


</xsl:stylesheet>