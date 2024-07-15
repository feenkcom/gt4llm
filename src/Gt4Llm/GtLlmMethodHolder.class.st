Class {
	#name : #GtLlmMethodHolder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'method',
		'announcer'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #announcer }
GtLlmMethodHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmMethodHolder >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self method ];
		view: #gtSourceCodeFor:
]

{ #category : #accessing }
GtLlmMethodHolder >> method [
	^ method
]

{ #category : #accessing }
GtLlmMethodHolder >> method: anObject [
	method := anObject
]

{ #category : #accessing }
GtLlmMethodHolder >> serialize [
	^ '```smalltalk-method
' , self method methodClass asString
		, '
' , self method sourceCode
		, '
```'
]
