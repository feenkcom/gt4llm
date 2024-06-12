Class {
	#name : #GtLlmInstanceHolder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'object',
		'announcer'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmInstanceHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmInstanceHolder >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self object ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmInstanceHolder >> object [
	^ object
]

{ #category : #accessing }
GtLlmInstanceHolder >> object: anObject [
	object := anObject
]

{ #category : #'as yet unclassified' }
GtLlmInstanceHolder >> serialize [
	^ '```object
'
		, (GtLlmInspectorSummarizer new summarizeWithoutViews: self object) summaryString
		, '
```'
]
