Class {
	#name : #GtLLlmModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'provider',
		'endpoints',
		'namedEndpoints',
		'client',
		'userMessageEndpoint',
		'options'
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
	options := Dictionary new.
]

{ #category : #accessing }
GtLLlmModel >> name [
	^ name
]

{ #category : #accessing }
GtLLlmModel >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLLlmModel >> newCreateEmbeddingsCommand [
	| endpoint command |

	endpoint := self endpointAt: 'createEmbeddings'.
	command := endpoint commandClass new.
	command context
		model: self;
		provider: provider;
		endpoint: endpoint;
		command: command.
	^ command
]

{ #category : #'as yet unclassified' }
GtLLlmModel >> newCreateModelCommand [
	| endpoint command |

	endpoint := self endpointAt: 'createModel'.
	command := endpoint commandClass new.
	command context
		model: self;
		provider: provider;
		endpoint: endpoint;
		command: command.
	^ command
]

{ #category : #accessing }
GtLLlmModel >> optionAt: optionName [

	^ options at: optionName
]

{ #category : #accessing }
GtLLlmModel >> optionAt: optionName put: anObject [

	options at: optionName put: anObject
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
