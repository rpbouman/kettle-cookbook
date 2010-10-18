<?xml version="1.0"?>
<!--

    This is xaction-report.xslt. This is part of kettle-cookbook.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    xaction-report.xslt - an XSLT transformation that generates HTML documentation
    from a Pentaho action sequence (xaction) file.
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

<xsl:variable name="item-type">action sequence</xsl:variable>
<xsl:variable name="steps-or-job-entries">actions</xsl:variable>
<xsl:variable name="step-or-job-entry">action</xsl:variable>

<xsl:template match="/">
<html>    
    <head>
    
        <xsl:copy-of select="$meta"/>
        <xsl:call-template name="favicon">
            <xsl:with-param name="name" select="'swirl-sm'"/>
        </xsl:call-template>

        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'default'"/>
        </xsl:call-template>
        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'xaction'"/>
        </xsl:call-template>
        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'shCoreDefault'"/>
        </xsl:call-template>
        
    </head>
    <body>
        <xsl:for-each select="$document">
            <xsl:apply-templates select="action-sequence"/>
        </xsl:for-each>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shCore'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushBash'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushJava'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushJScript'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushSql'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushMdx'"/>
        </xsl:call-template>
        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'shBrushXml'"/>
        </xsl:call-template>
        <script type="text/javascript">
            SyntaxHighlighter.all();
        </script>
    </body>
</html>
</xsl:template>

<xsl:template match="action-sequence">
    <xsl:apply-templates select="inputs"/>
    <xsl:apply-templates select="outputs"/>
    <xsl:apply-templates select="resources"/>
    <xsl:apply-templates select="actions"/>
</xsl:template>

<xsl:template name="param-table">
    <xsl:variable name="prefix" select="local-name()"/>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Default value</th>
            </tr>
        </thead>
        <tbody>
            <xsl:for-each select="*">
                <xsl:variable name="name" select="local-name()"/>
                <tr>
                    <th>
                        <a>
                            <xsl:attribute name="name"><xsl:value-of select="concat($prefix, '-', $name)"/></xsl:attribute>
                        </a>
                        <code><xsl:value-of select="local-name()"/></code>
                    </th>
                    <td>
                        <code><xsl:value-of select="@type"/></code>
                    </td>
                    <td>
                        <code><xsl:value-of select="default-value/text()"/></code>
                    </td>
                </tr>
            </xsl:for-each>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="action-sequence/actions">
    <h2>Actions</h2>
    <xsl:choose>
        <xsl:when test="action-definition">
            <p>This action sequence defines the following actions:</p>
            <xsl:apply-templates select="//action-definition"/>
        </xsl:when>
        <xsl:otherwise>
            <p>This action sequence does not define any inputs.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="action-definition">
    <xsl:variable name="name" select="action-type/text()"/>
    <a>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
    </a>
    <h3><xsl:value-of select="$name"/></h3>
    <p>This is an action of the type <xsl:value-of select="component-name"/>.</p>
    <xsl:call-template name="action-inputs"/>
    <xsl:call-template name="action-outputs"/>
    <xsl:apply-templates select="component-definition"/>
</xsl:template>

<xsl:template name="action-inputs">
    <xsl:variable name="action-inputs" select="action-inputs/*"/>
    <h4>Action Inputs</h4>    
    <xsl:choose>
        <xsl:when test="$action-inputs">
            <p>This action defines the following inputs:
                <xsl:apply-templates select="action-inputs"/>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <p>This action does not define any inputs.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="action-inputs">
    <xsl:call-template name="action-params"/>
</xsl:template>

<xsl:template name="action-outputs">
    <xsl:variable name="action-outputs" select="action-outputs/*"/>
    <h4>Action Outputs</h4>    
    <xsl:choose>
        <xsl:when test="$action-outputs">
            <p>This action defines the following outputs:
                <xsl:apply-templates select="action-outputs"/>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <p>This action does not define any outputs.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="action-outputs">
    <xsl:call-template name="action-params"/>
</xsl:template>

<xsl:template name="action-params">
    <xsl:for-each select="*">
        <xsl:sort select="local-name()"/>
        <xsl:variable name="name" select="local-name()"/>
        <xsl:if test="position()!=1">, </xsl:if>
            <a>
            <xsl:attribute name="href"><xsl:value-of select="concat('#', substring-after(local-name(..), 'action-'), '-', $name)"/></xsl:attribute>
            <code><xsl:value-of select="$name"/></code>
            </a>       
    </xsl:for-each>
</xsl:template>


<xsl:template name="component-definition">
</xsl:template>

<xsl:template match="component-definition[../component-name/text()='SQLLookupRule']">
    <h4>SQL</h4>
	<pre class="brush: sql;"><xsl:value-of select="query/text()"/></pre>    
</xsl:template>

<xsl:template match="component-definition[../component-name/text()='JavascriptRule']">
    <h4>JavaScript</h4>
	<pre class="brush: js;"><xsl:value-of select="script/text()"/></pre>    
</xsl:template>

<xsl:template match="action-sequence/inputs">
    <h2>Inputs</h2>
    <xsl:choose>
        <xsl:when test="*">
            <xsl:call-template name="param-table"/>
        </xsl:when>
        <xsl:otherwise>
            <p>This action sequence does not define any inputs.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="action-sequence/outputs">
    <h2>Outputs</h2>
    <xsl:choose>
        <xsl:when test="*">
            <xsl:call-template name="param-table"/>
        </xsl:when>
        <xsl:otherwise>
            <p>This action sequence does not define any outputs.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="action-sequence/resources">
    <h2>Resources</h2>
    <xsl:choose>
        <xsl:when test="*">
            <xsl:call-template name="param-table"/>
        </xsl:when>
        <xsl:otherwise>
            <p>This action sequence does not define any resources.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>