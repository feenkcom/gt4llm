Class {
	#name : #GtLlmCheckRunResultViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithCheckRunResult',
	#classTraits : 'TGtLlmWithCheckRunResult classTrait',
	#category : #'Gt4Llm-Widgets'
}

{ #category : #actions }
GtLlmCheckRunResultViewModel >> addToNewMessage [
	self halt
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> executionResult [
	^ checkRunResult executionResult
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> messageContents [
	<return: #String>
	^ self executionResult asString
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> sendToChat [
	^ checkRunResult sendToChat
]
