Class {
	#name : #GtLOpenAiCodexResponsesEndpoint,
	#superclass : #GtLOpenAiResponsesEndpoint,
	#category : #'Gt4LlmModel-Codex'
}

{ #category : #private }
GtLOpenAiCodexResponsesEndpoint >> addAdditionalEntityTo: anEntity [
	super addAdditionalEntityTo: anEntity.
	anEntity at: 'stream' put: true.
	anEntity at: 'store' put: false.
	anEntity at: 'include' put: #('reasoning.encrypted_content').
	anEntity at: 'parallel_tool_calls' put: true
]

{ #category : #serialization }
GtLOpenAiCodexResponsesEndpoint >> entityFromContext: aContext [
	| entity |
	entity := super entityFromContext: aContext.
	entity at: 'stream' put: true.
	entity at: 'store' put: false.
	entity at: 'include' put: #('reasoning.encrypted_content').
	entity at: 'parallel_tool_calls' put: true.
	^ entity
]

{ #category : #accessing }
GtLOpenAiCodexResponsesEndpoint >> path [
	^ '/backend-api/codex/responses'
]
