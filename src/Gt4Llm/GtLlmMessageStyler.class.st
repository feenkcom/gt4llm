Class {
	#name : #GtLlmMessageStyler,
	#superclass : #BlTextStyler,
	#traits : 'TLeContentNodeVisitor',
	#classTraits : 'TLeContentNodeVisitor classTrait',
	#instVars : [
		'executionResults',
		'threadMessageViewModel'
	],
	#category : #'Gt4Llm-Stylers'
}

{ #category : #generated }
GtLlmMessageStyler >> evaluateCodeBlock: aCodeBlock expanded: aBoolean from: aButton [
	| aResult position source |
	source := aCodeBlock code source.

	aResult := self threadMessageViewModel codeBlockChecker check: source.

	aResult threadMessage: self threadMessageViewModel threadMessage.

	position := source size.
	[ position > 1 and: [ (source at: position) isLineBreak ] ]
		whileTrue: [ position := position - 1 ].
	self executionResults
		at: aCodeBlock code
		put: (LeEvaluationResult new
				value: aResult;
				expanded: aBoolean;
				position: position).
	self threadMessageViewModel requestStyleSourceText.
	aBoolean ifTrue: [ aButton phlow spawnObject: aResult value ]
]

{ #category : #generated }
GtLlmMessageStyler >> evaluateMethodBlock: aCodeBlock expanded: aBoolean from: aButton [ 
	| aResult position source aMethod |
	source := aCodeBlock code source.
	aMethod := self methodCodeBlock: aCodeBlock.

	aResult := aMethod addToSystem.
	
	aResult threadMessage: self threadMessageViewModel threadMessage.

	position := source size.
	[ position > 1 and: [ (source at: position) isLineBreak ] ]
		whileTrue: [ position := position - 1 ].
	self executionResults
		at: aCodeBlock code
		put: (LeEvaluationResult new
				value: aResult;
				expanded: aBoolean;
				position: position).
	self threadMessageViewModel requestStyleSourceText.
	aBoolean ifTrue: [ aButton phlow spawnObject: aResult value ]
]

{ #category : #accessing }
GtLlmMessageStyler >> executionResults [
	^ executionResults
]

{ #category : #accessing }
GtLlmMessageStyler >> executionResults: anObject [
	executionResults := anObject
]

{ #category : #generated }
GtLlmMessageStyler >> fontSizeForHeadingLevel: aHeadingLevel [
	"Compute the relative (em) font size for a text with a given heading level (1-6)"
	<return: #BlFontSize>
	"
	# Heading 1 => font size * 1.5
	# Heading 2 => font size * 1.4
	# Heading 3 => font size * 1.3
	# Heading 4 => font size * 1.2
	# Heading 5 => font size * 1.1
	# Heading 6 => font size * 1.0
	"
	| aFontSizeIncrement aMaxAmountOfHeadingLevels anExtraFontSize |
	
	aFontSizeIncrement := 0.1.
	aMaxAmountOfHeadingLevels := 6.

	anExtraFontSize := (aMaxAmountOfHeadingLevels - aHeadingLevel max: 0) * aFontSizeIncrement.

	^ (1.0 + anExtraFontSize) fontEm
]

{ #category : #accessing }
GtLlmMessageStyler >> initialize [
	super initialize.
	
	executionResults := Dictionary new
]

{ #category : #generated }
GtLlmMessageStyler >> methodCodeBlock: aCodeBlock [
	| source |
	source := aCodeBlock code source trim.
	^ GtLlmMessageMethod new
		methodClass: source lines first asClass;
		methodBody: (Character lf join: source lines allButFirst)
]

{ #category : #accessing }
GtLlmMessageStyler >> privateStyle: aText [ 
	<return: #BlText>
	| ast |
	text := aText.
	ast := LeParser parse: aText asString.
	self accept: ast.
	^ aText
]

{ #category : #generated }
GtLlmMessageStyler >> styleAutoHiding: anInterval text: aSubText [
	| anAttribute aMarkerAttribute cursorAttribute |
	
	aMarkerAttribute := BrTextInvisibleMarkerAttribute new.

	"so that we will be able to find where to add adornment attribute dynamically"
	aSubText attribute: aMarkerAttribute.

	anAttribute := BrTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ :aTBrTextEditorTextualPiece :anEditorElement | #() ].

	aSubText attribute: anAttribute.

	cursorAttribute := BrTextCursorAttribute new
			enterAction: [ :aTextEditor | 
			"we have a reference to the attribute instance. find its interval dynamically"
			aTextEditor text
				findAttribute: aMarkerAttribute
				indicesDo: [ :aStart :anEnd | | cursorIndex |
					cursorIndex := aTextEditor cursors first position.
					"and now that we know valid attribute indices we can work with them"
					(cursorIndex between: aStart-2 and: anEnd) ifTrue:
						[ aTextEditor text
							clearAttributes: aStart
							to: anEnd 
							if: [ :eachAttribute | eachAttribute == anAttribute ] ] ] ];

		leaveAction: [ :aTextEditor |
			aTextEditor text
				findAttribute: aMarkerAttribute
				indicesDo: [ :aStart :anEnd |
					aTextEditor text
						attribute: anAttribute  
						from: aStart
						to: anEnd ] ].
	self text
		attribute: cursorAttribute
		from: anInterval first - 1
		to: anInterval last
]

{ #category : #generated }
GtLlmMessageStyler >> styleHeader: aHeaderNode [
	aHeaderNode parts isEmpty ifTrue: [ ^ self ].

	(self text from: aHeaderNode startPosition to: aHeaderNode stopPosition)
		bold;
		fontSize: (self fontSizeForHeadingLevel: aHeaderNode headerLevel).
	self
		styleAutoHiding: (aHeaderNode startPosition
				to: (aHeaderNode numberSigns last stopPosition min: aHeaderNode stopPosition))
		text: (self text
				from: aHeaderNode startPosition
				to: (aHeaderNode numberSigns last stopPosition min: aHeaderNode stopPosition)).
	aHeaderNode startPosition > 1
		ifTrue: [ (self text from: aHeaderNode startPosition to: aHeaderNode stopPosition)
				paragraphMargin: (BlInsets
						top: (5 - aHeaderNode numberSigns size max: 1) * 10
						left: 0
						bottom: 5
						right: 0) ]
]

{ #category : #generated }
GtLlmMessageStyler >> styleResult: result for: aCodeNode [
	| evaluatedCodeAttribute |
	evaluatedCodeAttribute := GtPlaygroundEvaluatedCodeButtonAttribute new
			result: result value;
			action: [ :aButton :anEvent | aButton phlow spawnObject: result value ].
	(text
		from: aCodeNode code startPosition + result position - 1
		to: aCodeNode code startPosition + result position - 1)
		attributes: {evaluatedCodeAttribute}
]

{ #category : #private }
GtLlmMessageStyler >> styleSmalltalkCode: aCodeNode [
	aCodeNode isForSmalltalk ifFalse: [ ^ self ].
	(text from: aCodeNode stopPosition to: aCodeNode stopPosition)
		attributes: {GtButtonAttribute new
					beAppend;
					stencil: [ GtButtonStencil new
							icon: BrGlamorousVectorIcons playinspect;
							tooltip: 'Inspect';
							action: [ :aWidget :aButtonModel | 
								self
									evaluateCodeBlock: aCodeNode
									expanded: true
									from: aWidget ] ]}.
	self executionResults
		at: aCodeNode code
		ifPresent: [ :result | self styleResult: result for: aCodeNode ]
]

{ #category : #generated }
GtLlmMessageStyler >> styleSmalltalkCodeBlock: aCodeNode [ 
	| aStyler |
	aStyler := BrRBTextStyler new.
	aStyler workspace: self variableBindings.
	aStyler
		style:
			(text
				from: aCodeNode code startPosition
				to: aCodeNode code stopPosition)
]

{ #category : #private }
GtLlmMessageStyler >> styleSmalltalkMethod: aCodeNode [
	| methodCodeBlock |
	(aCodeNode isForLanguage: 'smalltalk-method') ifFalse: [ ^ self ].
	methodCodeBlock := self methodCodeBlock: aCodeNode.
	methodCodeBlock methodExists
		ifFalse: [ (text from: aCodeNode stopPosition to: aCodeNode stopPosition)
				attributes: {GtButtonAttribute new
							beAppend;
							stencil: [ GtButtonStencil new
									icon: BrGlamorousVectorIcons playinspect;
									tooltip: 'Add method';
									action: [ :aWidget :aButtonModel | 
										self
											evaluateMethodBlock: aCodeNode
											expanded: true
											from: aWidget ] ]}.
			self executionResults
				at: aCodeNode code
				ifPresent: [ :result | self styleResult: result for: aCodeNode ] ]
]

{ #category : #generated }
GtLlmMessageStyler >> text [
	^ text
]

{ #category : #accessing }
GtLlmMessageStyler >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #accessing }
GtLlmMessageStyler >> threadMessageViewModel: anObject [
	threadMessageViewModel := anObject
]

{ #category : #generated }
GtLlmMessageStyler >> variableBindings [
	^ GtSharedVariablesBindings new
]

{ #category : #'as yet unclassified' }
GtLlmMessageStyler >> visitClassAnnotation: aLeClassAnnotationNode [ 
	"self shouldBeImplemented."
]

{ #category : #generated }
GtLlmMessageStyler >> visitCodeBlock: aCodeNode [
	(aCodeNode isForSmalltalk or: [ aCodeNode isForLanguage: 'smalltalk-method' ])
		ifTrue: [ self styleSmalltalkCodeBlock: aCodeNode ].
	(self text from: aCodeNode startPosition to: aCodeNode stopPosition)
		glamorousCodeFont.
	self styleSmalltalkCode: aCodeNode.
	self styleSmalltalkMethod: aCodeNode.

	^ self visitContent: aCodeNode
]

{ #category : #generated }
GtLlmMessageStyler >> visitHeader: aHeader [
	self styleHeader: aHeader.
	^ self visitContent: aHeader
]
