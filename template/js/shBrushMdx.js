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
		var keywords =	'ABSOLUTE ACTIONPARAMETERSET AFTER ALL AND AS ASC AVERAGE BASC BDESC ' + 
                        'BEFORE BEFORE_AND_AFTER BY CACHE CALCULATE CALCULATION CALCULATIONS ' +
                        'CALL CELL CELLFORMULASETLIST CHAPTERS CLEAR COALESCEEMPTY COLUMN COLUMNS '+
                        'CREATE CREATEPROPERTYSET CREATEVIRTUALDIMENSION CUBE CURRENTCUBE ' +
                        'DEFAULT_MEMBER DESC DESCRIPTION DROP EMPTY END EXCLUDEEMPTY FALSE '+
                        'FOR FREEZE FROM GLOBAL GROUP GROUPING HIDDEN  IGNORE INCLUDEEMPTY INDEX ' +
                        'IS MEASURE MEMBER NEST NO_ALLOCATION NO_PROPERTIES NON NOT_RELATED_TO_FACTS '+
                        'NULL ON OR PAGES PASS POST PROPERTY QTD RECURSIVE RELATIVE ROWS SCOPE '+
                        'SECTIONS SELECT SELF SELF_AND_AFTER SELF_AND_BEFORE SELF_BEFORE_AFTER '+
                        'SESSION SET SETTOARRAY SORT STORAGE STRTOVAL TOTALS TREE TRUE TYPE '+
                        'UNIQUE UPDATE USE USE_EQUAL_ALLOCATION USE_WEIGHTED_ALLOCATION '+
                        'USE_WEIGHTED_INCREMENT VISUAL WHERE WITH XOR'
						;
		var functions =	'AddCalculatedMembers Aggregate AllMembers Ancestor Ancestors Ascendants '+
                        'Avg Axis BottomCount BottomPercent BottomSum CalculationCurrentPass '+
                        'CalculationPassValue Children ClosingPeriod '+
                        'CoalesceEmpty Correlation Count '+
                        'Cousin Covariance CovarianceN Crossjoin Current CurrentMember CurrentOrdinal '+
                        'DataMember DefaultMember Descendants Dimension Dimensions Distinct DistinctCount '+
                        'DrilldownLevel DrilldownLevelBottom DrilldownLevelTop DrilldownMember '+
                        'DrilldownMemberBottom DrilldownMemberTop DrillupLevel DrillupMember Error '+
                        'Except Exists Extract Filter FirstChild FirstSibling Generate Head '
                        'Hierarchize Hierarchy IIf Intersect IsAncestor IsEmpty '+
                        'IsGeneration IsLeaf IsSibling Item Lag LastChild LastPeriods LastSibling '+
                        'Lead Leaves Level Levels LinkMember LinRegIntercept LinRegPoint '+
                        'LinRegR2 LinRegSlope LinRegVariance LookupCube Max Median Members '+
                        'MemberToStr Min Mtd Name NameToSet NextMember NonEmptyCrossjoin '+
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
