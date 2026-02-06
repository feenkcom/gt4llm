Class {
	#name : #GtLLepiterPageContentsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'page'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLLepiterPageContentsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitLepiterPageContentsDomainObject: self
]

{ #category : #accessing }
GtLLepiterPageContentsDomainObject >> page [
	^ page
]

{ #category : #accessing }
GtLLepiterPageContentsDomainObject >> page: anObject [
	page := anObject
]

{ #category : #'api - serializing' }
GtLLepiterPageContentsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	| aString |
	aString := LeJsonV4 uniqueInstance serializePretty: self page.
	^ NeoJSONObject fromString: aString
]

{ #category : #'api - serializing' }
GtLLepiterPageContentsDomainObject >> serializeToOpenAIResponseJsonString [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ LeJsonV4 uniqueInstance serializePretty: self page
]
