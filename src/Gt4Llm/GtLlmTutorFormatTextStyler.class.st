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
GtLlmTutorFormatTextStyler >> styleFixIt: aCodeNode [
	| location hoverMarker hoverAttribute fixItAttribute |
	location := aCodeNode stopPosition.
	hoverMarker := GtFixItMarkerAttribute new.
	hoverAttribute := BlTextHighlightAttribute
			paint: BrGlamorousColors paleErrorBackgroundColor.
	fixItAttribute := GtFixItAttribute new
			label: 'Create format component';
			hoverMarker: hoverMarker;
			hoverAttribute: hoverAttribute;
			placeholderAlignment: #alignMiddle;
			fixItActions: (MessageSend receiver: self selector: #halt);
			yourself.
	hoverMarker fixItAttribute: fixItAttribute.
	text
		attributes: {fixItAttribute}
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
	(tutor formatComponentNamed: aCodeNode code value allButFirst allButLast)
		ifNil: [ self styleFixIt: aCodeNode ]
]
