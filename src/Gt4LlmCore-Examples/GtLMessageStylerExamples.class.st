"
Examples for styling LLM messages with pragma annotations.
"
Class {
	#name : #GtLMessageStylerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> allAnnotationsDoNotFail [
	"Styling does not stop at an annotation the styler does not know: the bold text after it is still styled"

	<gtExample>
	<return: #Array>
	^ self annotationSamples
		collect: [ :each | 
			| source text |
			source := 'Before ' , each value , ' and **bold**'.
			text := GtLMessageStyler new privateStyle: source asRopedText.
			self assert: text asString equals: source.
			self
				assert: ((text attributesAt: source size - 3)
						anySatisfy: [ :attribute | attribute isKindOf: BlFontWeightAttribute ])
				description: [ each key , ' must not stop the styling' ].
			each key -> text ]

]

{ #category : #private }
GtLMessageStylerExamples >> annotationSamples [
	^ GtLTextSnippetExporterExamples new annotationSamples

]

{ #category : #'examples - markdown' }
GtLMessageStylerExamples >> boldDelimitersAreHiddenInitially [
	<gtExample>
	<return: #BlText>
	| source text delimiterIndices |
	source := '**something**'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 3)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontWeightAttribute ]).
	delimiterIndices := (1 to: 2) , (text size - 2 + 1 to: text size).
	delimiterIndices
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | attribute isKindOf: BrTextAdornmentDynamicAttribute ])
				description: 'Markdown delimiter at position ' , index asString
						, ' should be hidden immediately after styling' ].
	(3 to: text size - 2)
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | attribute isKindOf: BrTextAdornmentDynamicAttribute ])
						not ].
	^ text
]

{ #category : #'examples - markdown' }
GtLMessageStylerExamples >> doubleBacktickCodeDelimitersAreHiddenInitially [
	<gtExample>
	<return: #BlText>
	| source text delimiterIndices |
	source := '``some code``'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 3)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontFamilyAttribute ]).
	delimiterIndices := (1 to: 2) , (text size - 2 + 1 to: text size).
	delimiterIndices
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | 
							(attribute isKindOf: BrTextAdornmentDynamicAttribute)
								and: [ attribute shouldReplace ] ])
				description: 'Markdown delimiter at position ' , index asString
						, ' should be hidden immediately after styling' ].
	(3 to: text size - 2)
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | 
							(attribute isKindOf: BrTextAdornmentDynamicAttribute)
								and: [ attribute shouldReplace ] ]) not ].
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> exampleAnnotationValue [
	<gtExample>
	^ 3 @ 4
]

{ #category : #private }
GtLMessageStylerExamples >> examplePreviewAttributeIn: aText [
	^ (1 to: aText size)
		inject: nil
		into: [ :found :index | 
			found
				ifNil: [ (aText attributesAt: index)
						detect: [ :each | each isKindOf: GtExamplePreviewAttribute ]
						ifNone: [ nil ] ] ]
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleMessagePreview [
	<gtExample>
	^ GtLMarkdown
		content: 'Example preview:

{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue|previewExpanded=true}}

Result link: {{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue|label=#printString}}'
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExamplePreviewAppendsAfterText [
	<gtExample>
	| source text attribute |
	source := 'asda ds a
	
	
	Before {{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue}} after'.
	text := source asRopedText.
	GtLMessageStyler new style: text.
	attribute := self examplePreviewAttributeIn: text.
	self assert: attribute shouldAppend.
	self assert: attribute shouldReplace not.
	self assert: text asString equals: source.
	^ GtLMarkdown content: source
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExamplePreviewStartsOnNewLine [
	<gtExample>
	| text attribute editor scripter |
	text := 'Added {{gtExample:GtLMessageStylerExamples>>#exampleAnnotationValue}}'
			asRopedText.
	GtLMessageStyler new style: text.
	attribute := self examplePreviewAttributeIn: text.
	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			hExact: 800;
			vFitContent;
			text: text;
			yourself.
	scripter := BlScripter new element: editor.
	scripter wait
		forElementCondition: [ :element | (element query // attribute elementId) all isNotEmpty ]
			timeout: 5 seconds;
		play.
	scripter
		assertStep: [ :step | 
			step
				label: 'Example code starts below the line containing Added';
				satisfies: [ :element | 
					| preview |
					preview := (element query // attribute elementId) all first.
					preview bounds inSpace top > (element bounds inSpace top + 10) ] ].
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleRenderedResultLink [
	<gtExample>
	| text attribute button scripter |
	text := self gtExampleStylingWithLabel.
	attribute := (text attributesAt: 1)
			detect: [ :each | each isKindOf: GtButtonAttribute ].
	button := attribute stencil build.
	scripter := BlScripter new element: button.
	scripter wait
		forElementCondition: [ :element | element isEnabled and: [ element label asString = '(3@4)' ] ]
			timeout: 5 seconds;
		play.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleRenderedResultLinkError [
	<gtExample>
	| source text annotation styler attribute button scripter |
	source := '{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue|label=#printString}}'.
	text := source asRopedText.
	styler := GtLMessageStyler new.
	styler style: text.
	text
		clearAttributes: 1
		to: text size
		if: [ :each | true ].
	(LeParser parseWithErrors: source)
		withAllNodesDo: [ :node | (node isKindOf: LeExampleAnnotationNode) ifTrue: [ annotation := node ] ].
	styler
		styleButton: annotation
		forValuable: [ Error signal: 'Example result unavailable' ]
		defaultLabel: #printString
		withTool: [ self error: 'An error link should inspect the error' ].
	attribute := (text attributesAt: 1)
			detect: [ :each | each isKindOf: GtButtonAttribute ].
	button := attribute stencil build.
	scripter := BlScripter new element: button.
	scripter wait
		forElementCondition: [ :element | 
				element isEnabled
					and: [ element label asString includesSubstring: 'Example result unavailable' ] ]
			timeout: 5 seconds;
		play.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleResultLinkOpensInspector [
	<gtExample>
	| scripter button tool |
	scripter := self gtExampleRenderedResultLink.
	button := scripter element.
	button
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			tool := event tool.
			event consumed: true ].
	scripter clickStep: [ :step | step label: 'Open the example result inspector' ].
	self assert: (tool isKindOf: GtInspectorTool).
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleStyling [
	<gtExample>
	| text attribute example hadResult |
	example := GtLMessageStyler new
			exampleFor: (self class >> #exampleAnnotationValue) asActiveRingDefinition.
	hadResult := example hasResult.
	text := '{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue}}'
			asRopedText.
	GtLMessageStyler new style: text.
	attribute := self examplePreviewAttributeIn: text.
	self assert: attribute notNil.
	self assert: attribute example == example.
	self assert: example hasResult equals: hadResult.
	self assert: attribute codeExpanded.
	self assert: attribute previewExpanded not.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleStylingInvalidReferences [
	<gtExample>
	| texts |
	texts := {'{{gtExample:GtLMissingExampleClass>>missing}}'.
			'{{gtExample:GtLMessageStylerExamples>>missingExampleMethod}}'.
			'{{gtExample:GtLMessageStyler>>initialize}}'.
			'{{gtExample:}}'}
			collect: [ :source | 
				| text |
				text := source asRopedText.
				GtLMessageStyler new style: text.
				self assert: (self examplePreviewAttributeIn: text) isNil.
				self
					assert: ((1 to: text size)
							noneSatisfy: [ :index | 
								(text attributesAt: index)
									anySatisfy: [ :each | (each isKindOf: GtButtonAttribute) or: [ each isKindOf: BrTextHideAttribute ] ] ]).
				text ].
	^ texts
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleStylingRetainsResult [
	<gtExample>
	| styler source first second example result |
	styler := GtLMessageStyler new.
	source := '{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue}}'.
	first := source asRopedText.
	styler style: first.
	example := (self examplePreviewAttributeIn: first) example.
	result := example returnValue.
	second := source asRopedText.
	styler style: second.
	self assert: (self examplePreviewAttributeIn: second) example == example.
	self assert: example returnValue == result.
	self assert: result equals: 3 @ 4.
	^ second
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleStylingWithLabel [
	<gtExample>
	| text attributes |
	text := '{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue|label=#printString}}'
			asRopedText.
	GtLMessageStyler new style: text.
	attributes := text attributesAt: 1.
	self
		assert: (attributes anySatisfy: [ :each | each isKindOf: GtButtonAttribute ]).
	self
		assert: (attributes anySatisfy: [ :each | each isKindOf: BrTextHideAttribute ]).
	self assert: (self examplePreviewAttributeIn: text) isNil.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtExampleStylingWithOptions [
	<gtExample>
	| text attribute |
	text := '{{gtExample:GtLMessageStylerExamples>>exampleAnnotationValue|codeExpanded=false|noCode=true|previewExpanded=true|previewShow=#gtPrintFor:|previewSelect=#gtRawFor:|previewHeight=240}}'
			asRopedText.
	GtLMessageStyler new style: text.
	attribute := self examplePreviewAttributeIn: text.
	self assert: attribute notNil.
	self assert: attribute codeExpanded not.
	self assert: attribute noCode.
	self assert: attribute previewExpanded.
	self assert: attribute previewShowSelector equals: #gtPrintFor:.
	self assert: attribute previewSelectSelector equals: #gtRawFor:.
	self assert: attribute previewHeight equals: 240.
	^ text
]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> gtFileReferenceStyling [
	"gtFileReference annotations are shown in the code font with the markup colour"

	<gtExample>
	<return: #BlText>
	| source text index |
	source := 'See {{gtFileReference:path=gtoolkit.yaml|label="Yaml"}} here'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	index := source indexOfSubCollection: 'gtoolkit.yaml'.
	self
		assert: ((text attributesAt: index)
				anySatisfy: [ :each | each isKindOf: BlFontFamilyAttribute ]).
	self
		assert: (((text attributesAt: index) select: [ :each | each isKindOf: BlTextForegroundAttribute ])
				anySatisfy: [ :each | each paint = BrGlamorousColors textMarkupColor ]).
	self assert: (self hasAttribute: BlFontFamilyAttribute in: (text from: 1 to: 4)) not.
	^ text

]

{ #category : #'examples - gtObject' }
GtLMessageStylerExamples >> gtObjectStylingWithFallbackLabel [
	<gtExample>
	<return: #BlText>
	| storage text styler range foregroundAttr |
	storage := GtLObjectStorage new.
	text := '{{gtObject:id=0000000000000000000000000|fallbackLabelString=''missing Widget''}}'
				asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	foregroundAttr := (text attributesAt: 1)
				detect: [:a | a isKindOf: BlTextForegroundAttribute].
	self assert: foregroundAttr paint
		equals: BrGlamorousColors linkWithErrorColor.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]]).
	^text
]

{ #category : #running }
GtLMessageStylerExamples >> gtObjectStylingWithHeightOnly [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: 'Hello World' reasonString: 'test'.
	text := ('\{\{gtObject:id={1}|height=400\}\}' format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: GtButtonAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: GtCachedTextExpandButtonAttribute ] ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithLabelError [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: Object new reasonString: 'error test'.
	text := ('\{\{gtObject:id={1}|label=#thisWillFail\}\}' format: {string36})
			asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: GtButtonAttribute ] ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithMissingObject [
	<gtExample>
	<return: #BlText>
	| storage text styler range foregroundAttr |
	storage := GtLObjectStorage new.
	text := '{{gtObject:id=0000000000000000000000000}}' asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	foregroundAttr := (text attributesAt: 1)
				detect: [:a | a isKindOf: BlTextForegroundAttribute].
	self assert: foregroundAttr paint
		equals: BrGlamorousColors linkWithErrorColor.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]])
				not.
	^text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithMultipleObjects [
	<gtExample>
	<return: #BlText>
	| storage id1 id2 text styler |
	storage := GtLObjectStorage new.
	id1 := storage
			addNewObject: (BlElement new size: 200 @ 100)
			reasonString: 'element'.
	id2 := storage addNewObject: 'Hello World' reasonString: 'string'.
	text := ('See \{\{gtObject:id={1}\}\} and \{\{gtObject:id={2}\}\}'
			format: {id1.
					id2}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	self
		assert: ((1 to: text size)
				count: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: GtButtonAttribute ] ])
				>= 2.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithShowAndHeight [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage
			addNewObject: (BlElement new
					size: 200 @ 100;
					background: Color blue)
			reasonString: 'test'.
	text := ('\{\{gtObject:id={1}|show=#gtViewsFor:|height=300|expanded=true\}\}'
			format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: GtCachedTextExpandButtonAttribute ] ]).
	^ text
]

{ #category : #running }
GtLMessageStylerExamples >> gtObjectStylingWithShowError [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: Object new reasonString: 'error test'.
	text := ('\{\{gtObject:id={1}|show=#nonExistentView:|expanded=true\}\}'
			format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: GtCachedTextExpandButtonAttribute ] ]).
	^ text
]

{ #category : #running }
GtLMessageStylerExamples >> gtObjectStylingWithShowOnly [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: 'Hello World' reasonString: 'test'.
	text := ('\{\{gtObject:id={1}|show=#gtItemsFor:\}\}' format: {string36})
			asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: GtButtonAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: GtCachedTextExpandButtonAttribute ] ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithSingleObject [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage
			addNewObject: (BlElement new
					size: 200 @ 100;
					background: Color blue)
			reasonString: 'test'.
	text := ('\{\{gtObject:id={1}\}\}' format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: BlTextForegroundAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: GtButtonAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | 
					(text attributesAt: i)
						anySatisfy: [ :a | a isKindOf: GtCachedTextExpandButtonAttribute ] ]).
	self
		assert: (range
				anySatisfy: [ :i | (text attributesAt: i) anySatisfy: [ :a | a isKindOf: BrTextHideAttribute ] ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageMessagePreview [
	<gtExample>
	| page |
	page := LeDatabase gtBook pageNamed: 'Rules for styling replies'.
	^ GtLMarkdown
		content: 'By name: {{gtPage:Rules for styling replies}}' , String lf , String lf
				, 'By ID: {{gtPage:id=' , page uid asString36 , '|db='
				, page database uuidString , '}}' , String lf , String lf
				, 'With label: {{gtPage:Rules for styling replies|label=Styling rules}}'
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageRenderedExpander [
	<gtExample>
	| page text styler editor scripter |
	page := LeDatabase gtBook pageNamed: 'Rules for styling replies'.
	text := '{{gtPage:Rules for styling replies}}' asRopedText.
	styler := GtLMessageStyler new.
	styler style: text.
	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			hExact: 800;
			vFitContent;
			text: text;
			yourself.
	scripter := BlScripter new element: editor.
	(editor query // BrInlineExpanderElement) all first id: #pageAnnotationExpander.
	scripter
		clickStep: [ :step | 
			step
				label: 'Expand the linked page';
				// BrInlineExpanderElement ].
	scripter wait
		forElementCondition: [ :element | (element query // LePageToolContentTreeElement) all isNotEmpty ]
			timeout: 5 seconds;
		play.
	scripter
		assertStep: [ :step | 
			step
				label: 'The preview displays the linked page';
				satisfies: [ :element | 
					(element query // LePageToolContentTreeElement) all
						anySatisfy: [ :each | each pageViewModel pageModel == page ] ] ].
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageRenderedExpanderCollapses [
	<gtExample>
	| scripter |
	scripter := self gtPageRenderedExpander.
	scripter
		clickStep: [ :step | 
			step
				label: 'Collapse the linked page';
				// #pageAnnotationExpander ].
	scripter
		assertStep: [ :step | 
			step
				label: 'The page content is removed when collapsed';
				satisfies: [ :element | (element query // LePageToolContentTreeElement) all isEmpty ] ].
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingById [
	<gtExample>
	| page source text attribute button scripter tool |
	page := LeDatabase gtBook pageNamed: 'Rules for styling replies'.
	source := '{{gtPage:id=' , page uid asString36 , '|db='
			, page database uuidString , '}}'.
	text := source asRopedText.
	GtLMessageStyler new style: text.
	attribute := (text attributesAt: 1)
			detect: [ :each | each isKindOf: GtButtonAttribute ].
	button := attribute stencil build.
	scripter := BlScripter new element: button.
	scripter
		assertStep: [ :step | 
			step
				label: 'Page ID annotations render the page title';
				satisfies: [ :element | element label asString = page title ] ].
	button
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			tool := event tool.
			event consumed: true ].
	scripter clickStep: [ :step | step label: 'Open the referenced page' ].
	self assert: (tool isKindOf: LePagePhlowTool).
	self assert: tool page == page.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingByName [
	<gtExample>
	| page button scripter tool |
	page := LeDatabasesRegistry uniqueInstance defaultLogicalDatabase
			pageNamed: 'Rules for styling replies'.
	button := self pageButtonFor: '{{gtPage:Rules for styling replies}}'.
	scripter := BlScripter new element: button.
	self assert: button label asString equals: page title.
	self assert: button isEnabled.
	button
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			tool := event tool.
			event consumed: true ].
	scripter
		clickStep: [ :step | step label: 'Open a page without an explicit database' ].
	self assert: tool page == page.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingMalformedAnnotation [
	<gtExample>
	| source text |
	source := '{{gtPage:id=not-a-uuid}}'.
	text := source asRopedText.
	GtLMessageStyler new style: text.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 1)
				noneSatisfy: [ :each | each isKindOf: GtButtonAttribute ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingMissingTargetHasNoExpander [
	<gtExample>
	| text |
	text := '{{gtPage:GtLMessageStyler missing page 748d68}}' asRopedText.
	GtLMessageStyler new style: text.
	self
		assert: ((text attributesAt: 1)
				noneSatisfy: [ :each | each isKindOf: GtCachedTextExpandButtonAttribute ]).
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingMissingTargets [
	<gtExample>
	| buttons |
	buttons := {'{{gtPage:GtLMessageStyler missing page 748d68}}'.
			'{{gtPage:Rules for styling replies|db=0000000000000000000000000}}'.
			'{{gtPage:id=0000000000000000000000000}}'}
			collect: [ :source | 
				| button |
				button := self pageButtonFor: source.
				self assert: button label asString isNotEmpty.
				self assert: button isEnabled not.
				button ].
	^ buttons
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingWithExpander [
	<gtExample>
	| page text attribute preview |
	page := LeDatabase gtBook pageNamed: 'Rules for styling replies'.
	text := ('{{gtPage:id=' , page uid asString36 , '|db='
			, page database uuidString , '}}') asRopedText.
	GtLMessageStyler new style: text.
	attribute := (text attributesAt: 1)
			detect: [ :each | each isKindOf: GtCachedTextExpandButtonAttribute ]
			ifNone: [ nil ].
	self assert: attribute notNil description: 'Page annotations offer an expander'.
	self assert: attribute isExpanded not.
	preview := attribute attributesCreatingBlock value.
	self assert: preview result == page.
	self assert: preview showSelector equals: #gtLiveFor:.
	self assert: preview height equals: LepiterConstants defaultPreviewHeight.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtPageStylingWithLabel [
	<gtExample>
	| page buttons |
	page := LeDatabase gtBook pageNamed: 'Rules for styling replies'.
	buttons := {'{{gtPage:Rules for styling replies|label=Styling rules|db='
				, page database uuidString , '}}'.
			'{{gtPage:id=' , page uid asString36 , '|label=Styling rules|db='
				, page database uuidString , '}}'}
			collect: [ :source | 
				| button |
				button := self pageButtonFor: source.
				self assert: button label asString equals: 'Styling rules'.
				self assert: button isEnabled.
				button ].
	^ buttons
]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> gtPictureReferenceIsNotStyled [
	"Chat messages have no picture snippets, so picture references stay plain text"

	<gtExample>
	<return: #BlText>
	| source text |
	source := 'See {{gtPictureReference:picture3}} here'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self hasAttribute: GtButtonAttribute in: text) not.
	self assert: (self hasAttribute: BrTextHideAttribute in: text) not.
	^ text

]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> gtSymbolStyling [
	"gtSymbol annotations are styled like in Lepiter snippets (LeSymbolAnnotationStyler): a #symbol button"

	<gtExample>
	<return: #BlText>
	| source text |
	source := 'Override {{gtSymbol:asString}} here'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self hasAttribute: GtButtonAttribute in: text).
	self assert: (self hasAttribute: BrTextHideAttribute in: text).
	self
		assert: (((text attributesAt: (source indexOf: ${)) select: [ :each | each isKindOf: BlTextForegroundAttribute ])
				anySatisfy: [ :each | each paint = BrGlamorousColors textMarkupColor ]).
	^ text

]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> gtSymbolStylingWithoutSymbol [
	<gtExample>
	<return: #BlText>
	| source text |
	source := 'Override {{gtSymbol:}} here'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self hasAttribute: GtButtonAttribute in: text) not.
	^ text

]

{ #category : #examples }
GtLMessageStylerExamples >> gtViewPragmaStyling [
	<gtExample>
	<return: #BlText>
	| code text start end pragmaRange hasHide hasExpand hasButton |
	code := 'asdads 

{{gtPragma:gtView}}'.
	text := code asRopedText.
	GtLMessageStyler new
		style: text.
	start := code indexOfSubCollection: '{{gtPragma:gtView}}'.
	end := start + '{{gtPragma:gtView}}' size.
	pragmaRange := start to: end.
	hasHide := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ] ].
	hasExpand := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: GtCachedTextExpandButtonAttribute ] ].
	hasButton := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: GtButtonAttribute ] ].
	self assert: hasHide.
	self assert: hasExpand not.
	self assert: hasButton.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtViewPragmaStylingWithoutFullName [
	<gtExample>
	<return: #BlText>
	| code text start end pragmaRange hasHide hasExpand hasButton buttonColor buttonAttribute button |
	code := '123  

{{gtPragma:gtVi}}'.
	text := code asRopedText.
	GtLMessageStyler new style: text.
	start := code indexOfSubCollection: '{{gtPragma:gtVi}}'.
	end := start + '{{gtPragma:gtVi}}' size.
	pragmaRange := start to: end.
	hasHide := pragmaRange
			anySatisfy: [ :index | 
				(text attributesAt: index)
					anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ] ].
	self assert: hasHide.
	hasExpand := pragmaRange
			anySatisfy: [ :index | 
				(text attributesAt: index)
					anySatisfy: [ :attribute | attribute isKindOf: GtCachedTextExpandButtonAttribute ] ].
	self assert: hasExpand not.
	buttonAttribute := (text attributesAt: start) detect: [ :a | a isKindOf: GtButtonAttribute ]
			ifNone: [ self assert: false ].
	button := (buttonAttribute instVarNamed: 'stencilBuilder') build.
	buttonColor := (button userData at: #brickLook) defaultColor.
	self assert: buttonColor equals: BrGlamorousColors linkWithErrorColor.
	^ text
]

{ #category : #private }
GtLMessageStylerExamples >> hasAttribute: aClass in: aText [
	^ (1 to: aText size)
		anySatisfy: [ :index | (aText attributesAt: index) anySatisfy: [ :each | each isKindOf: aClass ] ]

]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> headerWithSymbolAnnotation [
	<gtExample>
	<return: #BlText>
	| source text |
	source := '# Header {{gtSymbol:asString}}'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self hasAttribute: GtButtonAttribute in: text).
	^ text

]

{ #category : #private }
GtLMessageStylerExamples >> inlineButtonLabelsAndPositionsIn: aText [
	| buttons |
	buttons := OrderedCollection new.
	aText
		findAttributesSuchThat: [ :each | each isKindOf: GtButtonAttribute ]
		indicesDo: [ :start :end :attribute | 
			self assert: start equals: end.
			buttons
				add: {attribute stencil build label asString.
						end} ].
	^ buttons asArray
]

{ #category : #'examples - markdown' }
GtLMessageStylerExamples >> inlineCodeDelimitersAreHiddenInitially [
	<gtExample>
	<return: #BlText>
	| source text delimiterIndices |
	source := '`some code`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 2)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontFamilyAttribute ]).
	delimiterIndices := (1 to: 1) , (text size - 1 + 1 to: text size).
	delimiterIndices
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | 
							(attribute isKindOf: BrTextAdornmentDynamicAttribute)
								and: [ attribute shouldReplace ] ])
				description: 'Markdown delimiter at position ' , index asString
						, ' should be hidden immediately after styling' ].
	(2 to: text size - 1)
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | 
							(attribute isKindOf: BrTextAdornmentDynamicAttribute)
								and: [ attribute shouldReplace ] ]) not ].
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineCodeReferenceButtons [
	<gtExample>
	<return: #BlText>
	| source text |
	source := 'Inspect `Point` and `` asString ``.'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{'Point'.
					(source findString: 'Point') + 5}.
				{'#asString'.
					text size - 1}}.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineCodeReferenceButtonsOpenTools [
	<gtExample>
	| source editor scripter buttons openedTools |
	source := '`Point` `asString` `Point class>>#x:y:`'.
	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection;
			hExact: 800;
			vFitContent;
			text: (GtLMessageStyler new privateStyle: source asRopedText);
			yourself.
	scripter := BlScripter new element: editor.
	buttons := (editor query // BrButton) all.
	self
		assert: (buttons collect: [ :button | button label asString ]) asArray
		equals: #('Point' '#asString' 'Point class>>#x:y:').

	openedTools := OrderedCollection new.
	buttons
		with: #(inlineClassButton inlineSymbolButton inlineMethodButton)
		do: [ :button :id | 
			button id: id.
			button
				when: GtPhlowObjectToSpawn
				do: [ :event | 
					openedTools add: event tool.
					event consumed: true ].
			scripter clickStep: [ :step | step // id ] ].
	self
		assert: (openedTools collect: #class) asArray
		equals: {GtClassCoderTool.
				GtPhlowCompositeTool.
				GtMethodCoderTool}.
	self assert: openedTools first observedClass equals: Point.
	self assert: (openedTools second object isKindOf: GtSearchReferencesFilter).
	self assert: openedTools second object object equals: #asString.
	self assert: openedTools third compiledMethod selector equals: #x:y:.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineCodeWithoutReferenceButtons [
	<gtExample>
	<return: #BlText>
	| source text |
	source := '`GtUnknownInlineReferenceClass` `Point new` `42` '
			, '`Object>>#gtUnknownInlineReferenceSelector` `_Point>>#size` '
			, '`Object>>#asString:invalid` `See Object>>#asString`' , String lf
			, String lf , '```text' , String lf , 'Object>>#asString' , String lf , '```'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self inlineButtonLabelsAndPositionsIn: text) isEmpty.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineDirectoryPathOpensFileReference [
	<gtExample>
	| path source text editor scripter openedTool |
	path := '.' asFileReference asAbsolute fullName.
	source := 'Open `' , path , '`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{path.
					source size}}.

	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection;
			hExact: 800;
			vFitContent;
			text: text;
			yourself.
	scripter := BlScripter new element: editor.
	(editor query // BrButton) all first
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			openedTool := event tool.
			event consumed: true ].
	scripter clickStep: [ :step | step // BrButton ].
	self assert: (openedTool isKindOf: GtInspectorTool).
	self assert: openedTool object equals: path asFileReference.
	self assert: openedTool object isDirectory.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineDotOpensWorkingDirectory [
	<gtExample>
	| source text attribute button scripter tool |
	source := '`.`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{'.'.
					source size}}.
	attribute := (text attributesAt: text size)
			detect: [ :each | each isKindOf: GtButtonAttribute ].
	button := attribute stencil build.
	scripter := BlScripter new element: button.
	button
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			tool := event tool.
			event consumed: true ].
	scripter clickStep: [ :step | step label: 'Open the working directory' ].
	self assert: (tool isKindOf: GtInspectorTool).
	self assert: tool object equals: FileSystem workingDirectory asAbsolute.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineFilePathOpensFileReference [
	<gtExample>
	| file path source text editor scripter openedTool |
	file := FileReference newTempFilePrefix: 'gt inline ... file ' suffix: '.txt'.
	[ file writeStreamDo: [ :stream | stream nextPutAll: 'Example file' ].
	path := file fullName.
	source := 'Open `` ' , path , ' ``'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{path.
					source size}}.
	self
		assert: ((text attributesAt: source size)
				anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ]).

	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection;
			hExact: 800;
			vFitContent;
			text: text;
			yourself.
	scripter := BlScripter new element: editor.
	(editor query // BrButton) all first
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			openedTool := event tool.
			event consumed: true ].
	scripter clickStep: [ :step | step // BrButton ].
	self assert: (openedTool isKindOf: GtInspectorTool).
	self assert: openedTool object equals: file asAbsolute.
	^ scripter ] ensure: [ file ensureDelete ]
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineHomeShorthandOpensHome [
	<gtExample>
	| home scripter |
	home := FileLocator home asFileReference asAbsolute.
	{'~'.
		'~' , home fileSystem delimiter asString}
		do: [ :path | 
			| source text attribute button tool |
			source := '`' , path , '`'.
			text := GtLMessageStyler new privateStyle: source asRopedText.
			self
				assert: (self inlineButtonLabelsAndPositionsIn: text)
				equals: {{path.
							source size}}.
			attribute := (text attributesAt: text size)
					detect: [ :each | each isKindOf: GtButtonAttribute ].
			button := attribute stencil build.
			scripter := BlScripter new element: button.
			button
				when: GtPhlowObjectToSpawn
				do: [ :event | 
					tool := event tool.
					event consumed: true ].
			scripter clickStep: [ :step | step label: 'Open the home directory' ].
			self assert: (tool isKindOf: GtInspectorTool).
			self assert: tool object equals: home ].
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineMethodReferenceButtons [
	<gtExample>
	<return: #BlText>
	| references source text lastPosition |
	references := #('Point class>>#x:y:' 'Array>>at:put:' 'SmallInteger>>#+').
	source := '`' , references first , '` and `` ' , references second
			, ' `` and `' , references third , '`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	lastPosition := 2 + references first size.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{'Point class>>#x:y:'.
					lastPosition}.
				{'Object>>#at:put:'.
					lastPosition + ' and `` ' size + references second size + ' ``' size}.
				{'SmallInteger>>#+'.
					text size}}.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineMissingFilePathStaysVisible [
	<gtExample>
	<return: #BlText>
	| file source text |
	file := FileReference
			newTempFilePrefix: 'gt-missing-inline-file-'
			suffix: '.txt'.
	source := '`' , file fullName , '`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: (self inlineButtonLabelsAndPositionsIn: text) isEmpty.
	self
		assert: ((text attributesAt: 2)
				anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ]) not.
	self assert: text asString equals: source.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineReferenceMarkupFollowsCursor [
	<gtExample>
	| source text editor scripter reference markupRange isHidden checkButton |
	reference := '`` Point ``'.
	source := 'Before ' , reference , ' after.'.
	markupRange := 8 to: 7 + reference size.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			hExact: 800;
			vFitContent;
			text: text;
			yourself.
	scripter := BlScripter new element: editor.
	isHidden := [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ] ].
	checkButton := [ :label | 
		scripter
			assertStep: [ :step | 
				step label: label.
				step
					satisfies: [ :element | 
						((element query // BrButton) all collect: [ :button | button label asString ])
							asArray = #('Point') ] ] ].

	self
		assert: (self inlineButtonLabelsAndPositionsIn: text)
		equals: {{'Point'.
					markupRange last}}.
	self assert: (markupRange allSatisfy: isHidden).
	checkButton value: 'The button is visible while the markup is hidden'.
	editor editor moveCursorTo: markupRange first - 2.
	self assert: (markupRange anySatisfy: isHidden) not.
	checkButton value: 'The button is visible after the closing backtick'.
	editor editor moveCursorTo: text size.
	self assert: (markupRange allSatisfy: isHidden).
	checkButton value: 'The button stays visible when the markup hides again'.
	self assert: text asString equals: source.
	^ scripter
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineReferenceParserIsReused [
	<gtExample>
	| styler parser first second |
	styler := GtLMessageStyler new.
	styler privateStyle: 'Plain Markdown' asRopedText.
	self assert: (styler instVarNamed: #inlineReferenceParser) isNil.

	first := styler privateStyle: '`Point`' asRopedText.
	parser := styler instVarNamed: #inlineReferenceParser.
	self assert: parser class equals: GtLInlineCodeReferenceParser.
	self assert: parser isOptimized.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: first)
		equals: {{'Point'.
					first size}}.

	second := styler privateStyle: 'Inspect `` asString ``.' asRopedText.
	self assert: (styler instVarNamed: #inlineReferenceParser) == parser.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: second)
		equals: {{'#asString'.
					second size - 1}}.
	self
		assert: (self inlineButtonLabelsAndPositionsIn: first)
		equals: {{'Point'.
					first size}}.
	^ parser
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineSmalltalkStylesValidSyntax [
	<gtExample>
	<return: #BlText>
	| source text numberColor |
	source := '` 1 + 2 ` and `1 + (`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	numberColor := BlTheme default editor pharoNumberLiteralForeground.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 3)
				anySatisfy: [ :attribute | 
					(attribute isKindOf: BlTextForegroundAttribute)
						and: [ attribute paint = numberColor ] ]).
	self
		assert: ((text attributesAt: 16)
				anySatisfy: [ :attribute | attribute isKindOf: BlTextForegroundAttribute ])
				not.
	self assert: (self inlineButtonLabelsAndPositionsIn: text) isEmpty.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> inlineUnresolvedMethodReferencesUsePharoStyling [
	<gtExample>
	<return: #BlText>
	| firstPrefix secondPrefix source text symbolPositions color |
	firstPrefix := '`Object>>'.
	secondPrefix := '`GtUnknownInlineReferenceClass>>'.
	source := firstPrefix , '#gtUnknownInlineReferenceSelector` and '
			, secondPrefix , '#size`'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	symbolPositions := {firstPrefix size + 1.
			text size - 'size`' size}.
	color := BlTheme default editor pharoSymbolLiteralForeground.
	symbolPositions
		do: [ :position | 
			self
				assert: ((text attributesAt: position)
						anySatisfy: [ :attribute | (attribute isKindOf: BlTextForegroundAttribute) and: [ attribute paint = color ] ]).
			self
				assert: ((text attributesAt: position)
						anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ]) not ].
	self assert: (self inlineButtonLabelsAndPositionsIn: text) isEmpty.
	self assert: text asString equals: source.
	^ text
]

{ #category : #'examples - markdown' }
GtLMessageStylerExamples >> italicDelimitersAreHiddenInitially [
	<gtExample>
	<return: #BlText>
	| source text delimiterIndices |
	source := '*something*'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self
		assert: ((text attributesAt: 2)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontItalicAttribute ]).
	delimiterIndices := (1 to: 1) , (text size - 1 + 1 to: text size).
	delimiterIndices
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | attribute isKindOf: BrTextAdornmentDynamicAttribute ])
				description: 'Markdown delimiter at position ' , index asString
						, ' should be hidden immediately after styling' ].
	(2 to: text size - 1)
		do: [ :index | 
			self
				assert: ((text attributesAt: index)
						anySatisfy: [ :attribute | attribute isKindOf: BrTextAdornmentDynamicAttribute ])
						not ].
	^ text
]

{ #category : #private }
GtLMessageStylerExamples >> pageButtonFor: source [
	| text attribute |
	text := source asRopedText.
	GtLMessageStyler new style: text.
	attribute := (text attributesAt: 1)
			detect: [ :each | each isKindOf: GtButtonAttribute ].
	^ attribute stencil build
]

{ #category : #'examples - annotations' }
GtLMessageStylerExamples >> unknownAnnotationIsNotStyled [
	<gtExample>
	<return: #BlText>
	| source text |
	source := 'a {{gtFoo:bar}} and {{gtClass:}} b'.
	text := GtLMessageStyler new privateStyle: source asRopedText.
	self assert: text asString equals: source.
	self assert: (self hasAttribute: GtButtonAttribute in: text) not.
	^ text

]
