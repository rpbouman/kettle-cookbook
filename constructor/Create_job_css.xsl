<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output method="text"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/"
         >
       /**
       *   This is job.css. This is part of kettle-cookbook.
       *   Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/
       *   
       *   job.css - a cascading stylesheet file that marks up job documentation
       *   
       *   Copyright (C) 2010 
       *   Roland Bouman Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/
       *   
       *   This library is free software; you can redistribute it and/or modify it under 
       *   the terms of the GNU Lesser General Public License as published by the 
       *   Free Software Foundation; either version 2.1 of the License, or (at your option)
       *   any later version.
       
       *   This library is distributed in the hope that it will be useful, but WITHOUT ANY 
       *   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
       *   PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
       *   
       *   You should have received a copy of the GNU Lesser General Public License along 
       *   with this library; if not, write to 
       *   the Free Software Foundation, Inc., 
       *   59 Temple Place, Suite 330, 
       *   Boston, MA 02111-1307 USA
       *   
       */
       .entry-hops {
          display:none;
       }
       
       .entry-hidden , .entry-label-hidden{
          display:none;
       }
       
       .entry-heading {
          background-repeat: no-repeat;
          text-indent: 38px;
          height: 40px;
       }
       
       .entry-icon {
          position: absolute;
          border-style: solid;
          border-width: 1px;
          border-color: rgb(125,125,125);
          height: 32px;
          width: 32px;
          margin-left: auto;
          margin-right: auto;
          background-repeat: no-repeat;
          z-index:100;
       }
       
       .entry-label {
          margin-top:2px;
          font-size: 8pt !important;
          white-space: nowrap;
          position: absolute;
          z-index:100;
          background-color:white;
       }
       
       .entry-hidden {
          display: none;
       }
       
       .entry-label-hidden {
          display: none;
       }
       
       .entry-hop {
          background-color: black;
       }
       
       .entry-hop-unconditional {
          background-color: black;
       }
       
       .entry-hop-unconditional-icon {
          position:absolute;
          width: 16px;
          height: 16px;
          background-image: url(../images/unconditional-hop.png);
          z-index:500 !important;
       }
       
       .entry-hop-true {
          background-color: green;
       }
       .entry-hop-false {
          background-color: red;
       }
       
       /* following two general entries don't seem to be part of 'kettle-job-entries.xml' */
       
       .entry-icon-START {
          background-image: url(../images/STR.png);    
       }
       
       .entry-icon-DUMMY {
          background-image: url(../images/DUM.png);
       }
       
        <xsl:for-each
         select="job-entries/job-entry">
         <xsl:sort select="category"/>
         <xsl:if test="not(preceding-sibling::job-entry/category/text()[last()] = category/text())"
               >
               /* <xsl:value-of select="tokenize(category/text(), '\.')[last()]"
            /> */
            </xsl:if>
         <xsl:apply-templates select="."/>
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="job-entry">
      <xsl:variable name="iconfile">
         <xsl:value-of select="iconfile"/>
      </xsl:variable>
      <xsl:for-each select="tokenize(@id, ',')">
         <xsl:call-template name="job_icon">
            <xsl:with-param name="job_name">
               <xsl:value-of select="."/>
            </xsl:with-param>
            <xsl:with-param name="iconfile">
               <xsl:value-of select="$iconfile"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="job_icon">
      <xsl:param name="job_name"/>
      <xsl:param name="iconfile"/>
      .entry-icon-<xsl:value-of select="$job_name"/>{
        background-image: url(../images/<xsl:value-of select="tokenize($iconfile/text(), '/')[last()]"/>);
      }
   </xsl:template>


</xsl:stylesheet>
