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

<xsl:variable name="quick-links">
    <div class="quicklinks">
        <a href="#diagram">Diagram</a>
    |   <a>
			<xsl:attribute name="href">#actions</xsl:attribute>
			Actions
		</a>
    |   <a href="#inputs">Inputs</a>
    |   <a href="#outputs">Outputs</a>
    |   <a href="#resources">Resources</a>
    </div>
</xsl:variable>

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
        <xsl:copy-of select="$quick-links"/>
    
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
    <h2><a name="#Parameters">Parameters</a></h2>
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

<xsl:variable name="variable-separator" select="'&lt;'"/>

<xsl:template name="get-unique-variables">
    <xsl:param name="variables"/>
    <xsl:param name="unique-variables" select="$variable-separator"/>
    
    <xsl:choose>
        <xsl:when test="$variables = $variable-separator">
            <xsl:value-of select="$unique-variables"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="variable" select="substring-before(substring-after($variables, $variable-separator), $variable-separator)"/>
            <xsl:variable name="delimited-variable" select="concat($variable-separator, $variable, $variable-separator)"/>
            <xsl:variable name="new-variables" select="concat($variable-separator, substring-after($variables, $delimited-variable))"/>
            <xsl:variable name="variable-exists" select="contains($unique-variables, $delimited-variable)"/>
            <xsl:variable name="append-unique-variable" select="concat($unique-variables, substring-after($delimited-variable, $variable-separator))"/>
            <xsl:variable name="new-unique-variables">
                <xsl:choose>
                    <xsl:when test="$variable-exists"><xsl:value-of select="$unique-variables"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$append-unique-variable"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="get-unique-variables">   
                <xsl:with-param name="variables" select="$new-variables"/>
                <xsl:with-param name="unique-variables" select="$new-unique-variables"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="local-variables">
    <xsl:param name="variables"/>
    <xsl:param name="inputs"/>
    <xsl:param name="outputs"/>
    <xsl:param name="resources"/>
    <xsl:for-each select="$variables">  
        <xsl:choose>
            <xsl:when test="@mapping">
                <xsl:variable name="variable" select="@mapping"/>
                <xsl:if 
                    test="
                        count($inputs[local-name() = $variable]) = 0
                    and count($outputs[local-name() = $variable]) = 0
                    and count($resources[local-name() = $variable]) = 0
                    "
                >
                    <xsl:value-of select="concat($variable-separator, $variable)"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="variable" select="local-name()"/>
                <xsl:if 
                    test="
                        count($inputs[local-name() = $variable]) = 0
                    and count($outputs[local-name() = $variable]) = 0
                    and count($resources[local-name() = $variable]) = 0
                    "
                >
                    <xsl:value-of select="concat($variable-separator, $variable)"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>

<xsl:template name="unique-variables">
    <xsl:param name="variables"/>
    <xsl:param name="unique-variables" select="$variable-separator"/>

    <xsl:choose>
        <xsl:when test="$variables=$variable-separator"><xsl:value-of select="$unique-variables"/></xsl:when>
        <xsl:otherwise>
            <xsl:variable name="variable" select="substring-before(substring-after($variables, $variable-separator), $variable-separator)"/>
            <xsl:variable name="delimited-variable" select="concat($variable-separator, $variable, $variable-separator)"/>
            <xsl:call-template name="unique-variables">
                <xsl:with-param name="variables" select="concat($variable-separator, substring-after($variables, $delimited-variable))"/>
                <xsl:with-param name="unique-variables">
                    <xsl:choose>
                        <xsl:when test="contains($unique-variables, $delimited-variable)">
                            <xsl:value-of select="$unique-variables"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($unique-variables, $variable, $variable-separator)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="for-each-variable">
    <xsl:param name="variables"/>
    <xsl:param name="template" select="''"/>
    <xsl:if test="$variables != $variable-separator">
        <xsl:variable name="variable" select="substring-before(substring-after($variables, $variable-separator), $variable-separator)"/>
        <xsl:variable name="delimited-variable" select="concat($variable-separator, $variable, $variable-separator)"/>
        <xsl:variable name="new-variables" select="concat($variable-separator, substring-after($variables, $delimited-variable))"/>
        <xsl:copy-of select="$template"/>
        <xsl:call-template name="for-each-variable">
            <xsl:with-param name="variables" select="$new-variables"/>
            <xsl:with-param name="template" select="$template"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="variable-assignments">
    <xsl:param name="variables"/>
    <xsl:param name="action-parameter"/>
    <xsl:param name="prior-assignment" select="false()"/>
    <xsl:param name="direction"/>
    <xsl:param name="parameters-before"/>
    <xsl:param name="parameters-after"/>
    
    <xsl:if test="$variables != $variable-separator">
        <xsl:variable name="variable" select="substring-before(substring-after($variables, $variable-separator), $variable-separator)"/>
        <xsl:variable name="is-assigned" select="$variable = $action-parameter"/> 
        <xsl:variable name="delimited-variable" select="concat($variable-separator, $variable, $variable-separator)"/>
        <xsl:variable name="new-variables" select="concat($variable-separator, substring-after($variables, $delimited-variable))"/>
        
        <td>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$is-assigned">
                        <xsl:value-of select="$direction"/>
                    </xsl:when>                                                
                    <xsl:when test="$prior-assignment">
                        xaction-diagram-prior-assignment
                    </xsl:when>
<!--                    
                    <xsl:when 
                        test="
                            ($parameters-after[@mapping = $variable]
                        or  $parameters-after[local-name() = $variable])
                        "
                    >
                        xaction-diagram-padding
                    </xsl:when>
-->                    
                    <xsl:otherwise>
                        xaction-diagram-blank
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            &#160;
        </td>
        
        <xsl:call-template name="variable-assignments">
            <xsl:with-param name="variables" select="$new-variables"/>
            <xsl:with-param name="action-parameter" select="$action-parameter"/>
            <xsl:with-param name="prior-assignment" select="$prior-assignment or $is-assigned"/>
            <xsl:with-param name="direction" select="$direction"/>
            <xsl:with-param name="parameters-before" select="$parameters-before"/>
            <xsl:with-param name="parameters-after" select="$parameters-after"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="num-variables">
    <xsl:param name="variables"/>
    <xsl:variable name="variable-after-separator" select="substring-after($variables, $variable-separator)"/>
    <xsl:variable name="removed-variable-separator">
        <xsl:call-template name="replace">    
            <xsl:with-param name="text" select="$variable-after-separator"/>
            <xsl:with-param name="search" select="$variable-separator"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="string-length($variable-after-separator) - string-length($removed-variable-separator)"/>
</xsl:template>

<xsl:template name="action-sequence-diagram">
    <xsl:param name="action-sequence" select="."/>
    
    <xsl:variable name="resources" select="$action-sequence/resources/*"/>
    <xsl:variable name="inputs" select="$action-sequence/inputs/*"/>
    <xsl:variable name="outputs" select="$action-sequence/outputs/*"/>
    <xsl:variable name="actions" select="$action-sequence/actions//*[local-name()='action-definition' or local-name()='actions']"/>

    <xsl:variable name="count-resources" select="count($resources)"/>
    <xsl:variable name="count-inputs" select="count($inputs)"/>
    <xsl:variable name="count-outputs" select="count($outputs)"/>
    
    <xsl:variable name="variables" select="$actions/action-inputs/* | $actions/action-outputs/*"/>
    <xsl:variable name="local-variables">
        <xsl:call-template name="local-variables">
            <xsl:with-param name="variables" select="$variables"/>
            <xsl:with-param name="inputs" select="$inputs"/>
            <xsl:with-param name="outputs" select="$outputs"/>
            <xsl:with-param name="resources" select="$resources"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="unique-variables">
        <xsl:call-template name="unique-variables">
            <xsl:with-param name="variables" select="concat($local-variables, $variable-separator)"/> 
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="num-unique-variables">
        <xsl:call-template name="num-variables">
            <xsl:with-param name="variables" select="$unique-variables"/>
        </xsl:call-template>
    </xsl:variable>

    <h2><a name="diagram">Action Sequence Diagram</a></h2>
    <table class="xaction-diagram" cellpadding="0" cellspacing="0">
        <thead>
            <tr>

                <xsl:if test="$count-inputs &gt; 0">
                    <th class="xaction">
                        <xsl:attribute name="colspan"><xsl:value-of select="2+ $count-inputs"/></xsl:attribute>
                        Inputs
                    </th>
                </xsl:if>

                <xsl:if test="$count-resources &gt; 0">
                    <th class="xaction">
                        <xsl:attribute name="colspan"><xsl:value-of select="2+ $count-resources"/></xsl:attribute>
                        Resources
                    </th>
                </xsl:if>
                
                <xsl:if test="$count-outputs &gt; 0">
                    <th class="xaction">
                        <xsl:attribute name="colspan"><xsl:value-of select="2 + $count-outputs"/></xsl:attribute>
                        Outputs
                    </th>
                </xsl:if>

                    <th class="xaction">
                        <xsl:attribute name="colspan"><xsl:value-of select="2 + $num-unique-variables"/></xsl:attribute>
                        Variables
                    </th>

                <th class="xaction">
                    <xsl:attribute name="colspan"><xsl:value-of select="$max-action-depth"/></xsl:attribute>
                    Actions
                </th>

            </tr>
        </thead>
        <tbody>
            <xsl:for-each select="$actions">
                <xsl:variable name="action-position" select="position()"/>
                <xsl:variable name="action" select="."/>
                <xsl:variable name="local-name" select="local-name($action)"/>
                <xsl:variable name="depth" select="count(ancestor::*) - 1"/>
                <xsl:variable name="action-inputs" select="action-inputs/*"/>
                <xsl:variable name="action-outputs" select="action-outputs/*"/>
                <xsl:variable name="rowspan" select="count($action-inputs) + count($action-outputs) + 3"/>

                <xsl:variable name="actions-after" select="$actions[position() &gt; $action-position]"/>
                <xsl:variable name="action-after-inputs" select="$actions-after/action-inputs/*"/>
                <xsl:variable name="action-after-outputs" select="$actions-after/action-outputs/*"/>

                <xsl:variable name="this-and-after-action-inputs" select="$action-after-inputs | $action-inputs"/>
                <xsl:variable name="this-and-after-action-outputs" select="$action-after-outputs | $action-outputs"/>

                <xsl:variable name="parameters-after" select="$action-after-inputs | $action-inputs | $action-after-outputs | $action-outputs"/>

                <!--
                
                    Row 1 of action:    * add the action 
                                        * add padding for resources, inputs, outputs and variables                    
                
                -->
                <tr class="action-row">
                    <xsl:if test="$inputs">
                        <td class="xaction-diagram-blank">&#160;</td>
                        <xsl:for-each select="$inputs">
                            <xsl:variable name="input-name" select="local-name()"/>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when 
                                            test="
                                                $this-and-after-action-inputs[@mapping = $input-name]
                                            or  $this-and-after-action-inputs[local-name() = $input-name]
                                            "
                                        >
                                            xaction-diagram-padding
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank">&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$resources">
                        <td class="xaction-diagram-blank">&#160;</td>
                        <xsl:for-each select="$resources">
                            <td class="xaction-diagram-padding">
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank">&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$outputs">
                        <td class="xaction-diagram-blank">&#160;</td>
                        <xsl:for-each select="$outputs">
                            <td class="xaction-diagram-padding">
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank">&#160;</td>
                    </xsl:if>

                    <xsl:if test="number($num-unique-variables) &gt; 0">
                        <td class="xaction-diagram-blank">&#160;</td>
                        <xsl:call-template name="for-each-variable">
                            <xsl:with-param name="variables" select="$unique-variables"/>
                            <xsl:with-param name="template">
                                <td class="xaction-diagram-padding">
                                    &#160;
                                </td>
                            </xsl:with-param>
                        </xsl:call-template>
                        <td class="xaction-diagram-blank">&#160;</td>
                    </xsl:if>
                        
                    <!--
                    
                        Indent for contents of loops or ifs
                    
                    -->
                    <xsl:if test="$depth &gt; 1">
                        <xsl:if test="$depth &gt; 2">
                            <td>
                               <xsl:attribute name="colspan"><xsl:value-of select="$depth - 2"/></xsl:attribute>
                               <xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
                            </td>
                        </xsl:if>
                        <td>
                            <xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
                        </td>
                    </xsl:if>

                    <td>
                        <xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
                        <div class="xaction-stick"></div>
                        <xsl:choose>
                            <xsl:when test="local-name() = 'action-definition'">
                                <div class="xaction-action">
                                    <div class="xaction-action-type">
                                        <xsl:value-of select="component-name/text()"/>
                                    </div>
                                    <div class="xaction-action-name">
                                        <xsl:call-template name="action-label"/>
                                    </div>
                                </div>
                            </xsl:when>
                            <xsl:when test="local-name() = 'actions'">
                                <xsl:choose>
                                    <xsl:when test="@loop-on">
                                        <div class="xaction-loop">
                                            <div class="xaction-action-type">
                                                loop
                                            </div>
                                            <div class="xaction-action-name">
                                                <xsl:value-of select="@loop-on"/>
                                            </div>
                                        </div>
                                    </xsl:when>
                                    <xsl:when test="condition">
                                        <div class="xaction-if">
                                            <div class="xaction-action-type">
                                                if
                                            </div>
                                            <div class="xaction-action-name">
                                                <xsl:value-of select="condition/text()"/>
                                            </div>
                                        </div>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                        <div class="xaction-stick"></div>
                    </td>
                </tr>
                
                <!--
                
                    Rows for action inputs
                
                -->
                <xsl:for-each select="$action-inputs">
                    <xsl:variable name="action-input-position" select="position()"/>
                    <xsl:variable name="local-following-action-inputs" select="$action-inputs[position() &gt; $action-input-position]"/>
                    <xsl:variable name="input-param">
                        <xsl:choose>
                            <xsl:when test="@mapping"><xsl:value-of select="@mapping"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable> 
                    <xsl:variable name="delimited-input-param" select="concat($variable-separator, $input-param, $variable-separator)"/>
                    <tr class="input-row">
                        <xsl:if test="$inputs">
                            <td class="xaction-diagram-blank">&#160;</td>
                            <xsl:for-each select="$inputs">
                                <xsl:variable name="input-name" select="local-name()"/>
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$input-param = local-name()">
                                                xaction-diagram-input
                                            </xsl:when>
                                            <xsl:when test="preceding-sibling::*[local-name() = $input-param]">
                                                xaction-diagram-prior-assignment
                                            </xsl:when>
                                            <xsl:when 
                                                test="
                                                    $action-after-inputs[@mapping = $input-name]
                                                or  $action-after-inputs[local-name() = $input-name]
                                                or  $local-following-action-inputs[local-name() = $input-name]
                                                "
                                            >
                                                xaction-diagram-padding
                                            </xsl:when>
                                            <xsl:otherwise>
                                                xaction-diagram-blank
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:if>
                        
                        <xsl:if test="$resources">
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                            <xsl:for-each select="$resources">
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$input-param = local-name()">
                                                xaction-diagram-input
                                            </xsl:when>                                                
                                            <xsl:when test="$inputs[local-name() = $input-param]">
                                                xaction-diagram-prior-assignment
                                            </xsl:when>
                                            <xsl:otherwise>
                                                xaction-diagram-padding
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:if>
                        
                        <xsl:if test="$outputs">
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                            <xsl:for-each select="$outputs">
                                <td >
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$input-param = local-name()">
                                                xaction-diagram-input
                                            </xsl:when>                                                
                                            <xsl:when test="$inputs[local-name() = $input-param]">
                                                xaction-diagram-prior-assignment
                                            </xsl:when>
                                            <xsl:otherwise>
                                                xaction-diagram-padding
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:if>

                        <xsl:if test="number($num-unique-variables) &gt; 0">
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when test="$inputs[local-name() = $input-param]">
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                                <xsl:value-of select="count($parameters-after)"/>
                            </td>

                            <xsl:call-template name="variable-assignments">
                                <xsl:with-param name="variables" select="$unique-variables"/>
                                <xsl:with-param name="action-parameter" select="$input-param"/>
                                <xsl:with-param name="prior-assignment" select="$inputs[local-name() = $input-param]"/>
                                <xsl:with-param name="direction" select="'xaction-diagram-input'"/>
                                <xsl:with-param name="parameters-before"/>
                                <xsl:with-param name="parameters-after" select="$parameters-after"/>
                            </xsl:call-template>

                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when 
                                            test="
                                                $inputs[local-name() = $input-param] 
                                            or  contains($unique-variables, $delimited-input-param)
                                            "
                                        >
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:if>
                    </tr>
                </xsl:for-each>
                
                <!--
                
                    Row separating action inputs from action outputs
                
                -->
                <tr class="middle-separator-row">
                    <xsl:if test="$inputs">
                        <td class="xaction-diagram-blank">
                            &#160;
                        </td>
                        <xsl:for-each select="$inputs">
                            <xsl:variable name="input-name" select="local-name()"/>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when 
                                            test="
                                                $action-after-inputs[@mapping = $input-name]
                                            or  $action-after-inputs[local-name() = $input-name]
                                            "
                                        >
                                            xaction-diagram-padding
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank">&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$resources">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:for-each select="$resources">
                            <td class="xaction-diagram-padding" >
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$outputs">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:for-each select="$outputs">
                            <td class="xaction-diagram-padding" >
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>

                    <xsl:if test="number($num-unique-variables) &gt; 0">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:call-template name="for-each-variable">
                            <xsl:with-param name="variables" select="$unique-variables"/>
                            <xsl:with-param name="template">
                                <td class="xaction-diagram-padding" >
                                    &#160;
                                </td>
                            </xsl:with-param>
                        </xsl:call-template>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>
                </tr>

                <!--
                
                    Rows for action outputs
                
                -->
                <xsl:for-each select="$action-outputs">
                    <xsl:variable name="output-param">
                        <xsl:choose>
                            <xsl:when test="@mapping"><xsl:value-of select="@mapping"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable> 
                    <xsl:variable name="delimited-output-param" select="concat($variable-separator, $output-param, $variable-separator)"/>
                    <tr class="output-row">
                        <xsl:if test="$inputs">
                            <td class="xaction-diagram-blank">&#160;</td>
                            <xsl:for-each select="$inputs">
                                <xsl:variable name="input-name" select="local-name()"/>
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when 
                                                test="
                                                    $action-after-inputs[@mapping = $input-name]
                                                or  $action-after-inputs[local-name() = $input-name]
                                                "
                                            >
                                                xaction-diagram-padding
                                            </xsl:when>
                                            <xsl:otherwise>
                                                xaction-diagram-blank
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td class="xaction-diagram-blank">&#160;</td>
                        </xsl:if>
                        
                        <xsl:if test="$resources">
                            <td class="xaction-diagram-blank">&#160;</td>
                            <xsl:for-each select="$resources">
                                <td class="xaction-diagram-padding">
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td class="xaction-diagram-blank">&#160;</td>
                        </xsl:if>
                        
                        <xsl:if test="$outputs">
                            <td class="xaction-diagram-blank">&#160;</td>
                            <xsl:for-each select="$outputs">
                                <td>
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$output-param = local-name()">
                                                xaction-diagram-output
                                            </xsl:when>
                                            <xsl:when test="preceding-sibling::*[local-name() = $output-param]">
                                                xaction-diagram-prior-assignment
                                            </xsl:when>
                                            <xsl:otherwise>
                                                xaction-diagram-padding
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    &#160;
                                </td>
                            </xsl:for-each>
                            <td class="xaction-diagram-blank">&#160;</td>
                        </xsl:if>

                        <xsl:if test="number($num-unique-variables) &gt; 0">
                            <td class="xaction-diagram-blank">&#160;</td>
                            <xsl:call-template name="variable-assignments">
                                <xsl:with-param name="variables" select="$unique-variables"/>
                                <xsl:with-param name="action-parameter" select="$output-param"/>
                                <xsl:with-param name="prior-assignment" select="$inputs[local-name() = $output-param]"/>
                                <xsl:with-param name="direction" select="'xaction-diagram-output'"/>
                            </xsl:call-template>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when 
                                            test="
                                                $outputs[local-name() = $output-param] 
                                            or  contains($unique-variables, $delimited-output-param)
                                            "
                                        >
                                            xaction-diagram-prior-assignment
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:if>
                    </tr>
                </xsl:for-each>

                <!--
                    Final spacer row.
                -->
                <tr class="final-row">
                    <xsl:if test="$inputs">
                        <td class="xaction-diagram-blank">
                            &#160;
                        </td>
                        <xsl:for-each select="$inputs">
                            <xsl:variable name="input-name" select="local-name()"/>
                            <td>
                                <xsl:attribute name="class">
                                    <xsl:choose>
                                        <xsl:when 
                                            test="
                                                $action-after-inputs[@mapping = $input-name]
                                            or  $action-after-inputs[local-name() = $input-name]
                                            "
                                        >
                                            xaction-diagram-padding
                                        </xsl:when>
                                        <xsl:otherwise>
                                            xaction-diagram-blank
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$resources">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:for-each select="$resources">
                            <td class="xaction-diagram-padding" >
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>
                    
                    <xsl:if test="$outputs">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:for-each select="$outputs">
                            <td class="xaction-diagram-padding" >
                                &#160;
                            </td>
                        </xsl:for-each>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>

                    <xsl:if test="number($num-unique-variables) &gt; 0">
                        <td class="xaction-diagram-blank" >&#160;</td>
                        <xsl:call-template name="for-each-variable">
                            <xsl:with-param name="variables" select="$unique-variables"/>
                            <xsl:with-param name="template">
                                <td class="xaction-diagram-padding" >
                                    &#160;
                                </td>
                            </xsl:with-param>
                        </xsl:call-template>
                        <td class="xaction-diagram-blank" >&#160;</td>
                    </xsl:if>
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
    <h2><a name="actions">Actions</a></h2>
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

<xsl:template name="action-label">
    <xsl:param name="action-definition" select="."/>    
    <xsl:for-each select="$action-definition">
        <xsl:choose>
            <xsl:when test="action-type[text()]">
                <xsl:value-of select="action-type/text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="component-name/text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>

<xsl:template match="action-definition">
    <xsl:variable name="name">
        <xsl:call-template name="action-label"/>
    </xsl:variable>
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
    <h3><a name="inputs">Inputs</a></h3>
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
    <h3><a name="outputs">Outputs</a></h3>
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
    <h3><a name="resources">Resources</a></h3>
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