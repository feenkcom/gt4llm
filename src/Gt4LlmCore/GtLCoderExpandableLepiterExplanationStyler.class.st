Class {
	#name : #GtLCoderExpandableLepiterExplanationStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'Gt4LlmCore-UI'
}

{ #category : #private }
GtLCoderExpandableLepiterExplanationStyler >> isNonEmptyLiteralStringNode: nameNode [
	^ nameNode isLiteral
		and: [ nameNode literalValue isString
			and: [ nameNode literalValue notEmpty ] ]
]

{ #category : #private }
GtLCoderExpandableLepiterExplanationStyler >> stylePageNameInStringMessage: aMessageNode inLepiterBase: aLepiterBase [
	| pageName anExpanderAttribute |
	pageName := aMessageNode arguments first.

	(self isNonEmptyLiteralStringNode: pageName) ifFalse: [ ^ self ].

	self
		attribute: (GtCompletionStrategyAttribute new
				strategy: (GtLLepiterPagesCompletionStrategy new
						database: aLepiterBase))
		from: pageName value startPosition
		to: pageName value stopPosition.

	(aLepiterBase hasPageNamed: pageName literalValue asString)
		ifFalse: [ ^ self ].

	anExpanderAttribute := BrGlamorousTriangleExpanderTextAttribute new
			id: GtSourceCoderEmbeddedExpanderToggleId;
			attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
					beAppend;
					stencil: [ | page |
						page := aLepiterBase pageNamed: pageName literalValue asString.
						LePageToolContentTreeElement new
							pageViewModel: page asContentUIModel;
							hMatchParent;
							vExact: 300;
							addAptitude: BrShadowAptitude new + BrGlamorousWithVerticalResizerAptitude new beBottom;
							background: Color white;
							margin: (BlInsets all: 10) ] ].

	self
		attribute: anExpanderAttribute
		from: pageName value stopPosition
		to: pageName value stopPosition
]

{ #category : #private }
GtLCoderExpandableLepiterExplanationStyler >> styleSameStrings: aStringLiteralNodel [
	| aStringMarker aStringHighlightAttribute theStringOccurences |
	
	aStringMarker := BrTextInvisibleMarkerAttribute new.
	aStringHighlightAttribute := (GtPharoDynamicHighlightAttribute paint: BrGlamorousColors neutralBackgroundColor).

	theStringOccurences := OrderedCollection new.
	
	aStringLiteralNodel topParent 
		allNodesOfType: aStringLiteralNodel class
		do: [ :aNode |
			aNode string = aStringLiteralNodel string 
				ifTrue: [ theStringOccurences add: aNode ] ].
		
	theStringOccurences size <= 1
		ifTrue: [ ^ self ].

	theStringOccurences do: [ :eachNode | 
		(text
			from: eachNode startPosition
			to: eachNode stopPosition)
				attribute: aStringMarker;
				onCursorEnter: [ :aTextEditor :anEvent | 
					aTextEditor text
						findAttribute: aStringMarker
						indicesDo: [ :aVariableStart :aVariableEnd |
							aTextEditor text
								attribute: aStringHighlightAttribute
								from: aVariableStart
								to: aVariableEnd ] ]
				leave: [ :aTextEditor :anEvent |
					aTextEditor text removeAttribute: aStringHighlightAttribute ] ] 
]

{ #category : #visiting }
GtLCoderExpandableLepiterExplanationStyler >> styleStringAsLepiter: aMessageNode [
	| lepiterString lepiterText |
	lepiterString := aMessageNode arguments first.
	(self isNonEmptyLiteralStringNode: lepiterString) ifFalse: [ ^ self ].
	lepiterText := text
			from: lepiterString startPosition + 1
			to: lepiterString stopPosition - 1.
	GtLMessageStyler new style: lepiterText.
	(text from: lepiterString startPosition to: lepiterString stopPosition)
		foreground: self theme editor pharoStringLiteralForeground.
	self
		attribute: (GtCompletionStrategyAttribute new
				strategy: LeCompletionStrategy new)
		from: lepiterString startPosition
		to: lepiterString stopPosition
]

{ #category : #visiting }
GtLCoderExpandableLepiterExplanationStyler >> visitMessage: aMessageNode [
	super visitMessage: aMessageNode.

	(#(gtPageExplanation: pageExplanation:) includes: aMessageNode selector)
		ifTrue: [ self
				stylePageNameInStringMessage: aMessageNode
				inLepiterBase: LeDatabase gtBook ].
	(#(markdownPage:) includes: aMessageNode selector)
		ifTrue: [ self
				stylePageNameInStringMessage: aMessageNode
				inLepiterBase: LeDatabasesRegistry defaultLogicalDatabase ].
	(#(sendMarkdown: markdown:) includes: aMessageNode selector)
		ifTrue: [ self styleStringAsLepiter: aMessageNode ]
]

{ #category : #visiting }
GtLCoderExpandableLepiterExplanationStyler >> visitStringLiteral: aStringLiteralNodel [
	super visitStringLiteral: aStringLiteralNodel.
	
	(self isNonEmptyLiteralStringNode: aStringLiteralNodel)
		ifFalse: [ ^ self ].
		
	self styleSameStrings: aStringLiteralNodel.
]
