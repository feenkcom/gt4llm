Class {
	#name : #GtLPhlowViewDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'phlowView'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #views }
GtLPhlowViewDomainObject >> gtLivePhlowViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Live view';
		priority: 10;
		object: [ phlowView ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> phlowView [
	^ phlowView
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> phlowView: anObject [
	phlowView := anObject
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToAnthropicResponseOutput [
	^ super serializeToAnthropicResponseOutput
		, (self serializeToOpenAIResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToAnthropicResponseOutput ]).
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	<return: #NeoJSONObject>
	| data |
	
	data := NeoJSONObject new
		at: #viewTitle put: phlowView title;
		at: #priority put: phlowView priority;
		yourself.
	
	^ data
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToOpenAIResponseImages [
	^ {GtLPrimitiveImageData fromElement:  phlowView asElement}
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToOpenAIResponseOutput [
	^ super serializeToOpenAIResponseOutput
		, (self serializeToOpenAIResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToOpenAIResponseOutput ])
]
