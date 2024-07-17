Class {
	#name : #GtLlmMethodHolder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'method',
		'announcer',
		'chat'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #announcer }
GtLlmMethodHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmMethodHolder >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmMethodHolder >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmMethodHolder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 1;
		actionButtonIcon: BrGlamorousVectorIcons browse
			tooltip: 'Browse method'
			action: [ (GtCoderElement forMethod: self method) openInPager maximized ];
		stencil: [ ((GtPharoMethodCoder forMethod: self method) openAITutorChat: self chat)
				asExpandedOnlyElement vFitContentLimited ]
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
