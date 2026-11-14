"
Scripted transport for Codex retry examples.
"
Class {
	#name : #GtLOpenAiCodexRetryExampleClient,
	#superclass : #GtLOpenAiCodexClient,
	#instVars : [
		'responses',
		'attempts',
		'refreshes',
		'closedClients'
	],
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #accessing }
GtLOpenAiCodexRetryExampleClient >> attempts [
	^ attempts
]

{ #category : #accessing }
GtLOpenAiCodexRetryExampleClient >> httpClients [
	^ closedClients
]

{ #category : #initialization }
GtLOpenAiCodexRetryExampleClient >> initialize [
	super initialize.
	attempts := 0.
	refreshes := 0
]

{ #category : #requests }
GtLOpenAiCodexRetryExampleClient >> newStreamingHttpClient [
	| http |
	http := GtLOpenAiCodexRetryExampleHttpClient new
			scriptedResponse: responses next;
			yourself.
	closedClients add: http.
	^ http
]

{ #category : #requests }
GtLOpenAiCodexRetryExampleClient >> postOnce: aPath withEntity: anEntity [
	| response |
	attempts := attempts + 1.
	closedClients ifNotNil: [ ^ super postOnce: aPath withEntity: anEntity ].
	response := responses next.
	response isSuccess ifFalse: [ (ZnHttpUnsuccessful response: response) signal ].
	^ response
]

{ #category : #private }
GtLOpenAiCodexRetryExampleClient >> refreshCredential [
	refreshes := refreshes + 1
]

{ #category : #accessing }
GtLOpenAiCodexRetryExampleClient >> refreshes [
	^ refreshes
]

{ #category : #accessing }
GtLOpenAiCodexRetryExampleClient >> responses: aCollection [
	responses := aCollection readStream
]

{ #category : #private }
GtLOpenAiCodexRetryExampleClient >> retryCurrentUnixTime [
	^ 1000
]

{ #category : #initialization }
GtLOpenAiCodexRetryExampleClient >> useStreamingTransport [
	closedClients := OrderedCollection new
]
