"
Examples for styling LLM messages with pragma annotations.
"
Class {
	#name : #GtLMessageStylerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

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
