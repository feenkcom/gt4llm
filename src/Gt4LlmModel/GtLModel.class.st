Class {
	#name : #GtLModel,
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
GtLModel >> availableModels [

	^ (((self endpointAt: 'availableModels')
		resultWithClient: client model: self)
			at: 'models')
				groupedBy: [ :model | model at: 'name' ]
]

{ #category : #accessing }
GtLModel >> client [
	^ client
]

{ #category : #accessing }
GtLModel >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLModel >> endpointAt: endpointName [

	^ endpoints at: endpointName
]

{ #category : #accessing }
GtLModel >> endpointAt: endpointName put: endpoint [

	endpoints at: endpointName put: endpoint
]

{ #category : #initialization }
GtLModel >> initialize [

	super initialize.
	endpoints := Dictionary new.
]

{ #category : #accessing }
GtLModel >> modelDetails [

	^ (self endpointAt: 'modelDetails')
		resultWithClient: client model: self
]

{ #category : #accessing }
GtLModel >> name [
	^ name
]

{ #category : #accessing }
GtLModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLModel >> newEndpointContext [

	^ GtLEndpointContext new
		model: self;
		provider: provider;
		chat: provider chat.
]

{ #category : #accessing }
GtLModel >> provider [
	^ provider
]

{ #category : #accessing }
GtLModel >> provider: aGtLModelProvider [

	provider := aGtLModelProvider.
	provider model: self.
]

{ #category : #accessing }
GtLModel >> providerVersion [

	^ (self endpointAt: 'providerVersion')
		resultWithClient: client
]

{ #category : #accessing }
GtLModel >> runningModels [

	^ (self endpointAt: 'runningModels')
		resultWithClient: client model: self
]

{ #category : #accessing }
GtLModel >> userMessageEndpoint [

	^ userMessageEndpoint ifNil: [ userMessageEndpoint := self endpointAt: 'userMessage' ]
]
