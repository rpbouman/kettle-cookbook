<?xml version="1.0"?>
<!--

    This is kettle-report.xslt. This is part of kettle-cookbook.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    kettle-report.xslt - an XSLT transformation that generates HTML documentation
    from a Kettle (aka Pentaho Data Integration) transformation or job file.
    This is part of kettle-cookbook, a kettle documentation generation framework.

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
<xsl:param name="param_filename"/>

<!-- =========================================================================
    XSLT VARIABLES
========================================================================== -->
<xsl:variable name="normalized_filename" select="normalize-space($param_filename)"/>
<xsl:variable name="file-separator" select="/index/@file_separator"/>
<xsl:variable name="input-dir" select="/index/@input_dir"/>
<xsl:variable name="output-dir" select="/index/@output_dir"/>

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

<xsl:variable name="item-type">
	<xsl:choose>
		<xsl:when test="$file-type = 'kjb'">job</xsl:when>
		<xsl:when test="$file-type = 'ktr'">transformation</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="steps-or-job-entries">
	<xsl:choose>
		<xsl:when test="$file-type = 'kjb'">Job Entries</xsl:when>
		<xsl:when test="$file-type = 'ktr'">Steps</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="step-or-job-entry">
	<xsl:choose>
		<xsl:when test="$file-type = 'ktr'">job entry</xsl:when>
		<xsl:when test="$file-type = 'ktr'">step</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

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

<xsl:variable name="documentation-root"><xsl:call-template name="get-documentation-root"/></xsl:variable>

<xsl:variable name="quick-links">
    <div class="quicklinks">
        <a href="#diagram">Diagram</a>
    |   <a>
			<xsl:attribute name="href">#<xsl:value-of select="$steps-or-job-entries"/></xsl:attribute>
			<xsl:value-of select="$steps-or-job-entries"/>
		</a>
    |   <a href="#parameters">Parameters</a>
    |   <a href="#variables">Variables</a>
    |   <a href="#connections">Database Connections</a>
    |   <a href="#files">Flat Files</a>
    </div>
</xsl:variable>
<!-- =========================================================================
    KETTLE GENERIC
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

<xsl:template match="/">
<html>    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="Generator" content="kettle-cookbook - see http://code.google.com/p/kettle-cookbook/" />
        <xsl:comment>
            Debugging info - please ignore
            param_filename: "<xsl:value-of select="$param_filename"/>"
            normalized_filename: "<xsl:value-of select="$normalized_filename"/>"
            file: <xsl:value-of select="count($file)"/>
            document: <xsl:value-of select="count($document)"/>
            document-element: <xsl:value-of select="local-name($document/*)"/>
            name: <xsl:value-of select="$document/*/name/text()"/>
            relative-path: "<xsl:value-of select="$relative-path"/>"
            documentation-root: "<xsl:value-of select="$documentation-root"/>"
        </xsl:comment>
        <title>Kettle Documentation: <xsl:value-of select="$item-type"/> "<xsl:value-of select="$document/*/name"/>"</title>
        <link rel="shortcut icon" type="image/x-icon">
            <xsl:attribute name="href">
                <xsl:value-of 
                    select="
                        concat(
                            $documentation-root
                        ,   '/images/spoon.png'
                        )
                    "
                />
            </xsl:attribute>
        </link>
        <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
                <xsl:value-of 
                    select="
                        concat(
                            $documentation-root
                        ,   '/css/kettle.css'
                        )
                    "
                />
            </xsl:attribute>
        </link>
        <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
                <xsl:value-of 
                    select="
                        concat(
                            $documentation-root
                        ,   '/css/', local-name($document/*),'.css'
                        )
                    "
                />
            </xsl:attribute>
        </link>
        <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
                <xsl:value-of 
                    select="
                        concat(
                            $documentation-root
                        ,   '/css/shCoreDefault.css'
                        )
                    "
                />
            </xsl:attribute>
        </link>
    </head>
    <body class="kettle-file" onload="drawHops()">
        <xsl:copy-of select="$quick-links"/>
                
        <xsl:for-each select="$document">
            <xsl:apply-templates/>
        </xsl:for-each>
        
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/wz_jsgraphics.js')"/>
            </xsl:attribute>
        </script>
        <script>
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/kettle.js')"/>
            </xsl:attribute>
        </script>

        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shCore.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shBrushBash.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shBrushJava.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shBrushJScript.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shBrushSql.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($documentation-root, '/js/shBrushXml.js')"/>
            </xsl:attribute>
        </script>
        <script type="text/javascript">
            SyntaxHighlighter.all();
        </script>
    </body>
</html>
</xsl:template>

<xsl:template match="parameters">
    <h2><a name="parameters">Parameters</a></h2>    
    <xsl:choose>
        <xsl:when test="parameter">
            <p>
                This <xsl:value-of select="$item-type"/> defines <xsl:value-of select="count(parameter)"/> parameters.
            </p>
            <table>
                <thead>
                    <tr>
                        <th>
                            Name
                        </th>
                        <th>
                            Default Value
                        </th>
                        <th>
                            Description
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="parameter">
                        <tr>
                            <th>
                                <xsl:value-of select="name"/>
                            </th>
                            <td>
                                <xsl:value-of select="default_value"/>
                            </td>
                            <td>
                                <xsl:value-of select="description"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </xsl:when>
        <xsl:otherwise>
            <p>
                This <xsl:value-of select="$item-type"/> does not define any parameters.
            </p>
        </xsl:otherwise>
    </xsl:choose>
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
<!-- =========================================================================
    Utils
========================================================================== -->
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

<xsl:template name="replace-dir-variables-with-doc-dir">
	<xsl:param name="text"/>	
	<xsl:call-template name="replace">
		<xsl:with-param name="text"><xsl:call-template 
			name="replace-backslashes-with-slash"
		>
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template></xsl:with-param>
		<xsl:with-param name="search">${<xsl:choose>
			<xsl:when test="$item-type='job'">Internal.Job.Filename.Directory</xsl:when>
			<xsl:when test="$item-type='transformation'">Internal.Transformation.Filename.Directory</xsl:when>
		</xsl:choose>}/</xsl:with-param>
		<xsl:with-param name="replace" select="''"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="get-doc-uri-for-filename">
	<xsl:param name="step-or-job-entry"/>
	<xsl:variable name="type" select="local-name($step-or-job-entry)"/>
	<xsl:variable name="filename" select="concat($step-or-job-entry/filename/text(), '.html')"/>
	<xsl:call-template name="replace-dir-variables-with-doc-dir">
		<xsl:with-param name="text" select="$filename"/>
		<xsl:with-param name="var-ref">${<xsl:choose>
				<xsl:when test="$type='entry'">Internal.Job.Filename.Directory</xsl:when>
				<xsl:when test="$type='step'">Internal.Transformation.Filename.Directory</xsl:when>
			</xsl:choose>}</xsl:with-param>
	</xsl:call-template>	
</xsl:template>

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

<!-- =========================================================================
    Database connections
========================================================================== -->

<xsl:template name="database-connections">
    <h2><a name="connections">Database Connections</a></h2>    
    <xsl:choose>
        <xsl:when test="connection">
            <p>This <xsl:value-of select="$item-type"/> defines <xsl:value-of select="count(connection)"/> database connections.</p>
            <h3>Database Connection Summary</h3>
            <table>
                <thead>
					<tr>
						<th>
							Name
						</th>
						<th>
							Type
						</th>
						<th>
							Access
						</th>
						<th>
							Host
						</th>
						<th>
							Port
						</th>
						<th>
							User
						</th>
						<th>
							Used in <xsl:value-of select="$steps-or-job-entries"/>
						</th>
					</tr>
                </thead>
                <tbody>
                    <xsl:for-each select="/*/connection">
						<xsl:variable name="name" select="name/text()"/>
                        <tr>
                            <th>
                                <a>
                                    <xsl:attribute name="href">#connection.<xsl:value-of select="$name"/></xsl:attribute>
                                    <xsl:value-of select="$name"/>
                                </a>
                            </th>
                            <td>
                                <xsl:value-of select="type"/>
                            </td>
                            <td>
                                <xsl:value-of select="access"/>
                            </td>
                            <td>
                                <xsl:value-of select="server"/>
                            </td>
                            <td>
                                <xsl:value-of select="port"/>
                            </td>
                            <td>
                                <xsl:value-of select="username"/>
                            </td>
							<td>
								<xsl:choose>
									<xsl:when test="$item-type='transformation'">
										<xsl:for-each select="/*/step[connection/text()=$name]">
											<xsl:if test="position()&gt;1">, </xsl:if><a>
												<xsl:attribute name="href">#<xsl:value-of select="$name"/></xsl:attribute>
												<xsl:value-of select="name/text()"/>
											</a>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="$item-type='job'">
										<xsl:for-each select="/*/entries/entry[connection/text()=$name]">
											<xsl:if test="position()&gt;1">, </xsl:if><a>
												<xsl:attribute name="href">#<xsl:value-of select="$name"/></xsl:attribute>
												<xsl:value-of select="name/text()"/>
											</a>
										</xsl:for-each>
									</xsl:when>
								</xsl:choose>
							</td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
            <h3>Database Connection Details</h3>
            <xsl:apply-templates select="connection"/>
        </xsl:when>
        <xsl:otherwise>
			<p>This <xsl:value-of select="$item-type"/> does not define any database connections.</p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="/*/connection">
    <h4>
        <a>
            <xsl:attribute name="name">connection.<xsl:value-of select="name"/></xsl:attribute>
            <xsl:value-of select="name"/>
        </a>
    </h4>
    <table>
        <thead>
            <tr>
                <th>Property</th>
                <th>Value</th>
            </tr>
        </thead>
        <tbody>
            <xsl:apply-templates select="*"/>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="/*/connection/*[node()]">
    <xsl:variable name="tag" select="local-name()"/>
    <tr>
        <td><xsl:value-of select="$tag"/></td>
        <td>
            <xsl:choose>
                <xsl:when test="$tag = 'attributes'">
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>            
        </td>
    </tr>
</xsl:template>

<!-- =========================================================================
    VARIABLES
========================================================================== -->
<xsl:template name="get-variables">
    <xsl:param name="text"/>
    <xsl:param name="variables" select="''"/>
    <xsl:choose>
        <xsl:when test="contains($text, '${')">
            <xsl:variable name="after" select="substring-after($text, '${')"/>
            <xsl:variable name="var" select="substring-before($after, '}')"/>
            <xsl:variable name="vars">
                <xsl:choose>
                    <xsl:when test="contains(concat(',', $variables), concat(',', $var, ','))"><xsl:value-of select="$variables"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="concat($variables, $var, ',')"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="get-variables">
                <xsl:with-param name="text" select="substring-after($after, '}')"/>
                <xsl:with-param name="variables" select="$vars"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$variables"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="variable-list">
    <xsl:variable name="nodes-using-variables" select="$document//*[contains(text(), '${')]"/>
    <xsl:variable name="list">
        <xsl:for-each select="$nodes-using-variables">
            <xsl:call-template name="get-variables">
                <xsl:with-param name="text" select="text()"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:variable>    
    <xsl:value-of select="$list"/>
</xsl:template>

<xsl:template name="unique-variables">
    <xsl:param name="before" select="''"/>
    <xsl:param name="after">
        <xsl:call-template name="variables"/>
    </xsl:param>
    <xsl:variable name="var" select="substring-before($after, ',')"/>
    <xsl:if test="not(contains(concat(',', $before, ','), concat(',',$var,',')))">
        <tr>
            <th>
                <xsl:value-of select="$var"/>
            </th>
            <td>
            </td>
			<td>
				<xsl:for-each select="/*/connection//*[contains(text(),concat('${',$var,'}'))]">
					<xsl:if test="position()&gt;1">, </xsl:if>
					<xsl:value-of select="name"/>
				</xsl:for-each>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$item-type = 'job'">
						<xsl:for-each select="/*/entries/entry[.//*[contains(text(), concat('${', $var, '}'))]]">
							<xsl:if test="position()&gt;1">, </xsl:if>
							<a>
								<xsl:attribute name="href">#<xsl:value-of select="name"/></xsl:attribute>
								<xsl:value-of select="name"/>
							</a>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$item-type = 'transformation'">
						<xsl:for-each select="/*/step[.//*[contains(text(), concat('${', $var, '}'))]]">
							<xsl:if test="position()&gt;1">, </xsl:if>
							<a>
								<xsl:attribute name="href">#<xsl:value-of select="name"/></xsl:attribute>
								<xsl:value-of select="name"/>
							</a>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</td>
        </tr>
    </xsl:if>
    <xsl:if test="string-length($var)!=0">
        <xsl:call-template name="unique-variables">
            <xsl:with-param name="before" select="concat($before, ',', $var)"/>
            <xsl:with-param name="after" select="substring-after($after, ',')"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="variables">
    <xsl:variable name="variables-list">
        <xsl:call-template name="variable-list"/>
    </xsl:variable>
    <h2>
        <a name="variables">Variables</a>
    </h2>
    <xsl:choose>
        <xsl:when test="string-length($variables-list)=0">
            <p>This <xsl:value-of select="$item-type"/> does not read any variables.</p>
        </xsl:when>
        <xsl:otherwise>
            <p>This <xsl:value-of select="$item-type"/> reads the following variables:</p>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Value</th>
                        <th>Connections</th>
                        <th>
							<xsl:value-of select="$steps-or-job-entries"/>
						</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:call-template name="unique-variables">
                        <xsl:with-param name="after" select="$variables-list"/>
                    </xsl:call-template>
                </tbody>
            </table>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- =========================================================================
    DIAGRAM
========================================================================== -->

<xsl:template match="notepad">
	<div class="note">
		<xsl:attribute name="style">
			left: <xsl:value-of select="xloc"/>px;
			top: <xsl:value-of select="yloc"/>px;
			width: <xsl:value-of select="width"/>px;
			height: <xsl:value-of select="height"/>px;
			font-family: <xsl:value-of select="fontname"/>;
			font-size: <xsl:value-of select="fontsize"/>;
			<xsl:if test="fontbold/text()='Y'">font-weight: bold;</xsl:if>
			<xsl:if test="fontitalic/text()='Y'">font-style: italic;</xsl:if>
			color: rgb(<xsl:value-of select="fontcolorred"/>
					,<xsl:value-of select="fontcolorgreen"/>
					,<xsl:value-of select="fontcolorblue"/>);
			background-color: rgb(<xsl:value-of select="backgroundcolorred"/>
					,<xsl:value-of select="backgroundcolorgreen"/>
					,<xsl:value-of select="backgroundcolorblue"/>);
			border-color: rgb(<xsl:value-of select="bordercolorred"/>
					,<xsl:value-of select="bordercolorgreen"/>
					,<xsl:value-of select="bordercolorblue"/>);
		</xsl:attribute>
		<xsl:value-of select="note"/>
	</div>
</xsl:template>
<!-- =========================================================================
    Code
========================================================================== -->
<xsl:template match="sql[text()]">
	<h4>SQL</h4>
	<pre class="brush: sql;"><xsl:value-of select="text()"/></pre>
</xsl:template>

<xsl:template match="jsScripts">
	<xsl:apply-templates select="jsScript"/>
</xsl:template>

<xsl:template match="jsScript">
	<h5><xsl:value-of select="jsScript_name"/></h5>
	<pre class="brush: js;"><xsl:value-of select="jsScript_script/text()"/></pre>
</xsl:template>

<xsl:template match="definitions[../type='UserDefinedJavaClass']">
	<h4>Java Class Source Code</h4>
	<xsl:apply-templates select="definition"/>
</xsl:template>

<xsl:template match="step[type='UserDefinedJavaClass']/definitions/definition">
	<h5><xsl:value-of select="class_name"/></h5>
	<pre class="brush: java;"><xsl:value-of select="class_source/text()"/></pre>
</xsl:template>

<!-- =========================================================================
    KETTLE TRANSFORMATION
========================================================================== -->
<xsl:template match="transformation">
    <xsl:apply-templates select="info"/>

    <xsl:apply-templates select="parameters"/>
    <xsl:call-template name="high-level-data-flow-diagram"/>    
    <xsl:call-template name="transformation-diagram"/>    
    <xsl:call-template name="variables"/>
	<xsl:call-template name="database-connections"/>
    <h2>Flat Files</h2>
    <p>
        t.b.d.
    </p>
	<xsl:call-template name="transformation-steps"/>
</xsl:template>

<xsl:template name="fields-overview">
    <xsl:variable name="all-fields" select="$document/transformation/step/fields/field"/> 
    
    <h2>Fields</h2>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Format</th>
            </tr>
        </thead>
        <tbody>
        
        </tbody>
    </table>
</xsl:template>

<xsl:template name="high-level-data-flow-diagram">
    <xsl:variable name="steps" select="$document/transformation/step[GUI/draw/text()!='N']"/>
    <xsl:variable 
        name="input-steps" 
        select="
            $steps[
                type = 'AccessInput'
            or  type = 'CsvInput'
            or  type = 'DataGrid'
            or  type = 'CubeInput'
            or  type = 'ShapeFileReader'
            or  type = 'ExcelInput'
            or  type = 'FixedInput'
            or  type = 'RandomValue'
            or  type = 'RowGenerator'
            or  type = 'getXMLData'
            or  type = 'GetFileNames'
            or  type = 'GetFilesRowsCount'
            or  type = 'GetSubFolders'
            or  type = 'SystemInfo'
            or  type = 'LDAPInput'
            or  type = 'LDIFInput'
            or  type = 'LoadFileInput'
            or  type = 'MondrianInput'
            or  type = 'OlapInput'
            or  type = 'PaloCellInput'
            or  type = 'PaloDimInput'
            or  type = 'PropertyInput'
            or  type = 'RssInput'
            or  type = 'S3CSVINPUT'
            or  type = 'SalesforceInput'
            or  type = 'SapInput'
            or  type = 'TableInput'
            or  type = 'TextFileInput'
            or  type = 'XBaseInput'
            ]
        "
    />

    <xsl:variable 
        name="output-steps" 
        select="
            $steps[
                type = 'AccessOutput'
            or  type = 'Delete'
            or  type = 'ExcelOutput'
            or  type = 'InsertUpdate'
            or  type = 'PaloCellOutput'
            or  type = 'PaloDimOutput'
            or  type = 'PropertyOutput'
            or  type = 'RssOutput'
            or  type = 'SalesforceDelete'
            or  type = 'SalesforceInsert'
            or  type = 'SalesforceUpdate'
            or  type = 'SalesforceUpsert'
            or  type = 'CubeOutput'
            or  type = 'SQLFileOutput'
            or  type = 'SynchronizeAfterMerge'
            or  type = 'TableOutput'
            or  type = 'TextFileOutput'
            or  type = 'Update'
            or  type = 'XMLOutput'
            ]
        "
    />
    <h2>High Level Data Flow Diagram</h2>
    <table>
        <thead>
            <tr>
                <th>Input (<xsl:value-of select="count($input-steps)"/>)</th>
                <th>Transform</th>
                <th>Output (<xsl:value-of select="count($output-steps)"/>)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <xsl:for-each select="$input-steps">
                        <div><xsl:value-of select="name"/></div>
                    </xsl:for-each>
                </td>
                <td>
                </td>
                <td>
                    <xsl:for-each select="$output-steps">
                        <div><xsl:value-of select="name"/></div>
                    </xsl:for-each>
                </td>
            </tr>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="transformation/info">
    <h1>Transformation: "<xsl:value-of select="name"/>"</h1>
    <xsl:call-template name="description"/>
</xsl:template>

<xsl:template name="transformation-steps">
	<h2>
		<a>
			<xsl:attribute name="name"><xsl:value-of select="$steps-or-job-entries"/></xsl:attribute>
			<xsl:value-of select="$steps-or-job-entries"/>
		</a>
	</h2>
	<xsl:apply-templates select="step[GUI/draw/text()!='N']"/>
</xsl:template>

<xsl:template match="step[GUI/draw/text()!='N']">
	<xsl:variable name="name" select="name/text()"/>
    <br/>
	<div>
		<xsl:attribute name="class">
			step-icon
			step-icon-<xsl:value-of select="type"/>
		</xsl:attribute>
	</div>
	<h3 class="step-heading">
        <a>
            <xsl:attribute name="name"><xsl:value-of select="$name"/>-text</xsl:attribute>
            <xsl:attribute name="href">#<xsl:value-of select="$name"/>-icon</xsl:attribute>
            <xsl:value-of select="$name"/>
        </a>
	</h3>
	<xsl:call-template name="description">
		<xsl:with-param name="type" select="$step-or-job-entry"/>
	</xsl:call-template>
	<xsl:apply-templates select="sql"/>
	<xsl:apply-templates select="jsScripts"/>
	<xsl:apply-templates select="definitions"/>
    <xsl:apply-templates select="fields"/>
</xsl:template>

<xsl:template match="fields[field]">
    <h4>Fields</h4>
    <table>
        <thead>
            <tr>
                <th>Position</th>
                <xsl:for-each select="field[1]/*">
                    <th>
                        <xsl:value-of select="local-name()"/>
                    </th>
                </xsl:for-each>
            </tr>
        </thead>
        <tbody>
            <xsl:for-each select="field"> 
                <tr>
                    <th>
                        <xsl:value-of select="position()"/>
                    </th>
                    <xsl:for-each select="*">
                        <td><xsl:value-of select="."/></td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
        </tbody>
    </table>
</xsl:template>

<xsl:template name="transformation-diagram">
    <xsl:param name="transformation" select="$document/transformation"/>
    
    <xsl:variable name="steps" select="$transformation/step"/>
    <xsl:variable name="notepads" select="$transformation/notepads/notepad"/>
    <xsl:variable name="error-handlers" select="$transformation/step_error_handling/error"/>

    <!-- 
        TODO: for notepads, take the width / height into account.
    -->
    <xsl:variable name="xlocs" select="$steps/GUI/xloc | $notepads/xloc"/>    
    <xsl:variable name="ylocs" select="$steps/GUI/yloc | $notepads/yloc"/>
    <xsl:variable name="hops" select="$transformation/order/hop"/>

    <xsl:variable name="max-xloc">
        <xsl:call-template name="max">
            <xsl:with-param name="values" select="$xlocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="min-xloc">
        <xsl:call-template name="min">
            <xsl:with-param name="values" select="$xlocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="max-yloc">
        <xsl:call-template name="max">
            <xsl:with-param name="values" select="$ylocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="min-yloc">
        <xsl:call-template name="min">
            <xsl:with-param name="values" select="$ylocs"/>
        </xsl:call-template>
    </xsl:variable>

    <h2><a name="diagram">Diagram</a></h2>    
    <div class="diagram" id="diagram">
        <xsl:attribute name="style">
            width: <xsl:value-of select="($max-xloc - $min-xloc) + 128"/>px;
            height: <xsl:value-of select="($max-yloc - $min-yloc) + 128"/>px;
        </xsl:attribute>
        <xsl:for-each select="$steps">
            <xsl:variable name="type" select="type/text()"/>
            <xsl:variable name="name" select="name/text()"/>
            <xsl:variable name="xloc" select="GUI/xloc"/>
            <xsl:variable name="yloc" select="GUI/yloc"/>
            <xsl:variable name="text-pixels" select="string-length(name) * 4"/>            
            <xsl:variable name="hide" select="GUI/draw/text()='N'"/>
            <xsl:variable name="copies" select="copies/text()"/>
            <xsl:variable name="send-true-to" select="send_true_to/text()"/>
            <xsl:variable name="send-false-to" select="send_false_to/text()"/>
            <xsl:variable name="distribute" select="distribute/text() = 'Y'"/>
            <a>
                <xsl:attribute name="name"><xsl:value-of select="$name"/>-icon</xsl:attribute>
            </a>
            <div>
                <xsl:attribute name="id"><xsl:value-of select="$name"/></xsl:attribute>
                <xsl:attribute name="class">
                    step-icon
                    step-icon-<xsl:value-of select="$type"/>
                    <xsl:if test="$error-handlers[target_step/text() = $name]">
                        step-error
                    </xsl:if>                                        
                    <xsl:if test="$hide">
                        step-hidden
                    </xsl:if>
                </xsl:attribute>                
                <xsl:attribute name="style">
                    left:<xsl:value-of select="$xloc"/>px;
                    top:<xsl:value-of select="$yloc"/>px;
                </xsl:attribute>
                <div class="step-hops">
                    <xsl:for-each select="$hops[from/text()=$name]">
                        <xsl:variable name="from" select="from/text()"/>
                        <xsl:variable name="to" select="to/text()"/>
                        <xsl:variable name="enabled" select="enabled/text() = 'Y'"/>
                        <a>
                            <xsl:attribute name="class">
                                step-hop
                                <xsl:if 
                                    test="
                                        $error-handlers[
                                            source_step/text()=$from
                                        and target_step/text()=$to
                                        ]
                                    "
                                >
                                step-hop-error
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="$enabled">
                                    step-hop-enabled
                                    </xsl:when>
                                    <xsl:otherwise>
                                    step-hop-disabled
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="$send-true-to = $to">step-hop-true</xsl:when>
                                    <xsl:when test="$send-false-to = $to">step-hop-false</xsl:when>
                                    <xsl:when test="$distribute">step-hop-distribute-data</xsl:when>
                                    <xsl:otherwise>step-hop-copy-data</xsl:otherwise>
                                </xsl:choose><xsl:text> </xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('#', $to)"/></xsl:attribute>
                        </a>
                    </xsl:for-each>
                </div>
            </div>
            <a>
                <xsl:attribute name="class">
                    step-label
                    <xsl:if test="$hide">
                        step-label-hidden
                    </xsl:if>
                </xsl:attribute>
                <xsl:attribute name="href">#<xsl:value-of select="$name"/>-text</xsl:attribute>
                <xsl:attribute name="style">
                    top:<xsl:value-of select="$yloc + 32"/>px;
                    left:<xsl:value-of select="$xloc - ($text-pixels div 3)"/>px;                    
                </xsl:attribute>
                <xsl:value-of select="$name"/>
            </a>
        </xsl:for-each>
		<xsl:apply-templates select="//notepads"/>
    </div>
</xsl:template>
<!-- =========================================================================
    KETTLE JOB
========================================================================== -->

<xsl:template match="job">
    <h1>Job: "<xsl:value-of select="name"/>"</h1>
    <table>
        <thead>
            <tr>
                <th>What?</th>
                <th>Who?</th>
                <th>When?</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>Created</th>
                <td><xsl:value-of select="created_user"/></td>
                <td><xsl:value-of select="created_date"/></td>
            </tr>
            <tr>
                <th>Modified</th>
                <td><xsl:value-of select="modified_user"/></td>
                <td><xsl:value-of select="modified_date"/></td>
            </tr>
        </tbody>
    </table>
    <xsl:call-template name="description"/>
    <xsl:apply-templates select="parameters"/>
    <xsl:call-template name="job-diagram"/>
    <xsl:call-template name="variables"/>
	<xsl:call-template name="database-connections"/>
	<xsl:call-template name="job-entries"/>
</xsl:template>

<xsl:template name="job-entries">
	<h2>
		<a>
			<xsl:attribute name="name"><xsl:value-of select="$steps-or-job-entries"/></xsl:attribute>
			<xsl:value-of select="$steps-or-job-entries"/>
		</a>
	</h2>
	<xsl:apply-templates select="entries/entry"/>
</xsl:template>

<xsl:template match="entry[draw!='N']">
	<xsl:variable name="name" select="name/text()"/>
	<xsl:variable name="type" select="type/text()"/>
	<div>
		<xsl:attribute name="class">
			entry-icon
			entry-icon-<xsl:choose>
				<xsl:when test="$type='SPECIAL'"><xsl:call-template name="upper-case">
					<xsl:with-param name="text" select="$name"/>							
				</xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</div>
	<h3 class="entry-heading">
        <a>
            <xsl:attribute name="name"><xsl:value-of select="$name"/>-text</xsl:attribute>
            <xsl:attribute name="href">#<xsl:value-of select="$name"/>-icon</xsl:attribute>
            <xsl:value-of select="$name"/>
        </a>
    </h3>
	<xsl:call-template name="description">
		<xsl:with-param name="type" select="'job entry'"/>
	</xsl:call-template>
	<xsl:apply-templates select="sql"/>
</xsl:template>

<xsl:template name="job-diagram">
    <xsl:param name="job" select="$document/job"/>
    <xsl:variable name="entries" select="$job/entries/entry"/>

    <xsl:variable name="notepads" select="$job/notepads/notepad"/>
    <!-- 
        TODO: for notepads, take the width / height into account.
    -->
    <xsl:variable name="xlocs" select="$entries/xloc | $notepads/xloc"/>
    <xsl:variable name="ylocs" select="$entries/yloc | $notepads/yloc"/>
    <xsl:variable name="hops" select="$job/hops/hop"/>

    <xsl:variable name="max-xloc">
        <xsl:call-template name="max">
            <xsl:with-param name="values" select="$xlocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="min-xloc">
        <xsl:call-template name="min">
            <xsl:with-param name="values" select="$xlocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="max-yloc">
        <xsl:call-template name="max">
            <xsl:with-param name="values" select="$ylocs"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="min-yloc">
        <xsl:call-template name="min">
            <xsl:with-param name="values" select="$ylocs"/>
        </xsl:call-template>
    </xsl:variable>

    <h2><a name="diagram">Diagram</a></h2>    
    <div class="diagram" id="diagram">
        <xsl:attribute name="style">
            width: <xsl:value-of select="($max-xloc - $min-xloc) + 128"/>px;
            height: <xsl:value-of select="($max-yloc - $min-yloc) + 128"/>px;
        </xsl:attribute>
        <xsl:for-each select="$entries">
            <xsl:variable name="type" select="type/text()"/>
            <xsl:variable name="name" select="name/text()"/>
            <xsl:variable name="xloc" select="xloc"/>
            <xsl:variable name="yloc" select="yloc"/>
            <xsl:variable name="text-pixels" select="string-length(name) * 4"/>
            <xsl:variable name="hide" select="draw/text()='N'"/>
            <a>
                <xsl:attribute name="name"><xsl:value-of select="$name"/>-icon</xsl:attribute>
            </a>
            <div>
                <xsl:attribute name="id"><xsl:value-of select="$name"/></xsl:attribute>
                <xsl:attribute name="class">
					entry-icon
                    entry-icon-<xsl:choose>
                        <xsl:when test="$type='SPECIAL'"><xsl:call-template name="upper-case">
							<xsl:with-param name="text" select="$name"/>							
						</xsl:call-template></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$hide">
                        entry-hidden
                    </xsl:if>
                </xsl:attribute>                
                <xsl:attribute name="style">
                    left:<xsl:value-of select="$xloc"/>px;
                    top:<xsl:value-of select="$yloc"/>px;
                </xsl:attribute>
                <div class="entry-hops">
                    <xsl:for-each select="$hops[from/text()=$name]">
                        <a>
                            <xsl:attribute name="class">
                                entry-hop
                                <xsl:choose>
                                    <xsl:when test="unconditional/text()='Y'">entry-hop-unconditional</xsl:when>
                                    <xsl:when test="evaluation/text()='Y'">entry-hop-true</xsl:when>
                                    <xsl:when test="evaluation/text()='N'">entry-hop-false</xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('#', to/text())"/></xsl:attribute>
                        </a>
                    </xsl:for-each>
                </div>
            </div>
            <a>
				<xsl:attribute name="class">
					entry-label
                    <xsl:if test="$hide">
                        entry-label-hidden
                    </xsl:if>
				</xsl:attribute>
                <xsl:attribute name="style">
                    top:<xsl:value-of select="$yloc + 32"/>px;
                    left:<xsl:value-of select="$xloc - ($text-pixels div 3)"/>px;
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when 
                            test="
                                $type = 'JOB'
                            or	$type = 'TRANS'
                            "
                        >
                            <xsl:call-template name="get-doc-uri-for-filename">
                                <xsl:with-param name="step-or-job-entry" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>#<xsl:value-of select="$name"/>-text</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="$name"/>
            </a>
        </xsl:for-each>
		<xsl:apply-templates select="//notepad"/>
    </div>
</xsl:template>

</xsl:stylesheet>
