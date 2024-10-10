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
GtLlmValueHolder >> contentValue [
	^ self content
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ (content gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
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
	^ name -> self contentValue
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> updateContent: aValue [
	content := aValue
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> value [
	^ self content
]
