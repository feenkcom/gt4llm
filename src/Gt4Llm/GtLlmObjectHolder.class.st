Class {
	#name : #GtLlmObjectHolder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'object',
		'announcer',
		'chat'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #announcer }
GtLlmObjectHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmObjectHolder >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmObjectHolder >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmObjectHolder >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self object ];
		view: ((self object class includesSelector: #gtPreviewFor:)
				ifTrue: [ #gtPreviewFor: ]
				ifFalse: [ #gtLiveFor: ])
]

{ #category : #accessing }
GtLlmObjectHolder >> object [
	^ object
]

{ #category : #accessing }
GtLlmObjectHolder >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLlmObjectHolder >> serialize [
	^ '```object
' , (GtLlmInspectorSummarizer new summarizeWithoutMarkup: self object) summaryString
		, '
```'
]
