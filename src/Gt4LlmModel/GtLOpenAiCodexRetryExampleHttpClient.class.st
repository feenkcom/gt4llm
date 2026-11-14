"
In-memory streaming HTTP transport for Codex examples; records connection closure without network I/O.
"
Class {
	#name : #GtLOpenAiCodexRetryExampleHttpClient,
	#superclass : #ZnClient,
	#instVars : [
		'scriptedResponse',
		'closed'
	],
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #closing }
GtLOpenAiCodexRetryExampleHttpClient >> close [
	closed := true.
	super close
]

{ #category : #accessing }
GtLOpenAiCodexRetryExampleHttpClient >> isClosed [
	^ closed = true
]

{ #category : #requests }
GtLOpenAiCodexRetryExampleHttpClient >> post [
	response := scriptedResponse.
	^ response entity contents readStream
]

{ #category : #accessing }
GtLOpenAiCodexRetryExampleHttpClient >> scriptedResponse: aResponse [
	scriptedResponse := aResponse
]
