Class {
	#name : #GtLAnthropicClientZincBuilder,
	#superclass : #Object,
	#instVars : [
		'apiKey',
		'version'
	],
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #accessing }
GtLAnthropicClientZincBuilder >> apiKey [
	^ apiKey
]

{ #category : #'api - initialization' }
GtLAnthropicClientZincBuilder >> apiKey: anObject [
	apiKey := anObject
]

{ #category : #'api - instantiation' }
GtLAnthropicClientZincBuilder >> create [
	"Create a new Zinc client to communicate with the Anthropic server.
	Responses are read with STONJSON: plain dictionaries with String keys, as the response readers expect
	(#forJsonREST alone would read NeoJSONObjects, whose keys are Symbols)"

	| aClient |
	aClient := self newBasicClient.
	aClient forJsonREST.
	aClient contentReader: [ :anEntity | STONJSON fromString: anEntity contents ].
	aClient timeout: 1200.
	aClient headerAt: 'x-api-key' put: apiKey.
	aClient headerAt: 'anthropic-version' put: self version.
	aClient headerAt: 'anthropic-beta' put: 'structured-outputs-2025-11-13'.
	^ aClient
]

{ #category : #'private - instance creation' }
GtLAnthropicClientZincBuilder >> newBasicClient [
	^ ZnClient new
]

{ #category : #accessing }
GtLAnthropicClientZincBuilder >> version [
	^ version
]

{ #category : #accessing }
GtLAnthropicClientZincBuilder >> version: anObject [
	version := anObject
]
