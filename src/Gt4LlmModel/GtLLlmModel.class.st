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
GtLLlmModel >> availableModels [

	^ (((self endpointAt: 'availableModels')
		resultWithClient: client model: self)
			at: 'models')
				groupedBy: [ :model | model at: 'name' ]
]

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
GtLLlmModel >> modelDetails [

	^ (self endpointAt: 'modelDetails')
		resultWithClient: client model: self
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
GtLLlmModel >> newEndpointContext [

	^ GtLEndpointContext new
		model: self;
		provider: provider;
		chat: provider chat.
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
GtLLlmModel >> providerVersion [

	^ (self endpointAt: 'providerVersion')
		resultWithClient: client
]

{ #category : #accessing }
GtLLlmModel >> runningModels [

	^ (self endpointAt: 'runningModels')
		resultWithClient: client model: self
]

{ #category : #accessing }
GtLLlmModel >> userMessageEndpoint [

	^ userMessageEndpoint ifNil: [ userMessageEndpoint := self endpointAt: 'userMessage' ]
]
