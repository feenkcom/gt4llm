Class {
	#name : #GtLlmTutorFormatTextStyler,
	#superclass : #BlTextStyler,
	#traits : 'TLeAnnotationParseNodeVisitor + (TLeContentNodeVisitor - {#visitAnnotation:})',
	#classTraits : 'TLeAnnotationParseNodeVisitor classTrait + TLeContentNodeVisitor classTrait',
	#instVars : [
		'tutor'
	],
	#category : #'Gt4Llm-Stylers'
}

{ #category : #'as yet unclassified' }
GtLlmTutorFormatTextStyler >> privateStyle: aText [ 
	<return: #BlText>
	| ast |
	text := aText.
	ast := LeParser parse: aText asString.
	self accept: ast.
	^ aText
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatTextStyler >> styleUnknownFormatComponent: aCodeNode [
	| location hoverMarker hoverAttribute buttonAttribute |
	location := aCodeNode stopPosition.
	hoverMarker := GtFixItMarkerAttribute new.
	hoverAttribute := BlTextHighlightAttribute
			paint: BrGlamorousColors paleErrorBackgroundColor.
	buttonAttribute := GtButtonAttribute new
			beAppend;
			stencil: [ BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
							+ (BrGlamorousWithDropdownAptitude
									handle: [ BrButton new
											aptitude: BrGlamorousButtonWithIconAptitude;
											icon: BrGlamorousVectorIcons repair;
											beTinySize ]
									content: [ self tutorFormatCoderFor: aCodeNode ]);
					label: 'Create format component';
					beTinySize;
					margin: (BlInsets left: 5);
					icon: BrGlamorousVectorIcons repair;
					when: BlMouseEnterEvent
						do: [ :anEvent | 
							text
								findAttribute: hoverMarker
								indicesDo: [ :aHighlightStart :aHighlightEnd | (text from: aHighlightStart to: aHighlightEnd) attribute: hoverAttribute ] ];
					when: BlMouseLeaveEvent
						do: [ :anEvent | text clearAttributes: [ :each | each == hoverAttribute ] ] ].
	hoverMarker fixItAttribute: buttonAttribute.
	text
		attributes: {buttonAttribute}
		from: location
		to: location.
	(text from: aCodeNode startPosition to: aCodeNode stopPosition)
		attribute: hoverMarker;
		onCursorEnter: [ :aTextEditor :anEvent :aFromIndex :aToIndex | 
				aTextEditor text
					findAttribute: hoverMarker
					indicesDo: [ :aHighlightStart :aHighlightEnd | 
						(aTextEditor text from: aHighlightStart to: aHighlightEnd)
							attribute: hoverAttribute ] ]
			leave: [ :aTextEditor :anEvent :aFromIndex :aToIndex | aTextEditor text clearAttributes: [ :e | e == hoverAttribute ] ]
]

{ #category : #accessing }
GtLlmTutorFormatTextStyler >> tutor [
	^ tutor
]

{ #category : #accessing }
GtLlmTutorFormatTextStyler >> tutor: anObject [
	tutor := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatTextStyler >> tutorFormatCoderFor: aCodeNode [
	| methodCoder |
	methodCoder := GtPharoNewMethodCoderElement new
			behavior: self tutor class;
			onMethodCoderSaved: [ :anAnnouncement | 
				| method formatComponent |
				method := anAnnouncement method.
				formatComponent := self tutor perform: method selector.
				self tutor ensureComponentIsReferenced: formatComponent.
				self tutor initializeFormat.
				self tutor recomputeActions.
				methodCoder phlow fireToolUpdateWish.
				methodCoder fireEvent: BrDropdownHideWish new ];
			ensureMethodCoderViewModel.
	methodCoder pharoMethodCoderViewModel coderModel
		currentSourceString: 'gt' , aCodeNode code value allButFirst allButLast
				, 'FormatComponent
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: ''' , aCodeNode code value allButFirst allButLast
				, ''';
		priority: 1;
		format: '''';
		example: '''''.
	^ methodCoder
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatTextStyler >> visitInlineCode: aCodeNode [
	(tutor formatComponentNamed: aCodeNode code value allButFirst allButLast)
		ifNil: [ self styleUnknownFormatComponent: aCodeNode ]
]
