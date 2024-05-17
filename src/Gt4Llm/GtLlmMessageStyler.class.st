Class {
	#name : #GtLlmMessageStyler,
	#superclass : #BlTextStyler,
	#traits : 'TLeAnnotationParseNodeVisitor + (TLeContentNodeVisitor - {#visitAnnotation:})',
	#classTraits : 'TLeAnnotationParseNodeVisitor classTrait + TLeContentNodeVisitor classTrait',
	#instVars : [
		'executionResults',
		'threadMessageViewModel',
		'lastId',
		'expanded',
		'elements'
	],
	#category : #'Gt4Llm-Stylers'
}

{ #category : #accessing }
GtLlmMessageStyler >> elements [
	^ elements
]

{ #category : #generated }
GtLlmMessageStyler >> evaluateCodeBlock: aCodeBlock expanded: aBoolean from: aButton [
	| aResult position source |
	source := aCodeBlock code source.

	aResult := self threadMessageViewModel codeBlocksExecutor check: aCodeBlock.

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
	"Keys are {{gtClass:SmaCCToken}} that defines a text that was evaluated.
	Items are objects that describe the evaluation result."

	<return: #Dictionary of: #LeEvaluationResult>
	^ executionResults
]

{ #category : #accessing }
GtLlmMessageStyler >> executionResults: anObject [
	executionResults := anObject
]

{ #category : #accessing }
GtLlmMessageStyler >> expanded [
	^ expanded
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
	
	executionResults := Dictionary new.
	lastId := 0.
	elements := Dictionary new.
	expanded := Dictionary new
]

{ #category : #generated }
GtLlmMessageStyler >> isCursorInside: nodeInterval [ 
]

{ #category : #accessing }
GtLlmMessageStyler >> nextUniqueId [
	lastId := lastId + 1.
	^ lastId
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
GtLlmMessageStyler >> styleAutoHiding: leftRange and: rightRange whenOutside: nodeInterval [
	| anAttribute marker1 marker2 cursorAttribute |
	marker1 := BrTextInvisibleMarkerAttribute new.
	marker2 := BrTextInvisibleMarkerAttribute new.
	self text
		attribute: marker1
		from: leftRange first
		to: leftRange last.
	self text
		attribute: marker2
		from: rightRange first
		to: rightRange last.
	anAttribute := BrTextAdornmentDynamicAttribute new
			beReplace;
			stencil: [ :aTBrTextEditorTextualPiece :anEditorElement | #() ].
	cursorAttribute := BrTextCursorAttribute new
			enterAction: [ :aTextEditor | 
				| left right |
				aTextEditor text
					findAttribute: marker1
					indicesDo: [ :start :end | left := start ].
				aTextEditor text
					findAttribute: marker2
					indicesDo: [ :start :end | right := end ].
				(left notNil and: [ right notNil ])
					ifTrue: [ | cursorIndex |
						cursorIndex := aTextEditor cursors first position.
						(cursorIndex between: left - 2 and: right)
							ifTrue: [ aTextEditor text
									clearAttributes: left
									to: right
									if: [ :eachAttribute | eachAttribute == anAttribute ] ] ] ];
			leaveAction: [ :aTextEditor | 
				| left right |
				aTextEditor text
					findAttribute: marker1
					indicesDo: [ :start :end | left := start to: end ].
				aTextEditor text
					findAttribute: marker2
					indicesDo: [ :start :end | right := start to: end ].
				(left notNil and: [ right notNil ])
					ifTrue: [ aTextEditor text
							attributes: {anAttribute}
							from: left first
							to: left last.
						aTextEditor text
							attributes: {anAttribute}
							from: right first
							to: right last ] ].
	self text
		attribute: cursorAttribute
		from: nodeInterval first - 1
		to: nodeInterval last
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
GtLlmMessageStyler >> styleAutoHidingAnnotation: anAnnotation [
	| anAttribute aMarkerAttribute aStartPositionToHide aStopPositionToHide anAnnotationTextToHide aSurroundingTextToRespondToCursor aStartPositionToReactToCursor aStopPositionToReactToCursor |
	anAnnotation isDefined ifFalse: [ ^ self ].

	aStartPositionToHide := anAnnotation parent startPosition max: 1.
	aStopPositionToHide := anAnnotation parent stopPosition min: self text size.
	aStartPositionToReactToCursor := aStartPositionToHide - 2 max: 1.
	aStopPositionToReactToCursor := aStopPositionToHide + 1 min: self text size.

	anAnnotationTextToHide := self text
			from: aStartPositionToHide
			to: aStopPositionToHide.
	aSurroundingTextToRespondToCursor := self text
			from: aStartPositionToReactToCursor
			to: aStopPositionToReactToCursor.

	aMarkerAttribute := BrTextInvisibleMarkerAttribute new.	"so that we will be able to find where to add adornment attribute dynamically"
	anAnnotationTextToHide attribute: aMarkerAttribute.

	anAttribute := BrTextHideAttribute new.

	anAnnotationTextToHide attribute: anAttribute.

	aSurroundingTextToRespondToCursor
		onCursorEnter: [  "we have a reference to the attribute instance. find its interval dynamically":aTextEditor | 
			aTextEditor text
				findAttribute: aMarkerAttribute
				indicesDo: [ :aStart :anEnd | 
					aTextEditor text
						clearAttributes: aStart
						to: anEnd
						if: [ :eachAttribute | eachAttribute == anAttribute ] ] ]
		leave: [ :aTextEditor | 
			aTextEditor text
				findAttribute: aMarkerAttribute
				indicesDo: [ :aStart :anEnd | 
					aTextEditor text
						attribute: anAttribute
						from: aStart
						to: anEnd ] ]
]

{ #category : #accessing }
GtLlmMessageStyler >> styleButton: anAnnotation for: object defaultLabel: aLabelBlock withTool: aBlock [
	"Style the buttons for gtClass and gtMethod annotations"

	| attribute anId |
	anAnnotation isDefined ifFalse: [ ^ self ].

	anId := LeTextSnippetAttributeLabelElementId indexed: self nextUniqueId.

	attribute := GtButtonAttribute new
			beAppend;
			stencil: [ | button label |
				label := object
						ifNil: [ anAnnotation nameNode
								ifNil: [ '' ]
								ifNotNil: [ :name | (name value ifNil: [ name ]) source ] ]
						ifNotNil: [ :obj | 
							anAnnotation labelNode
								ifNil: [ aLabelBlock value: obj ]
								ifNotNil: [ :node | node labelFor: obj ] ].
				button := LeSnippetStylerVisitor
						textLinkButtonPadding: (BlInsets top: 2)
						margin: BlInsets empty.
				button aptitude glamorousCodeFont.
				button
					id: anId;
					beSmallSize;
					label: label;
					action: [ :aButton | aButton phlow spawnTool: (aBlock cull: aButton) ].

				button viewModel
					when: BlClickEvent
					do: [ :anEvent | 
						anEvent modifiers isPrimaryModifier
							ifTrue: [ | aTool aSpace |
								aTool := aBlock cull: button.
								aSpace := BlSpace new.
								aSpace title: self gtDisplayString.
								aSpace icon: aTool icon.
								aSpace extent: 1200 @ 600.
								aSpace root background: Color transparent.
								aSpace
									addChild: (GtPager
											createOn: (GtPagerWrapperElement new
													tool: aTool;
													embellisher: (GtPagerPageEmbellisher new extension: GtPagerPageEmbellisherExtension null))) maximized.
								aSpace withHalos.
								button showSpace: aSpace ] ].
				button viewModel
					when: BlMouseEnterEvent
					do: [ :anEvent | 
						anEvent consumed: true.
						anEvent modifiers isPrimaryModifier
							ifTrue: [ anEvent target mouseCursor: BlCopyCursor new ]
							ifFalse: [ anEvent target mouseCursor: nil ].
						anEvent target requestFocus ].
				button ].

	self text
		attribute: attribute
		from: anAnnotation parent startPosition
		to: anAnnotation parent stopPosition
]

{ #category : #accessing }
GtLlmMessageStyler >> styleButton: anAnnotation for: object withTool: aBlock [
	self
		styleButton: anAnnotation
		for: object
		defaultLabel: #printString
		withTool: aBlock
]

{ #category : #accessing }
GtLlmMessageStyler >> styleButton: anAnnotation withTool: aBlock [
	self
		styleButton: anAnnotation
		for: anAnnotation imageObject
		withTool: aBlock
]

{ #category : #private }
GtLlmMessageStyler >> styleCode: aCodeNode [
	self threadMessageViewModel isAssistantRole ifFalse: [ ^ self ].
	(text from: aCodeNode stopPosition to: aCodeNode stopPosition)
		attributes: {GtButtonAttribute new
					beAppend;
					stencil: [ GtButtonStencil new
							icon: BrGlamorousVectorIcons play;
							tooltip: 'Evaluate';
							action: [ :aWidget :aButtonModel | 
								self
									evaluateCodeBlock: aCodeNode
									expanded: false
									from: aWidget ] ].
				GtButtonAttribute new
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

{ #category : #accessing }
GtLlmMessageStyler >> styleExpandingObject: aClassAnnotation withDefault: aSymbol [
	| cacheKey attribute |
	aClassAnnotation isDefined ifFalse: [ ^ self ].

	cacheKey := aClassAnnotation source.

	attribute := GtCachedTextExpandButtonAttribute new
			isExpanded: (self expanded at: cacheKey ifAbsentPut: [ aClassAnnotation expanded ]);
			attributesCreatingBlock: [ GtResizablePreviewAttribute new
					withCache: self elements key: cacheKey;
					result: aClassAnnotation imageObject;
					showSelector: (aClassAnnotation showSelector ifNil: [ aSymbol ]);
					height: (aClassAnnotation height ifNil: [ LepiterConstants defaultPreviewHeight ]) ];
			onCachingDo: [ :aBoolean :theAttribute | self expanded at: cacheKey put: aBoolean ].

	self text
		attribute: attribute
		from: aClassAnnotation parent startPosition
		to: aClassAnnotation parent stopPosition
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

{ #category : #accessing }
GtLlmMessageStyler >> styleName: aClassAnnotation spawning: aBlock [
	| nameNode aLinkColor |

	(nameNode := aClassAnnotation nameNode)
		ifNil: [ ^ self ].

	aLinkColor := nameNode isDefined
		ifTrue: [ BrGlamorousColors textMarkupColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ].

	(self text from: nameNode startPosition to: nameNode stopPosition)
		foreground: aLinkColor
]

{ #category : #private }
GtLlmMessageStyler >> styleResult: evaluationResult for: aCodeNode [
	| evaluatedCodeAttribute aViewModel |
	aViewModel := threadMessageViewModel checkRunResultViewModelFor: evaluationResult value.
	evaluatedCodeAttribute := GtLlmEvaluatedCodePreviewAttribute new
		checkRunResultViewModel: aViewModel.

	(text from: aCodeNode stopPosition to: aCodeNode stopPosition)
		attributes: {evaluatedCodeAttribute}
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

{ #category : #generated }
GtLlmMessageStyler >> visitAnnotation: anAnnotation [
	self styleAutoHidingAnnotation: anAnnotation.
	^ self visitAnnotationParse: anAnnotation
]

{ #category : #accessing }
GtLlmMessageStyler >> visitClassAnnotation: aClassAnnotation [
	self visitAnnotation: aClassAnnotation.
	self
		styleName: aClassAnnotation
		spawning: [ :anEvent | 
			anEvent target phlow
				spawnTool: (GtClassCoderTool observedClass: aClassAnnotation imageObject) ].
	self
		styleButton: aClassAnnotation
		withTool: [ GtClassCoderTool forClass: aClassAnnotation imageObject ].
	self
		styleExpandingObject: aClassAnnotation
		withDefault: LepiterConstants defaultClassShowSelector
]

{ #category : #generated }
GtLlmMessageStyler >> visitCodeBlock: aCodeNode [
	(aCodeNode language isNotNil
		and: [ aCodeNode isForSmalltalk or: [ aCodeNode isForLanguage: 'smalltalk-method' ] ])
		ifTrue: [ self styleSmalltalkCodeBlock: aCodeNode ].
	(self text from: aCodeNode startPosition to: aCodeNode stopPosition)
		glamorousCodeFont.
	self styleCode: aCodeNode.

	^ self visitContent: aCodeNode
]

{ #category : #generated }
GtLlmMessageStyler >> visitHeader: aHeader [
	self styleHeader: aHeader.
	^ self visitContent: aHeader
]

{ #category : #generated }
GtLlmMessageStyler >> visitInlineCode: aCodeNode [
	| size |
	size := (aCodeNode code source at: 2) = $` ifTrue: [ 2 ] ifFalse: [ 1 ].
	(self text from: aCodeNode startPosition to: aCodeNode stopPosition)
		glamorousCodeFont.
	self
		styleAutoHiding: (aCodeNode startPosition
				to: aCodeNode startPosition + size - 1)
		and: (aCodeNode stopPosition - size + 1 to: aCodeNode stopPosition)
		whenOutside: aCodeNode sourceInterval.
	^ self visitContent: aCodeNode
]

{ #category : #accessing }
GtLlmMessageStyler >> visitMethodAnnotation: aMethodAnnotation [ 
	self visitAnnotation: aMethodAnnotation.
	self
		styleName: aMethodAnnotation
		spawning:
			[ :anEvent | anEvent target phlow spawnObject: aMethodAnnotation imageObject ].
	self
		styleButton: aMethodAnnotation
		withTool: [ GtMethodCoderTool compiledMethod: aMethodAnnotation imageObject ].
	self
		styleExpandingObject: aMethodAnnotation
		withDefault: LepiterConstants defaultMethodShowSelector
]
