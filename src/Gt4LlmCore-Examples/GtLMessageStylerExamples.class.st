"
Examples for styling LLM messages with pragma annotations.
"
Class {
	#name : #GtLMessageStylerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

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
	source := '``something``'.
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
	string36 := storage addNewObject: 'Hello World' reason: 'test'.
	text := ('\{\{gtObject:id={1}|height=400\}\}' format: {string36})
				asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]]).
	^text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithLabelError [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: Object new reason: 'error test'.
	text := ('\{\{gtObject:id={1}|label=#thisWillFail\}\}' format: {string36})
				asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]]).
	^text
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
	id1 := storage addNewObject: (BlElement new size: 200 @ 100)
				reason: 'element'.
	id2 := storage addNewObject: 'Hello World' reason: 'string'.
	text := ('See \{\{gtObject:id={1}\}\} and \{\{gtObject:id={2}\}\}'
				format: 
					{id1.
					id2}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	self
		assert: ((1 to: text size) count: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]])
				>= 2.
	^text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithShowAndHeight [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: ((BlElement new)
						size: 200 @ 100;
						background: Color blue)
				reason: 'test'.
	text := ('\{\{gtObject:id={1}|show=#gtViewsFor:|height=300|expanded=true\}\}'
				format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]]).
	^text
]

{ #category : #running }
GtLMessageStylerExamples >> gtObjectStylingWithShowError [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: Object new reason: 'error test'.
	text := ('\{\{gtObject:id={1}|show=#nonExistentView:|expanded=true\}\}'
				format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]]).
	^text
]

{ #category : #running }
GtLMessageStylerExamples >> gtObjectStylingWithShowOnly [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: 'Hello World' reason: 'test'.
	text := ('\{\{gtObject:id={1}|show=#gtItemsFor:\}\}' format: {string36})
				asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]]).
	^text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtObjectStylingWithSingleObject [
	<gtExample>
	<return: #BlText>
	| storage string36 text styler range |
	storage := GtLObjectStorage new.
	string36 := storage addNewObject: ((BlElement new)
						size: 200 @ 100;
						background: Color blue)
				reason: 'test'.
	text := ('\{\{gtObject:id={1}\}\}' format: {string36}) asRopedText.
	styler := GtLMessageStyler new objectRegistry: storage.
	styler privateStyle: text.
	range := 1 to: text size.
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: BlTextForegroundAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: GtButtonAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i)
						anySatisfy: [:a | a isKindOf: GtCachedTextExpandButtonAttribute]]).
	self
		assert: (range anySatisfy: 
					[:i |
					(text attributesAt: i) anySatisfy: [:a | a isKindOf: BrTextHideAttribute]]).
	^text
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

{ #category : #'examples - markdown' }
GtLMessageStylerExamples >> inlineCodeDelimitersAreHiddenInitially [
	<gtExample>
	<return: #BlText>
	| source text delimiterIndices |
	source := '`something`'.
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
