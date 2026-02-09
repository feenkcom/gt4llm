Class {
	#name : #GtLMethodsRemovalDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMethodsRemovalDomainObject >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsRemovalDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodsRemovalDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods' put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
