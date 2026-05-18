Class {
	#name : #GtLOpenAiResponsesEndpoint,
	#superclass : #GtLEndpoint,
	#instVars : [
		'reasoningValidator'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesEndpoint >> addInstructionsTo: entity from: chat [
	| instructionString |

	instructionString := chat instructions instructionString.
	instructionString ifEmpty: [ ^ self ].
	entity at: 'instructions' put: instructionString.
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesEndpoint >> assistantContentTextFrom: aGtLModelAssistantMessage [
	| rawData |

	rawData := aGtLModelAssistantMessage rawData.
	^ rawData atPath: { 'choices'. 1. 'message'. 'content' }.
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesEndpoint >> assistantMessageAccessor [
self halt.
	^ GtLOllamaCompletionsAssistantMessageAccessor new
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> entityFromContext: aGtLContext [
	| entity input chat model |

	chat := aGtLContext chat.
	model := aGtLContext model.
	input := OrderedCollection new.
	aGtLContext command messages messagesDo: [ :message |
		message isToolMessage ifTrue:
			[ message toolCall isFinished ifTrue:
				[ input add: (self finishedToolCallResponseFor: message toolCall).
			input add: (self serializeToolCall: message toolCall) ] ]
		ifFalse:
			[ input add:
				(self newMessageVisitor chatMessage: message) ] ].
	entity := {
		'model' -> model name.
		'stream' -> false.
		'input' -> input asArray
		} asDictionary.
	self addInstructionsTo: entity from: chat.

	chat format ifNotNil: 
		[ | schema |
		schema := chat format asJsonSchemaDictionary.
		(schema at: 'properties' ifAbsent: [ #() ]) ifNotEmpty:
			[ entity
				at: 'response_format'
				put: {'type' -> 'json_schema'.
							'json_schema' -> { 'schema' -> schema } asDictionary } asDictionary ] ].

	chat tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: (chat tools collect: [ :aTool | self toolEntityFrom: aTool ]) ].

	^ entity
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> finishedToolCallResponseFor: aToolCall [
	"This has only been tested successfully with qwen 3.6.
	gemma4 hasn't been successful."

	^ {'type' -> 'function_call'.
		'call_id' -> aToolCall id.
		'name' -> aToolCall name.
		'arguments' -> aToolCall rawArgumentsJsonString.
		'content' -> 'function_call details'.
		'role' -> 'tool'.
		} asDictionary
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> newMessageVisitor [

	^ GtLOllamaCompletionsMessageVisitor new
]

{ #category : #accessing }
GtLOpenAiResponsesEndpoint >> path [

	^ '/v1/responses'
]

{ #category : #accessing }
GtLOpenAiResponsesEndpoint >> reasoningValidator [
	^ reasoningValidator
]

{ #category : #accessing }
GtLOpenAiResponsesEndpoint >> reasoningValidator: anObject [
	reasoningValidator := anObject
]

{ #category : #api }
GtLOpenAiResponsesEndpoint >> resultFrom: requestResponse context: context [
	"Deserialise the provided response.
	This currently uses GtLOllamaResponse, which is also used by the Generate endpoint.
	Since they have different response formats this doesn't really make sense.  The parsing should be done here and a generic response object used, which can then be subclassed if different endpoints require specialisation."
self halt.
	^ (GtLOllamaResponse from: requestResponse result)
		client: context model client;
		requestResponse: requestResponse
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> serializeToolCall: aToolCall [

	^ {'role' -> 'tool'.
		'tool_call_id' -> aToolCall id.
		'content' -> aToolCall result  mainDataView serializeToLlmPrimiteData compositeJsonDataBlock serializedJsonString } asDictionary
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> toolEntityFrom: aTool [

		^ {
		'type' -> 'function'.
		'function' -> {
			'name' -> aTool name.
			'type' -> aTool type.
			'description' -> aTool description.
			'parameters' -> aTool parametersJsonSchemaDictionary
			} asDictionary.
		} asDictionary
]

{ #category : #validation }
GtLOpenAiResponsesEndpoint >> validateReasoning: aValue [

	reasoningValidator validate: aValue
]
