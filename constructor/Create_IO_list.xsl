<?xml version="1.0" encoding="UTF-8"?>
<!--
   
    This is create_io_list.xslt. 
    create_io_list.xslt - an XSLT transformation that generates is_steps.xslt,
    which in turn is imported by kettle-report.xslt.
    
    This is part of kettle-cookbook, a documentation generation framework for 
    the Pentaho Business Intelligence Suite.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output method="xml" indent="yes"/>
   <xsl:strip-space elements="*"/>

   <xsl:template match="/">
      <xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
         <xsl:attribute name="version">1.0</xsl:attribute>
         <xsl:element name="xsl:template">
            <xsl:attribute name="name">high-level-data-flow-diagram</xsl:attribute>
            <xsl:element name="xsl:variable">
               <xsl:attribute name="name">steps</xsl:attribute>
               <xsl:attribute name="select">$document/transformation/step[GUI/draw/text()!='N']</xsl:attribute>
            </xsl:element>

            <xsl:element name="xsl:variable">
               <xsl:attribute name="name">input-steps</xsl:attribute>
               <xsl:attribute name="select">$steps[
                  <xsl:for-each
                     select="steps/step[ends-with(category, 'Input')]">
                     <xsl:sort select="@id"/>
                     <xsl:if test="position()>1"> or </xsl:if>
                     <xsl:text>type = '</xsl:text><xsl:value-of select="@id"/><xsl:text>'</xsl:text>
                  </xsl:for-each>]
               </xsl:attribute>
            </xsl:element>

            <xsl:element name="xsl:variable">
               <xsl:attribute name="name">output-steps</xsl:attribute>
               <xsl:attribute name="select">$steps[
                  <xsl:for-each
                     select="steps/step[ends-with(category, 'Output')]">
                     <xsl:sort select="@id"/>
                     <xsl:if test="position()>1"> or </xsl:if>
                     <xsl:text>type = '</xsl:text><xsl:value-of select="@id"/><xsl:text>'</xsl:text>
                  </xsl:for-each>]
               </xsl:attribute>
            </xsl:element>
            
            <xsl:element name="xsl:call-template">
               <xsl:attribute name="name">high-level-data-flow-diagram-execute</xsl:attribute>
               <xsl:element name="xsl:with-param">
                  <xsl:attribute name="name">input-steps</xsl:attribute>
                  <xsl:attribute name="select">$input-steps</xsl:attribute>
               </xsl:element>
               <xsl:element name="xsl:with-param">
                  <xsl:attribute name="name">output-steps</xsl:attribute>
                  <xsl:attribute name="select">$output-steps</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
