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

<xsl:variable name="actions" select="$document//action-definition"/>
<xsl:variable name="count-actions" select="count($actions)"/>

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

<xsl:template name="max-action-depth">
    <xsl:param name="max-depth" select="0"/>
    <xsl:param name="position" select="1"/>

    <xsl:variable name="depth">
        <xsl:for-each select="$actions[$position]">
            <xsl:value-of select="count(ancestor::*)-1"/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="$position &lt;= $count-actions">        
            <xsl:call-template name="max-action-depth">
                <xsl:with-param name="max-depth">
                    <xsl:choose>
                        <xsl:when test="$depth &gt; $max-depth"><xsl:value-of select="$depth"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$max-depth"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="position" select="$position + 1"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$max-depth"/>
        </xsl:otherwise>
    </xsl:choose>    
</xsl:template>
<xsl:variable name="max-action-depth"><xsl:call-template name="max-action-depth"/></xsl:variable>

<xsl:template match="action-sequence">
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="documentation"/>
    <xsl:call-template name="action-sequence-diagram"/>
    <xsl:apply-templates select="inputs"/>
    <xsl:apply-templates select="outputs"/>
    <xsl:apply-templates select="resources"/>
    <xsl:apply-templates select="actions"/>
</xsl:template>

<xsl:template match="action-sequence/title">
    <h1><xsl:call-template name="copy-contents"/></h1>
</xsl:template>

<xsl:template match="action-sequence/documentation">
    <xsl:call-template name="description"/>
</xsl:template>

<xsl:template name="padd-cells">
    <xsl:param name="elements"/>
    <xsl:param name="position"/>    
    <xsl:for-each select="$elements[position() &lt; $position]">
        <td class="xaction-diagram-padding">&#160;</td>
    </xsl:for-each>
</xsl:template>

<xsl:template name="action-sequence-diagram">
    <xsl:param name="action-sequence" select="."/>
    
    <xsl:variable name="resources" select="$action-sequence/resources/*"/>
    <xsl:variable name="inputs" select="$action-sequence/inputs/*"/>
    <xsl:variable name="outputs" select="$action-sequence/outputs/*"/>
    <xsl:variable name="actions" select="$action-sequence/actions//action-definition"/>

    <xsl:variable name="count-resources" select="count($resources)"/>
    <xsl:variable name="count-inputs" select="count($inputs)"/>
    <xsl:variable name="count-outputs" select="count($outputs)"/>
    
    <xsl:variable name="resources-and-inputs" select="$inputs | $resources"/>
    <xsl:variable name="count-resources-and-inputs" select="count($resources-and-inputs)"/>
    
    <h2>Action Sequence Diagram</h2>
    <table class="xaction-diagram" cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <xsl:if test="$resources-and-inputs">
                    <th class="xaction">
                        <xsl:attribute name="colspan"><xsl:value-of select="1 + $count-resources-and-inputs"/></xsl:attribute>
                        Inputs &amp; Resources
                    </th>
                </xsl:if>
                <th class="xaction">
                    <xsl:attribute name="colspan"><xsl:value-of select="$max-action-depth"/></xsl:attribute>
                    Actions
                </th>
                <xsl:if test="$outputs">
                    <th class="xaction">
                        <xsl:attribute name="rowspan"><xsl:value-of select="1 + $count-resources-and-inputs"/></xsl:attribute>
                        <xsl:attribute name="colspan"><xsl:value-of select="$count-outputs"/></xsl:attribute>
                        Outputs
                    </th>
                </xsl:if>
            </tr>
            <xsl:for-each select="$resources-and-inputs">
                <xsl:variable name="position" select="position()"/>
                <tr>
                    <th class="xaction-param">
                        <xsl:attribute name="colspan"><xsl:value-of select="2 + $count-resources-and-inputs - $position"/></xsl:attribute>
                        <xsl:value-of select="local-name()"/>
                        &#160;&#160;
                    </th>
                    <xsl:call-template name="padd-cells">
                        <xsl:with-param name="elements" select="$resources-and-inputs"/>
                        <xsl:with-param name="position" select="position()"/>
                    </xsl:call-template>
                    <xsl:if test="position()=1">
                        <td>
                            <xsl:attribute name="rowspan"><xsl:value-of select="$count-resources-and-inputs"/></xsl:attribute>
                            <xsl:attribute name="colspan"><xsl:value-of select="$count-outputs"/></xsl:attribute>
                        </td>
                    </xsl:if>
                </tr>
            </xsl:for-each>
        </thead>
        <tbody>
            <xsl:for-each select="$actions">
                <xsl:variable name="local-name" select="local-name(.)"/>
                <xsl:variable name="depth" select="count(ancestor::*) - 1"/>
                <xsl:variable name="preceding-siblings" select="count(preceding-sibling::*)"/>
                <tr>
                    <xsl:if test="position()=1">
                        <td class="xaction-param">
                            <xsl:attribute name="rowspan"><xsl:value-of select="count($actions)"/></xsl:attribute>
                        </td>
                    </xsl:if>
                    <xsl:call-template name="padd-cells">
                        <xsl:with-param name="elements" select="$resources-and-inputs"/>
                        <xsl:with-param name="position" select="1 + $count-resources-and-inputs"/>
                    </xsl:call-template>
                    <xsl:if test="$depth &gt; 1">
                        <xsl:if test="$depth &gt; 2">
                            <td>
                               <xsl:attribute name="colspan"><xsl:value-of select="$depth - 2"/></xsl:attribute>
                            </td>
                        </xsl:if>
                        <td>
                            <xsl:choose>
                                <xsl:when test="../condition and $preceding-siblings = 1">
                                    <div class="xaction-stick"></div>
                                    <div class="xaction-if">
                                        <code><xsl:value-of select="../condition"/></code>
                                    </div>
                                </xsl:when>
                                <xsl:when test="../@loop-on">
                                    <div class="xaction-stick"></div>
                                    <div class="xaction-loop">
                                        <code>foreach <xsl:value-of select="../@loop-on"/></code>
                                    </div>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </xsl:if>
                    <td>
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::action-definition">
                                <div class="xaction-stick"></div>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                        <div class="xaction-action">
                            <div class="xaction-action-type">
                                <xsl:value-of select="component-name/text()"/>
                            </div>
                            <div class="xaction-action-name">
                                <xsl:value-of select="action-type/text()"/>
                            </div>
                        </div>
                    </td>
                </tr>
            </xsl:for-each>
        </tbody>
    </table>
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


<xsl:template match="component-definition">
    <h4>Configuration</h4>
    <pre class="brush: xml;"><xsl:call-template name="copy-contents"/></pre>
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