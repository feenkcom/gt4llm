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
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #generated }
GtLlmMessageStyler class >> textLinkButtonPadding: additionalPadding margin: additionalMargin [
	"Answer a button used for in-text links in Lepiter.
	This sets a common font, size, color and style for the button"

	^ self textLinkButtonPadding: additionalPadding margin: additionalMargin valid: true
]

{ #category : #generated }
GtLlmMessageStyler class >> textLinkButtonPadding: additionalPadding margin: additionalMargin valid: isValid [
	"Answer a button used for in-text links in Lepiter.
	This sets a common font, size, color and style for the button"
	| color button |

	button := BrButton new.
	button connector beVisualSource.

	color := isValid 
		ifTrue: [ BrGlamorousColors linkColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ].

	button 
		addAptitude: (BrGlamorousButtonLabelAptitude new 
			defaultColor: color;
			hoveredColor: color muchDarker);
		placeholderAlignment: #alignBottom;
		padding: (BlInsets top: 0 left: 0 bottom: -1 right: 0) + additionalPadding;
		margin: (BlInsets top: 0 left: 0 bottom: 0 right: 0) + additionalMargin;
		icon: BrGlamorousVectorIcons inspect;
		beNoneSize;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent. ].
	^ button
]

{ #category : #accessing }
GtLlmMessageStyler >> elements [
	^ elements
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

{ #category : #generated }
GtLlmMessageStyler >> isValidLink: urlString [
	"Answer a boolean indicating whether the supplied string is valid.
	There's no restriction on what schemes are supported as we don't know what schemes the OS supports, so any scheme other than file:// will answer true.
	If the scheme is file:// or no scheme is provided, answer a boolean based on the files existence."
	<return: #Boolean>

	^ (self resolveUrl: urlString) isValid
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
GtLlmMessageStyler >> resolveUrl: aUrlString [
	"For file urls, resolve against the database directory or root directory, and allow file urls of the form 'file://path/to/image.png' (the host is missing), with the same resolution"
	<return: #GtUrlStringUtility>
	| rootDir |
	
	rootDir :=  FileLocator workingDirectory resolve.
	^ GtUrlStringUtility new
		rootDirectory: rootDir;
		urlString: aUrlString.
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
GtLlmMessageStyler >> styleBold: aBoldNode [
	(self text from: aBoldNode startPosition to: aBoldNode stopPosition)
		attributes: {BlFontWeightAttribute bold}.
	self
		styleAutoHiding:
			(aBoldNode leftStars first startPosition to: aBoldNode leftStars last stopPosition)
		and:
			(aBoldNode rightStars first startPosition to: aBoldNode rightStars last stopPosition)
		whenOutside: aBoldNode sourceInterval
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
GtLlmMessageStyler >> styleExternalLink: anExternalLink [
	| linkText |
	linkText := self text
			from: anExternalLink startPosition
			to: anExternalLink stopPosition.

	(anExternalLink isKindOf: LeExternalUrlLinkNode) ifTrue: [
			linkText italic foreground: BrGlamorousColors textMarkupColor.
			^ self
	].

	self styleLinkText: linkText valid: (self isValidLink: anExternalLink url).
	self styleAutoHiding: anExternalLink sourceInterval text: linkText.
	self styleExternalLinkButton: anExternalLink text: linkText
]

{ #category : #generated }
GtLlmMessageStyler >> styleExternalLinkButton: aLink text: aSubText [
	"Append a button to the supplied link text.
	If the link is defined (not empty), the button opens the link.
	If the link is empty, open a dialog allowing the user to select a file"

	aLink url
		ifEmpty: [ self styleFileSelection: aLink text: aSubText ]
		ifNotEmpty: [ self styleOpenExternalLinkButton: aLink text: aSubText ]
]

{ #category : #generated }
GtLlmMessageStyler >> styleFileSelection: aLink text: aSubText [
	"Append a button to the supplied link text that opens the link"

	aSubText appendingAdornment: [ :aTBrTextEditorTextualPiece :anEditorElement | 
		| selectStencil selectDropdown |

		selectStencil := LeFileSelectStencil new 
			label: aLink label;
			tooltip: 'Import file from disk';
			extent: 600@400;
			textEditorPiece: aTBrTextEditorTextualPiece;
			visitor: self;
			subText: aSubText.
		selectDropdown := selectStencil asElement.
		selectDropdown aptitude - BrGlamorousButtonExteriorAptitude.
		selectDropdown ]
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
GtLlmMessageStyler >> styleItalic: anItalicNode [
	(self text
		from: anItalicNode startPosition
		to: anItalicNode stopPosition)
			italic.

	self
		styleAutoHiding: anItalicNode leftStar sourceInterval
		and: anItalicNode rightStar sourceInterval
		whenOutside: anItalicNode sourceInterval
]

{ #category : #generated }
GtLlmMessageStyler >> styleLinkText: aSubText valid: hasValidTarget [
	"Set the colour of the source markup text"
	| aColor |
	aColor := hasValidTarget
		ifTrue: [ BrGlamorousColors textMarkupColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ].
	
	aSubText foreground: aColor.
]

{ #category : #accessing }
GtLlmMessageStyler >> styleName: aClassAnnotation [
	| nameNode aLinkColor |

	(nameNode := aClassAnnotation nameNode)
		ifNil: [ ^ self ].

	aLinkColor := nameNode isDefined
		ifTrue: [ BrGlamorousColors textMarkupColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ].

	(self text from: nameNode startPosition to: nameNode stopPosition)
		foreground: aLinkColor
]

{ #category : #generated }
GtLlmMessageStyler >> styleOpenExternalImage: aLink text: aSubText [
	| anImageURL attribute pictureContainer widget |
	anImageURL := (self resolveUrl: aLink url) url asString.

	attribute := BrTextAdornmentDynamicAttribute new
			beAppend;
			withCache: self elements key: anImageURL;
			stencil: [ pictureContainer := BlElement new
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ];
						layout: BlLinearLayout vertical;
						padding: (BlInsets
								top: 5
								left: 7
								bottom: 5
								right: 5);
						yourself.

				widget := (BrAsyncFileWidget new url: anImageURL)
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical exact: 300 ].
				pictureContainer addChild: widget as: #imageElement.
				pictureContainer
					addAptitude: (BrGlamorousWithVerticalResizerAptitude new beBottom
							resizerDo: [ :theResizer | 
								theResizer
									when: BlResizerResizedEvent
									do: [ :anEvent | 
										pictureContainer
											childWithId: #imageElement
											ifFound: [ :anImageElement | (BrResizerElementLength exact: anEvent extent y) adjustHeightFor: anImageElement ]
											ifNone: [  ] ] ]) ].

	aSubText attribute: attribute
]

{ #category : #generated }
GtLlmMessageStyler >> styleOpenExternalLinkButton: aLink text: aSubText [
	"Append a button to the supplied link text that opens the link"

	aSubText
		appendingAdornment: [ :aTBrTextEditorTextualPiece :anEditorElement | 
			| button oldLook |
			button := self class
					textLinkButtonPadding: aTBrTextEditorTextualPiece wordPadding
					margin: aTBrTextEditorTextualPiece wordMargin.
			oldLook := button aptitude.
			button
				removeAptitude: oldLook;
				addAptitude: (BrGlamorousButtonLabelAndIconAptitude new defaultColor: oldLook defaultColor);
				addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: aLink url asString asRopedText);
				icon: BrGlamorousVectorIcons link;
				label: aLink displayLabel;
				action: [ :aButton | 
					| urlUtility |
					urlUtility := self resolveUrl: aLink url.
					urlUtility isFile
						ifTrue: [ aButton phlow spawnObject: urlUtility asFileReference ]
						ifFalse: [ WebBrowser openOn: urlUtility asString ] ].
			button ]
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
GtLlmMessageStyler >> visitBold: aBoldNode [
	self styleBold: aBoldNode.
	^ self visitContent: aBoldNode
]

{ #category : #accessing }
GtLlmMessageStyler >> visitClassAnnotation: aClassAnnotation [
	self visitAnnotation: aClassAnnotation.
	self styleName: aClassAnnotation.
	self
		styleButton: aClassAnnotation
		withTool: [ GtClassCoderTool forClass: aClassAnnotation imageObject ].
	self
		styleExpandingObject: aClassAnnotation
		withDefault: LepiterConstants defaultClassShowSelector
]

{ #category : #generated }
GtLlmMessageStyler >> visitCodeBlock: aCodeNode [
	(aCodeNode language isNotNil and: [ aCodeNode isForSmalltalk ])
		ifTrue: [ self styleSmalltalkCodeBlock: aCodeNode ].
	(self text from: aCodeNode startPosition to: aCodeNode stopPosition)
		glamorousCodeFont.
	(self text
		from: aCodeNode begin startPosition
		to: aCodeNode beginWithLanguageStopPosition)
		attributes: {BlTextForegroundAttribute paint: Color lightGray}.
	(self text from: aCodeNode end startPosition to: aCodeNode end stopPosition)
		attributes: {BlTextForegroundAttribute paint: Color lightGray}.
	(self text
		from: aCodeNode beginWithLanguageStopPosition + 1
		to: aCodeNode end startPosition - 1)
		attributes: {BlTextHighlightAttribute paint: BrGlamorousColors neutralBackgroundColor}.
	aCodeNode isForSmalltalk
		ifTrue: [ self text
				attributes: {BrTextHideAttribute new}
				from: aCodeNode begin startPosition
				to: aCodeNode end stopPosition.
			(text from: aCodeNode end stopPosition + 1 to: aCodeNode end stopPosition + 1)
				attributes: {BrTextAdornmentDynamicAttribute new
							beAppend;
							stencil: [ GtPharoSnippetCoder new
									forSource: (self text
											from: aCodeNode beginWithLanguageStopPosition + 1
											to: aCodeNode end startPosition - 1) asString;
									subscribeToSystem;
									asExpandedOnlyElement ]} ].
	^ self visitContent: aCodeNode
]

{ #category : #generated }
GtLlmMessageStyler >> visitExternalImageLink: anExternalLink [ 
	| linkText url validLink |

	linkText := self text
		from: anExternalLink startPosition
		to: anExternalLink stopPosition.
	url := anExternalLink url.
	validLink := self isValidLink: url.
	self styleLinkText: linkText valid: validLink.
	self visitExternalLink: anExternalLink.
	self styleAutoHiding: anExternalLink sourceInterval text: linkText.
	anExternalLink url
		ifEmpty: [ self styleFileSelection: anExternalLink text: linkText ]
		ifNotEmpty: [ self styleOpenExternalImage: anExternalLink text: linkText ].

]

{ #category : #generated }
GtLlmMessageStyler >> visitExternalLabelUrlLink: anExternalLabelUrlLink [
	self visitExternalLink: anExternalLabelUrlLink.
	self styleExternalLink: anExternalLabelUrlLink
]

{ #category : #generated }
GtLlmMessageStyler >> visitExternalUrlLink: anExternalUrlLink [
	self visitExternalLink: anExternalUrlLink.
	self styleExternalLink: anExternalUrlLink
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
GtLlmMessageStyler >> visitItalic: anItalicNode [
	self styleItalic: anItalicNode.
	^ self visitContent: anItalicNode
]

{ #category : #accessing }
GtLlmMessageStyler >> visitMethodAnnotation: aMethodAnnotation [
	self visitAnnotation: aMethodAnnotation.
	self styleName: aMethodAnnotation.
	self
		styleButton: aMethodAnnotation
		withTool: [ GtMethodCoderTool compiledMethod: aMethodAnnotation imageObject ].
	self
		styleExpandingObject: aMethodAnnotation
		withDefault: LepiterConstants defaultMethodShowSelector
]
