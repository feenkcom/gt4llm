Class {
	#name : #GtLMethodsSourceDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMethodsSourceDomainObject >> methods [
	^ methods
]

{ #category : #accessing }
GtLMethodsSourceDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodsSourceDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods'
			put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
