Class {
	#name : #GtLStringDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'string'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - serializing' }
GtLStringDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #String>
	^ self string asString
]

{ #category : #accessing }
GtLStringDomainObject >> string [
	^ string
]

{ #category : #accessing }
GtLStringDomainObject >> string: anObject [
	string := anObject
]
