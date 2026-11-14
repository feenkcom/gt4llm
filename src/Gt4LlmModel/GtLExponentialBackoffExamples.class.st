"
Deterministic examples for exponential backoff and Codex rate limiting. No network requests or real waits.
"
Class {
	#name : #GtLExponentialBackoffExamples,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #examples }
GtLExponentialBackoffExamples >> codexPassesOtherErrorsAndExhaustion [
	<gtExample>
	| client waits final caught |
	#(400 401 403 500 429)
		do: [ :status | 
			client := GtLOpenAiCodexRetryExampleClient new.
			waits := OrderedCollection new.
			client
				retryPolicy: (GtLExponentialBackoff new
						maxRetries: 1;
						randomBlock: [ 0 ];
						waitBlock: [ :seconds | waits add: seconds ];
						yourself).
			final := self response: status body: '{}'.
			client
				responses: {final.
						final}.
			caught := nil.
			[ client post: 'responses' withEntity: Dictionary new ]
				on: ZnHttpUnsuccessful
				do: [ :error | caught := error ].
			self assert: caught response == final.
			self
				assert: client attempts
				equals: ((#(401 429) includes: status) ifTrue: [ 2 ] ifFalse: [ 1 ]).
			self assert: waits size equals: (status = 429 ifTrue: [ 1 ] ifFalse: [ 0 ]) ].
	^ client
]

{ #category : #examples }
GtLExponentialBackoffExamples >> codexResetFallbacks [
	<gtExample>
	| client response |
	client := GtLOpenAiCodexRetryExampleClient new.
	response := self response: 429 body: '{"error":{"resets_at":1010}}'.
	self assert: (client retryDelayForResponse: response) equals: 10.
	response headers at: 'Retry-After' put: '20'.
	self assert: (client retryDelayForResponse: response) equals: 20.
	response := self response: 429 body: '{"error":{"resets_at":900}}'.
	self assert: (client retryDelayForResponse: response) equals: 0.
	#('not json' '{"error":null}' '{"error":{"resets_in_seconds":-1}}' '{"error":{"resets_in_seconds":"bad","limit_window_minutes":300}}')
		do: [ :body | 
			self
				assert: (client retryDelayForResponse: (self response: 429 body: body))
				equals: 0 ].
	^ client
]

{ #category : #examples }
GtLExponentialBackoffExamples >> codexRespectsUsageResetAndRefreshesOnce [
	<gtExample>
	| client waits success result |
	waits := OrderedCollection new.
	success := self response: 200 body: '{}'.
	client := GtLOpenAiCodexRetryExampleClient new.
	client
		retryPolicy: (GtLExponentialBackoff new
				randomBlock: [ 1 ];
				waitBlock: [ :seconds | waits add: seconds ];
				yourself).
	client
		responses: {self response: 401 body: '{}'.
				self
					response: 429
					body: '{"error":{"type":"usage_limit_reached","limit_window_minutes":300,"resets_at":1794574653,"resets_in_seconds":13339}}'.
				success}.
	result := client post: 'responses' withEntity: Dictionary new.
	self assert: result == success.
	self assert: client attempts equals: 3.
	self assert: client refreshes equals: 1.
	self assert: waits asArray equals: #(13339.5).
	^ client
]

{ #category : #examples }
GtLExponentialBackoffExamples >> exponentialDelayIsCappedAndJittered [
	<gtExample>
	| policy |
	policy := GtLExponentialBackoff new.
	policy
		maximumDelay: 4;
		randomBlock: [ 0 ].
	self assert: (policy delayForRetry: 1 minimum: 0) equals: 0.5.
	self assert: (policy delayForRetry: 2 minimum: 0) equals: 1.
	self assert: (policy delayForRetry: 3 minimum: 0) equals: 2.
	self assert: (policy delayForRetry: 10 minimum: 0) equals: 2.
	policy randomBlock: [ 1 ].
	self assert: (policy delayForRetry: 10 minimum: 0) equals: 4.
	self assert: (policy delayForRetry: 1 minimum: 13339) equals: 13339.5.
	^ policy
]

{ #category : #examples }
GtLExponentialBackoffExamples >> nonJsonStreamingErrorsStillRetry [
	<gtExample>
	| client |
	client := GtLOpenAiCodexRetryExampleClient new.
	client useStreamingTransport.
	client
		retryPolicy: (GtLExponentialBackoff new
				waitBlock: [ :seconds |  ];
				yourself).
	client
		responses: {self response: 429 body: 'Too many requests'.
				self response: 200 body: '{"output":[]}'}.
	client post: 'responses' withEntity: Dictionary new.
	self assert: client attempts equals: 2.
	self assert: (client httpClients allSatisfy: #isClosed).
	^ client
]

{ #category : #helpers }
GtLExponentialBackoffExamples >> response: status body: aString [
	^ (ZnResponse statusCode: status)
		entity: (ZnStringEntity json: aString);
		yourself
]

{ #category : #examples }
GtLExponentialBackoffExamples >> retriesAreBoundedAndExecutionStateIsLocal [
	<gtExample>
	| policy waits attempts caught |
	waits := OrderedCollection new.
	policy := GtLExponentialBackoff new
			maxRetries: 2;
			randomBlock: [ 0 ];
			waitBlock: [ :seconds | waits add: seconds ];
			yourself.
	2
		timesRepeat: [ attempts := 0.
			caught := false.
			[ policy
				execute: [ attempts := attempts + 1.
					Error signal: 'retry' ]
				on: Error
				retryIf: [ :error | true ]
				minimumDelay: [ :error | 0 ] ] on: Error do: [ :error | caught := true ].
			self assert: caught.
			self assert: attempts equals: 3 ].
	self assert: waits asArray equals: #(0.5 1 0.5 1).
	^ policy
]

{ #category : #examples }
GtLExponentialBackoffExamples >> streamingErrorsAreRetainedAndConnectionsClosed [
	<gtExample>
	| client waits result limited |
	waits := OrderedCollection new.
	limited := self
			response: 429
			body: '{"error":{"type":"usage_limit_reached","resets_in_seconds":10}}'.
	client := GtLOpenAiCodexRetryExampleClient new.
	client useStreamingTransport.
	client
		retryPolicy: (GtLExponentialBackoff new
				randomBlock: [ 0 ];
				waitBlock: [ :seconds | 
					self assert: (client httpClients allSatisfy: #isClosed).
					waits add: seconds ];
				yourself).
	client
		responses: {limited.
				self response: 200 body: '{"id":"ok","output":[]}'}.
	result := client post: 'responses' withEntity: Dictionary new.
	self assert: (result result at: 'id') equals: 'ok'.
	self assert: waits asArray equals: #(10).
	self assert: (client httpClients allSatisfy: #isClosed).
	self
		assert: (NeoJSONReader fromString: limited entity contents)
		equals: (NeoJSONReader
				fromString: '{"error":{"type":"usage_limit_reached","resets_in_seconds":10}}').
	^ client
]
