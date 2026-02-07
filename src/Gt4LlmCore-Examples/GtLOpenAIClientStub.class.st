Class {
	#name : #GtLOpenAIClientStub,
	#superclass : #ZnClient,
	#instVars : [
		'responses'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'api - execution' }
GtLOpenAIClientStub >> execute [
	response := self responses
			ifEmpty: [ self newMissingResponsesResponse ]
			ifNotEmpty: [ self responses removeFirst ].

	^ self contents
]

{ #category : #'api - execution' }
GtLOpenAIClientStub >> newMissingResponsesResponse [
	| jsonObject |
	jsonObject := NeoJSONObject new
			at: #error
				put: (NeoJSONObject new
						at: #message put: ('No responses left in {1}' format: {self});
						yourself);
			yourself.

	^ ZnResponse
		serverErrorWithEntity: (ZnEntity json: (STONJSON toString: jsonObject))
]

{ #category : #accessing }
GtLOpenAIClientStub >> responses [
	^ responses ifNil: [ #() ]
]

{ #category : #accessing }
GtLOpenAIClientStub >> responses: anObject [
	responses := anObject
]
