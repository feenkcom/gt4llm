Class {
	#name : #GtLlmValueHolder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'name',
		'announcer',
		'chat',
		'content'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #announcer }
GtLlmValueHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmValueHolder >> content [
	^ content
]

{ #category : #accessing }
GtLlmValueHolder >> content: anObject [
	content := anObject
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> gtLiveFor: aView [
	<gtView>
	^ content gtLiveFor: aView
]

{ #category : #accessing }
GtLlmValueHolder >> name [
	^ name
]

{ #category : #accessing }
GtLlmValueHolder >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> serialize [
	^ name -> content
]
