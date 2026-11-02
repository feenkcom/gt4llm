"
Executable examples for table previews, inline cell styling, native header layout and cursor-triggered source visibility in LLM messages.
"
Class {
	#name : #GtLMessageTableStylerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMessageTableStylerExamples >> annotationCellPreservesTree [
	<gtExample>
	| table cell source positions styled |
	table := (LeParser parse: '| Class | Summary |', String lf, '|---|---|', String lf,
		'| {{gtClass:BlElement}} | Summary |') parts first.
	cell := table rows first cells first.
	source := cell source.
	positions := cell allTokens collect: #startPosition.
	"Populate cached positions before copying, as a real editor does."
	cell withAllNodesDo: [ :node | node startPosition. node stopPosition ].
	{ GtLMessageStyler new.
		LeSnippetStyler new snippetViewModel: LeTextSnippet new asSnippetViewModel; yourself } do: [ :styler |
		styled := styler tableCellTextFor: cell.
		self assert: styled asString equals: source trimBoth.
		self assert: cell source equals: source.
		self assert: (cell allTokens collect: #startPosition) equals: positions.
		self assert: cell parts second annotation parent == cell parts second.
		self assert: cell parts second annotation nameNode source equals: 'BlElement' ].
	^ styled
]

{ #category : #examples }
GtLMessageTableStylerExamples >> boldCellPreservesTree [
	<gtExample>
	| table cell source start styled |
	table := LeMarkdownTableExamples new sample.
	cell := table rows fourth cells third.
	source := cell source.
	start := cell startPosition.
	styled := GtLMessageStyler new tableCellTextFor: cell.
	self assert: styled asString equals: source trimBoth.
	self assert: (styled hasAttributeSuchThat: [ :each | each isKindOf: BlFontWeightAttribute ]).
	self assert: cell source equals: source.
	self assert: cell startPosition equals: start.
	self assert: cell parent == table rows fourth.
	self assert: (GtLMessageStyler new tableCellTextFor: nil) isEmpty.
	^ styled
]

{ #category : #examples }
GtLMessageTableStylerExamples >> classSummaries [
	<gtExample>
	| source text preview list |
	source := '| Class | Summary |', String lf,
		'|---|---|', String lf,
		'| {{gtClass:BlElement}} | The fundamental building block for visual interfaces in Bloc, supporting properties such as background, border, size, and opacity. Elements compose into parent–child trees to build complex interfaces from smaller parts. |', String lf,
		'| {{gtClass:BlSpace}} | Represents a logical window independently of the underlying host platform. It holds the root element and coordinates input processing, layout, and rendering. |', String lf,
		'| {{gtClass:BlLayout}} | Defines the common API for layout strategies that measure elements and position their children. Concrete layouts use constraints to control sizing, spacing, and alignment within an element. |', String lf.
	text := source asRopedText.
	GtLMessageStyler new privateStyle: text.
	text findAttributesSuchThat: [ :each |
		(each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldAppend ] ] indicesDo: [ :start :end :each | preview := each ].
	self assert: preview isNotNil.
	list := preview stencil build.
	self assert: list columns size equals: 2.
	self assert: list items size equals: 3.
	self assert: text asString equals: source.
	list hExact: 800.
	^ list
]

{ #category : #examples }
GtLMessageTableStylerExamples >> nativeHeadersAlignWithBody [
	<gtExample>
	| scripter |
	scripter := BlScripter new element: self sampleList.
	scripter assertStep: [ :step |
		step label: 'Native headers align with body cell editors';
			satisfies: [ :list |
				| headers rows |
				headers := (list query // #'column-header') anyOne children.
				rows := (list query // #scrollable) anyOne children.
				rows notEmpty and: [ rows allSatisfy: [ :row |
					(1 to: headers size) allSatisfy: [ :index |
						| header cell editor |
						header := (headers at: index) bounds inSpace asRectangle.
						cell := row children at: index.
						editor := (cell query // #tableCellEditor) anyOne bounds inSpace asRectangle.
						(header left - editor left) abs < 1 and: [ (header right - editor right) abs < 1 ] ] ] ] ] ].
	^ scripter
]

{ #category : #examples }
GtLMessageTableStylerExamples >> renderedClassSummaries [
	<gtExample>
	| scripter |
	scripter := BlScripter new element: self classSummaries.
	scripter assertStep: [ :step |
		step label: 'Class annotations materialize as link buttons inside editors';
			satisfies: [ :list |
				| buttons editors |
				buttons := (list query // BrButton) all collect: [ :button | button label asString ].
				editors := (list query // #tableCellEditor) all.
				buttons asArray = #('BlElement' 'BlSpace' 'BlLayout') and: [ editors size = 6 ] ] ].
	scripter assertStep: [ :step |
		step label: 'Long summaries wrap to multiple lines';
			satisfies: [ :list |
				| editors |
				editors := (list query // #tableCellEditor) all.
				#(2 4 6) allSatisfy: [ :index | (editors at: index) height > (editors at: index - 1) height ] ] ].
	^ scripter
]

{ #category : #examples }
GtLMessageTableStylerExamples >> sampleList [
	<gtExample>
	| text preview list |
	text := self styledTable.
	text findAttributesSuchThat: [ :each |
		(each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldAppend ] ] indicesDo: [ :start :end :each | preview := each ].
	list := preview stencil build.
	self assert: list class equals: BrColumnedList.
	self assert: list columns size equals: 3.
	self assert: list items size equals: 5.
	list hExact: 800.
	^ list
]

{ #category : #examples }
GtLMessageTableStylerExamples >> sourceRevealedOnCursorEnter [
	<gtExample>
	| text editor cursor |
	text := self styledTable.
	editor := BrEditor new text: text; yourself.
	text findAttributesSuchThat: [ :each | each isKindOf: BrTextCursorDynamicAttribute ] indicesDo: [ :start :end :each | cursor := each ].
	editor editor moveCursorTo: 0.
	cursor enterAction value: editor.
	self assert: (text hasAttributeSuchThat: [ :each | (each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldReplace ] ]) not.
	self assert: (text hasAttributeSuchThat: [ :each | (each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldAppend ] ]).
	cursor leaveAction value: editor.
	self assert: (text hasAttributeSuchThat: [ :each | (each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldReplace ] ]).
	self assert: text asString equals: LeMarkdownTableExamples new sample source.
	^ editor
]

{ #category : #examples }
GtLMessageTableStylerExamples >> styledTable [
	<gtExample>
	| table text previews hidden |
	table := LeMarkdownTableExamples new sample.
	text := table source asRopedText.
	GtLMessageStyler new privateStyle: text.
	previews := OrderedCollection new.
	hidden := OrderedCollection new.
	text findAttributesSuchThat: [ :each | each isKindOf: BrTextAdornmentDynamicAttribute ] indicesDo: [ :start :end :each |
		each shouldAppend ifTrue: [ previews add: each ].
		each shouldReplace ifTrue: [ hidden add: (start to: end) ] ].
	self assert: previews size equals: 1.
	self assert: hidden first first equals: table startPosition.
	self assert: hidden last last equals: table stopPosition.
	self assert: (hidden sum: #size) equals: table source size.
	self assert: text asString equals: table source.
	^ text
]

{ #category : #examples }
GtLMessageTableStylerExamples >> tables [
	<gtExample>
	"Message text with two native table previews and editable Markdown."
	| source text previews editor |
	source := 'Before and now', String lf,
		LeMarkdownTableExamples new sample source, String lf, String lf,
		'Column justification (not applied by the preview)', String lf,
		LeMarkdownTableExamples new columnJustification source, String lf,
		'After the tables.'.
	text := source asRopedText.
	GtLMessageStyler new privateStyle: text.
	previews := OrderedCollection new.
	text findAttributesSuchThat: [ :each | (each isKindOf: BrTextAdornmentDynamicAttribute) and: [ each shouldAppend ] ] indicesDo: [ :start :end :each | previews add: each ].
	self assert: previews size equals: 2.
	previews do: [ :each | self assert: each stencil build class equals: BrColumnedList ].
	self assert: text asString equals: source.
	editor := BrEditor new aptitude: BrGlamorousRegularEditorAptitude; text: text; size: 800 @ 600; yourself.
	^ editor
]
