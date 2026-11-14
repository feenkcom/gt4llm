Class {
	#name : #GtLOpenAiCodexClient,
	#superclass : #GtLModelClient,
	#instVars : [
		'credential',
		'retryPolicy'
	],
	#category : #'Gt4LlmModel-Codex'
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
	credential isExpired ifTrue: [ credential := credential refresh ].
	^ credential
]

{ #category : #initialization }
GtLOpenAiCodexClient >> initialize [
	super initialize.
	credential := nil
]

{ #category : #private }
GtLOpenAiCodexClient >> newStreamingHttpClient [
	| currentCredential http |
	currentCredential := self currentCredential.
	http := ZnClient new.
	http
		timeout: 1200;
		streaming: true.
	http setBearerAuthentication: currentCredential accessToken.
	http headerAt: 'chatgpt-account-id' put: currentCredential accountId.
	http headerAt: 'originator' put: 'gtoolkit'.
	http headerAt: 'OpenAI-Beta' put: 'responses=experimental'.
	http headerAt: 'accept' put: 'text/event-stream'.
	^ http
]

{ #category : #requests }
GtLOpenAiCodexClient >> post: aPath withEntity: anEntity [
	| refreshed |
	refreshed := false.
	^ self retryPolicy
		execute: [ [ self postOnce: aPath withEntity: anEntity ]
				on: ZnHttpUnsuccessful
				do: [ :error | 
					(error response status = 401 and: [ refreshed not ]) ifFalse: [ error pass ].
					refreshed := true.
					self refreshCredential.
					self postOnce: aPath withEntity: anEntity ] ]
		on: ZnHttpUnsuccessful
		retryIf: [ :error | error response status = 429 ]
		minimumDelay: [ :error | self retryDelayForResponse: error response ]
]

{ #category : #requests }
GtLOpenAiCodexClient >> postOnce: aPath withEntity: anEntity [
	| http responseBody accumulator requestResponse |
	http := self newStreamingHttpClient.
	^ [  "Materialize streaming errors before closing, including non-JSON bodies."http
		enforceHttpSuccess: false.
	http url: self baseUrl / aPath.
	http entity: (ZnEntity json: (NeoJSONWriter toString: anEntity)).
	responseBody := self responseStringFrom: http post.
	http response isSuccess
		ifFalse: [ http response entity: (ZnStringEntity text: responseBody).
			self addHistoryRequestResponse: http.	"Handlers run before ensure unwinds. Close now, before a retry sleeps."
			http close.
			(ZnHttpUnsuccessful response: http response) signal ].
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume: responseBody.
	http response
		entity: (ZnStringEntity json: (NeoJSONWriter toString: accumulator result)).
	requestResponse := self addHistoryRequestResponse: http.
	requestResponse result: accumulator result.
	requestResponse ] ensure: [ http close ]
]

{ #category : #private }
GtLOpenAiCodexClient >> refreshCredential [
	credential := self currentCredential refresh
]

{ #category : #private }
GtLOpenAiCodexClient >> responseStringFrom: aResponseBody [
	aResponseBody isString ifTrue: [ ^ aResponseBody ].
	(aResponseBody isKindOf: ByteArray) ifTrue: [ ^ aResponseBody utf8Decoded ].
	(aResponseBody respondsTo: #upToEnd) ifTrue:
		[ ^ self responseStringFrom: aResponseBody upToEnd ].
	self error: 'Unexpected Codex response body: ', aResponseBody class name
]

{ #category : #'private - retrying' }
GtLOpenAiCodexClient >> retryCurrentUnixTime [
	^ DateAndTime now asUnixTime
]

{ #category : #'private - retrying' }
GtLOpenAiCodexClient >> retryDelayForResponse: aResponse [
	"Use explicit reset information, not limit_window_minutes (a window length,
	not a remaining wait). Keep the full error including its type in history.
	Malformed or absent metadata falls back to exponential backoff."

	| minimum body details seconds reset header |
	minimum := 0.
	header := aResponse headers at: 'Retry-After' ifAbsent: [ nil ].
	seconds := self retrySecondsFrom: header.
	seconds ifNotNil: [ minimum := minimum max: seconds ].
	body := [ NeoJSONReader fromString: aResponse entity contents ]
			on: Error
			do: [ :error | nil ].
	(body isKindOf: Dictionary) ifFalse: [ ^ minimum ].
	details := body at: 'error' ifAbsent: [ nil ].
	(details isKindOf: Dictionary) ifFalse: [ ^ minimum ].
	seconds := self
			retrySecondsFrom: (details at: 'resets_in_seconds' ifAbsent: [ nil ]).
	seconds ifNotNil: [ ^ minimum max: seconds ].
	reset := self retrySecondsFrom: (details at: 'resets_at' ifAbsent: [ nil ]).
	reset ifNotNil: [ minimum := minimum max: reset - self retryCurrentUnixTime ].
	^ minimum max: 0
]

{ #category : #accessing }
GtLOpenAiCodexClient >> retryPolicy [
	^ retryPolicy ifNil: [ retryPolicy := GtLExponentialBackoff new ]
]

{ #category : #accessing }
GtLOpenAiCodexClient >> retryPolicy: aPolicy [
	retryPolicy := aPolicy
]

{ #category : #'private - retrying' }
GtLOpenAiCodexClient >> retrySecondsFrom: aValue [
	| number stream |
	aValue ifNil: [ ^ nil ].
	number := aValue isNumber
			ifTrue: [ aValue ]
			ifFalse: [ aValue isString
					ifTrue: [ [ stream := aValue trimBoth readStream.
						number := Number readFrom: stream.
						stream atEnd ifTrue: [ number ] ifFalse: [ nil ] ]
							on: Error
							do: [ :error | nil ] ]
					ifFalse: [ nil ] ].
	(number isNumber and: [ number >= 0 and: [ number isInfinite not ] ])
		ifFalse: [ ^ nil ].
	^ number
]
