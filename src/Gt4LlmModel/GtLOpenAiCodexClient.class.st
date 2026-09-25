Class {
	#name : #GtLOpenAiCodexClient,
	#superclass : #GtLModelClient,
	#instVars : [
		'credential'
	],
	#category : #Gt4LlmModel
}

{ #category : #defaults }
GtLOpenAiCodexClient class >> defaultBaseUrl [
	^ 'https://chatgpt.com' asZnUrl
]

{ #category : #accessing }
GtLOpenAiCodexClient >> credential [
	^ credential
]

{ #category : #accessing }
GtLOpenAiCodexClient >> credential: aCredential [
	credential := aCredential
]

{ #category : #private }
GtLOpenAiCodexClient >> currentCredential [
	credential ifNil: [ self error: 'No ChatGPT Codex OAuth credential is configured' ].
	^ credential
]

{ #category : #initialization }
GtLOpenAiCodexClient >> initialize [
	super initialize.
	credential := nil
]

{ #category : #private }
GtLOpenAiCodexClient >> newStreamingHttpClient [
	| http currentCredential |
	currentCredential := self currentCredential.
	http := ZnClient new.
	http timeout: 1200; streaming: true.
	http setBearerAuthentication: currentCredential accessToken.
	http headerAt: 'chatgpt-account-id' put: currentCredential accountId.
	http headerAt: 'originator' put: 'gtoolkit'.
	http headerAt: 'OpenAI-Beta' put: 'responses=experimental'.
	http headerAt: 'accept' put: 'text/event-stream'.
	^ http
]

{ #category : #requests }
GtLOpenAiCodexClient >> post: aPath withEntity: anEntity [
	^ [ self postOnce: aPath withEntity: anEntity ]
		on: ZnHttpUnsuccessful
		do: [ :error |
			error response status = 401 ifFalse: [ error pass ].
			credential := self currentCredential refresh.
			self postOnce: aPath withEntity: anEntity ]
]

{ #category : #private }
GtLOpenAiCodexClient >> postOnce: aPath withEntity: anEntity [
	| http responseBody accumulator requestResponse |
	http := self newStreamingHttpClient.
	http url: self baseUrl / aPath.
	http entity: (ZnEntity json: (NeoJSONWriter toString: anEntity)).
	responseBody := http post.
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume: (self responseStringFrom: responseBody).
	requestResponse := self addHistoryRequestResponse: http.
	requestResponse result: accumulator result.
	^ requestResponse
]

{ #category : #private }
GtLOpenAiCodexClient >> responseStringFrom: aResponseBody [
	aResponseBody isString ifTrue: [ ^ aResponseBody ].
	(aResponseBody isKindOf: ByteArray) ifTrue: [ ^ aResponseBody utf8Decoded ].
	(aResponseBody respondsTo: #upToEnd) ifTrue:
		[ ^ self responseStringFrom: aResponseBody upToEnd ].
	self error: 'Unexpected Codex response body: ', aResponseBody class name
]
