<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:template name="high-level-data-flow-diagram">
      <xsl:variable name="steps"
         select="$document/transformation/step[GUI/draw/text()!='N']"/>
      <xsl:variable name="input-steps"
         select="$steps[&#xA;                  type = 'AccessInput' or type = 'CsvInput' or type = 'CubeInput' or type = 'DataGrid' or type = 'ExcelInput' or type = 'FixedInput' or type = 'GetFileNames' or type = 'GetFilesRowsCount' or type = 'GetRepositoryNames' or type = 'GetSubFolders' or type = 'GetTableNames' or type = 'JsonInput' or type = 'LDAPInput' or type = 'LDIFInput' or type = 'LoadFileInput' or type = 'MailInput' or type = 'MondrianInput' or type = 'OlapInput' or type = 'ParallelGzipCsvInput' or type = 'PropertyInput' or type = 'RandomCCNumberGenerator' or type = 'RandomValue' or type = 'RowGenerator' or type = 'RssInput' or type = 'SASInput' or type = 'SalesforceInput' or type = 'SapInput' or type = 'SystemInfo' or type = 'TableInput' or type = 'TextFileInput' or type = 'TypeExitGoogleAnalyticsInputStep' or type = 'XBaseInput' or type = 'XMLInputStream' or type = 'YamlInput' or type = 'getXMLData']&#xA;               "/>
      <xsl:variable name="output-steps"
         select="$steps[&#xA;                  type = 'AccessOutput' or type = 'AutoDoc' or type = 'CubeOutput' or type = 'Delete' or type = 'ExcelOutput' or type = 'InsertUpdate' or type = 'JsonOutput' or type = 'LDAPOutput' or type = 'PentahoReportingOutput' or type = 'PropertyOutput' or type = 'RssOutput' or type = 'SQLFileOutput' or type = 'SalesforceDelete' or type = 'SalesforceInsert' or type = 'SalesforceUpdate' or type = 'SalesforceUpsert' or type = 'SynchronizeAfterMerge' or type = 'TableOutput' or type = 'TextFileOutput' or type = 'TypeExitExcelWriterStep' or type = 'Update' or type = 'XMLOutput']&#xA;               "/>
      <xsl:call-template name="high-level-data-flow-diagram-execute">
         <xsl:with-param name="input-steps" select="$input-steps"/>
         <xsl:with-param name="output-steps" select="$output-steps"/>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>
