"
Trait providing assertion methods for exception result JSON data in examples.
"
Trait {
	#name : #TGtLExceptionResultAssertions,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
TGtLExceptionResultAssertions >> assertExceptionResult: resultJson errorClass: errorClassName errorMessage: errorMessage stackTraceIncludes: stackTraceSubstrings [
	self assertJsonData: resultJson hasExpectedKeys: #('errorClass' 'errorMessage' 'stackTrace').
	self assert: (resultJson at: #errorClass) equals: errorClassName.
	self assert: ((resultJson at: #errorMessage) includesSubstring: errorMessage).
	stackTraceSubstrings do: [ :substring |
		self assert: ((resultJson at: #stackTrace) includesSubstring: substring) ].
]

{ #category : #requirements }
TGtLExceptionResultAssertions >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	"Subclasses should implement this method to assert JSON data has expected keys."
	self explicitRequirement
]
