Class {
	#name : #GtLlmCheckRunResultViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithCheckRunResult',
	#classTraits : 'TGtLlmWithCheckRunResult classTrait',
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> executionResult [
	^ checkRunResult executionResult
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> sendToChat [
	^ checkRunResult sendToChat
]
