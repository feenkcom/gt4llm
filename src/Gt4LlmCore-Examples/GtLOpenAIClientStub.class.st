Class {
	#name : #GtLOpenAIClientStub,
	#superclass : #Object,
	#instVars : [
		'url',
		'contents',
		'responses',
		'lastResponse'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'api - initialization' }
GtLOpenAIClientStub >> contents: anEntity [
	contents := anEntity
]

{ #category : #'api - execution' }
GtLOpenAIClientStub >> newMissingResponsesResponse [
	^ NeoJSONObject new
		at: #error
			put: (NeoJSONObject new
					at: #message put: ('No responses left in {1}' format: {self});
					yourself);
		yourself
]

{ #category : #'api - execution' }
GtLOpenAIClientStub >> post [
	self responses ifEmpty: [ ^ self newMissingResponsesResponse ].

	lastResponse := self responses removeFirst.
	^ STONJSON fromString: lastResponse contents
]

{ #category : #'api - accessing' }
GtLOpenAIClientStub >> request [
]

{ #category : #'api - accessing' }
GtLOpenAIClientStub >> response [
	
]

{ #category : #accessing }
GtLOpenAIClientStub >> responses [
	^ responses ifNil: [ #() ]
]

{ #category : #accessing }
GtLOpenAIClientStub >> responses: anObject [
	responses := anObject
]

{ #category : #'api - initialization' }
GtLOpenAIClientStub >> url: anUrl [
	url := anUrl asZnUrl
]
