/**
 * SyntaxHighlighter
 * http://alexgorbatchev.com/SyntaxHighlighter
 *
 * SyntaxHighlighter is donationware. If you are using it, please donate.
 * http://alexgorbatchev.com/SyntaxHighlighter/donate.html
 *
 * @version
 * 3.0.83 (July 02 2010)
 * 
 * @copyright
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 *
 * @license
 * Dual licensed under the MIT and GPL licenses.
 */
;(function()
{
	// CommonJS
	typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

	function Brush()
	{
		var keywords =	'ABSOLUTE ACTIONPARAMETERSET ADDCALCULATEDMEMBERS AFTER AGGREGATE ' +
                        'ALL ALLMEMBERS ANCESTOR ANCESTORS AND AS ASC ASCENDANTS AVERAGE' +
                        'AXIS BASC BDESC BEFORE BEFORE_AND_AFTER BOTTOMCOUNT BOTTOMPERCENT ' +
                        'BOTTOMSUM BY CACHE CALCULATE CALCULATION CALCULATIONCURRENTPASS ' +
                        'CALCULATIONPASSVALUE CALCULATIONS CALL CELL CELLFORMULASETLIST' +
                        'CHAPTERS CHILDREN CLEAR CLOSINGPERIOD COALESCEEMPTY COLUMN COLUMNS '+
                        'CORRELATION COUNT COUSIN COVARIANCE COVARIANCEN CREATE CREATEPROPERTYSET ' +
                        'CREATEVIRTUALDIMENSION CROSSJOIN CUBE CURRENT CURRENTCUBE CURRENTMEMBER ' +
                        'DEFAULT_MEMBER DEFAULTMEMBER DESC DESCENDANTS DESCRIPTION DIMENSION ' +
                        'DIMENSIONS DISTINCT DISTINCTCOUNT DRILLDOWNLEVEL DRILLDOWNLEVELBOTTOM ' +
                        'DRILLDOWNLEVELTOP DRILLDOWNMEMBER DRILLDOWNMEMBERBOTTOM DRILLDOWNMEMBERTOP '+
                        'DRILLUPLEVEL DRILLUPMEMBER DROP EMPTY END ERROR EXCEPT EXCLUDEEMPTY EXTRACT '+
                        'FALSE FILTER FIRSTCHILD FIRSTSIBLING FOR FREEZE FROM GENERATE GLOBAL GROUP '+
                        'GROUPING HEAD HIDDEN HIERARCHIZE HIERARCHY IGNORE IIF INCLUDEEMPTY INDEX ' +
                        'INTERSECT IS ISANCESTOR ISEMPTY ISGENERATION ISLEAF ISSIBLING ITEM LAG ' +
                        'LASTCHILD LASTPERIODS LASTSIBLING LEAD LEAVES LEVEL LEVELS LINKMEMBER ' +
                        'LINREGINTERCEPT LINREGPOINT LINREGR2 LINREGSLOPE LINREGVARIANCE LOOKUPCUBE '+
                        'MAX MEASURE MEDIAN MEMBER MEMBERS MEMBERTOSTR MIN MTD NAME NAMETOSET NEST '+
                        'NEXTMEMBER NO_ALLOCATION NO_PROPERTIES NON NONEMPTYCROSSJOIN '+
                        'NOT_RELATED_TO_FACTS NULL ON OPENINGPERIOD OR PAGES PARALLELPERIOD PARENT ' +
                        'PASS PERIODSTODATE POST PREDICT PREVMEMBER PROPERTIES PROPERTY QTD RANK ' +
                        'RECURSIVE RELATIVE ROLLUPCHILDREN ROOT ROWS SCOPE SECTIONS SELECT SELF ' +
                        'SELF_AND_AFTER SELF_AND_BEFORE SELF_BEFORE_AFTER SESSION SET SETTOARRAY '+
                        'SETTOSTR SORT STDDEV STDDEVP STDEV STDEVP STORAGE STRIPCALCULATEDMEMBERS '+
                        'STRTOMEMBER STRTOSET STRTOTUPLE STRTOVAL STRTOVALUE SUBSET SUM TAIL THIS '+
                        'TOGGLEDRILLSTATE TOPCOUNT TOPPERCENT TOPSUM TOTALS TREE TRUE TUPLETOSTR '+
                        'TYPE UNION UNIQUE UNIQUENAME UPDATE USE USE_EQUAL_ALLOCATION '+
                        'USE_WEIGHTED_ALLOCATION USE_WEIGHTED_INCREMENT USERNAME VALIDMEASURE '+
                        'VALUE VAR VARIANCE VARIANCEP VARP VISUAL VISUALTOTALS WHERE WITH WTD XOR YTD'
						;
		var functions =	'AddCalculatedMembers Aggregate AllMembers Ancestor Ancestors Ascendants '+
                        'Avg Axis BottomCount BottomPercent BottomSum CalculationCurrentPass '+
                        'CalculationPassValue CalculationPassValue Children ClosingPeriod '+
                        'CoalesceEmpty CoalesceEmpty Correlation Count Count Count Count '+
                        'Cousin Covariance CovarianceN Crossjoin Current CurrentMember CurrentOrdinal '+
                        'DataMember DefaultMember Descendants Dimension Dimensions Distinct DistinctCount '+
                        'DrilldownLevel DrilldownLevelBottom DrilldownLevelTop DrilldownMember '+
                        'DrilldownMemberBottom DrilldownMemberTop DrillupLevel DrillupMember Error '+
                        'Except Exists Extract Filter FirstChild FirstSibling Generate Generate Head '
                        'Hierarchize Hierarchy IIf IIf Intersect IsAncestor IsEmpty '+
                        'IsGeneration IsLeaf IsSibling Item Item Lag LastChild LastPeriods LastSibling '+
                        'Lead Leaves Level Levels LinkMember LinRegIntercept LinRegPoint '+
                        'LinRegR2 LinRegSlope LinRegVariance LookupCube LookupCube Max Median Members '+
                        'Members MemberToStr Min Mtd Name NameToSet NextMember NonEmptyCrossjoin '+
                        'OpeningPeriod Order Ordinal ParallelPeriod Parent PeriodsToDate Predict PrevMember '+
                        'Properties Qtd Rank RollupChildren Root SetToArray SetToStr Siblings Stddev StddevP '+
                        'Stdev StdevP StripCalculatedMembers StrToMember StrToSet StrToTuple StrToValue '+
                        'Subset Sum Tail This ToggleDrillState TopCount TopPercent TopSum TupleToStr '+
                        'Union UniqueName UnknownMember Unorder UserName ValidMeasure Value Var Variance '+
                        'VarianceP VarP VisualTotals Wtd Ytd '
						;

		var r = SyntaxHighlighter.regexLib;
		
		this.regexList = [
			{ regex: r.multiLineDoubleQuotedString,					css: 'string' },			// double quoted strings
			{ regex: r.multiLineSingleQuotedString,					css: 'string' },			// single quoted strings
			{ regex: r.singleLineCComments,							css: 'comments' },			// one line comments
			{ regex: r.multiLineCComments,							css: 'comments' },			// multiline comments
			{ regex: new RegExp(this.getKeywords(keywords), 'gmi'),	css: 'keyword' },			// keywords
			{ regex: new RegExp(this.getKeywords(functions), 'gmi'),css: 'color1' } 		    // functions
			];
	
		this.forHtmlScript(r.scriptScriptTags);
	};

	Brush.prototype	= new SyntaxHighlighter.Highlighter();
	Brush.aliases	= ['mdx'];

	SyntaxHighlighter.brushes.Mdx = Brush;

	// CommonJS
	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();
