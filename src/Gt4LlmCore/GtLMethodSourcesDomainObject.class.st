Class {
	#name : #GtLMethodSourcesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMethodSourcesDomainObject >> methods [
	^ methods
]

{ #category : #accessing }
GtLMethodSourcesDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodSourcesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods'
			put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
