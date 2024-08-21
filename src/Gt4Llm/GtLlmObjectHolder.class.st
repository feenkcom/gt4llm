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
	^ aView explicit
		title: 'Views';
		priority: 1;
		stencil: [ GtInspector new removePlayground object: self object ]
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
	^ 'Object'
		-> (GtLlmInspectorSummarizer new summarizeWithoutMarkup: self object) summaryString
]
