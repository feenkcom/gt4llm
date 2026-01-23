Class {
	#name : #GtLLepiterPageDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'foundPage'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLLepiterPageDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitLepiterPageDomainObject: self
]

{ #category : #accessing }
GtLLepiterPageDomainObject >> foundPage [
	^ foundPage
]

{ #category : #accessing }
GtLLepiterPageDomainObject >> foundPage: aLePage [
	foundPage := aLePage
]

{ #category : #views }
GtLLepiterPageDomainObject >> gtLepiterPageViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ self foundPage ];
		view: #gtLiveFor:
]

{ #category : #'api - serializing' }
GtLLepiterPageDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ LeJsonV4 uniqueInstance serializePretty: self foundPage
]
