Class {
	#name : #GtLLlmModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'provider',
		'endpoints',
		'namedEndpoints',
		'client',
		'userMessageEndpoint'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLLlmModel >> client [
	^ client
]

{ #category : #accessing }
GtLLlmModel >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLLlmModel >> endpointAt: endpointName [

	^ endpoints at: endpointName
]

{ #category : #accessing }
GtLLlmModel >> endpointAt: endpointName put: endpoint [

	endpoints at: endpointName put: endpoint
]

{ #category : #initialization }
GtLLlmModel >> initialize [

	super initialize.
	endpoints := Dictionary new.
]

{ #category : #accessing }
GtLLlmModel >> name [
	^ name
]

{ #category : #accessing }
GtLLlmModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLLlmModel >> provider [
	^ provider
]

{ #category : #accessing }
GtLLlmModel >> provider: aGtLModelProvider [

	provider := aGtLModelProvider.
	provider model: self.
]

{ #category : #accessing }
GtLLlmModel >> userMessageEndpoint [

	^ userMessageEndpoint ifNil: [ userMessageEndpoint := self endpointAt: 'userMessage' ]
]
