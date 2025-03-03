Class {
	#name : #GtLlmTutorFormatTextStyler,
	#superclass : #BlTextStyler,
	#traits : 'TLeAnnotationParseNodeVisitor + (TLeContentNodeVisitor - {#visitAnnotation:})',
	#classTraits : 'TLeAnnotationParseNodeVisitor classTrait + TLeContentNodeVisitor classTrait',
	#instVars : [
		'tutor'
	],
	#category : #'Gt4Llm-GToolkit'
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
									content: [ self tutor
											formatComponentMethodCoderForSource: 'gt' , aCodeNode code value allButFirst allButLast
													, 'FormatDescription
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: ''' , aCodeNode code value allButFirst allButLast
													, ''';
		priority: 1;
		format: '''';
		example: ''''' ]);
					label: 'Create tutor format';
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
GtLlmTutorFormatTextStyler >> visitInlineCode: aCodeNode [
	(tutor formatNamed: aCodeNode code value allButFirst allButLast)
		ifNil: [ self styleUnknownFormatComponent: aCodeNode ]
]
