This page lists third-party components used by kettle-cookbook

# External Resources #

Kettle-cookbook is open source, just like Kettle. And just like Kettle, kettle-cookbook relies on third party open source libraries, without which kettle-cookbook would not have been realized. This page serves to give proper attribution.

## Extraction and Analysis ##
Kettle-cookbook is itself a Kettle solution. You need Kettle to run the document-all.kjb job (and the transformations and jobs that are called by it)

## Icons ##
All icons and background images are copied from Kettle (pentaho data integration)

## XSLT transformation ##
Kettle-cookbook uses the java implementation of the Saxon library included with kettle to perform XSLT transformations. This technique does the actual job of generating human readable HTML documents from the .ktr and .kjb files.

## wz\_jsgraphics ##
Hops in the Kettle job and transformation diagrams are drawn using wz\_jsgraphics.js. For kettle-cookbook, a small modification was introduced that lets the user set the class name, which allows the lines to be styled using a CSS stylesheet.

## syntaxhighligher ##
Code highlighting is realized using http://alexgorbatchev.com/SyntaxHighlighter/