Class {
	#name : #GtLOllamaCompletionsEndpoint,
	#superclass : #GtLEndpoint,
	#instVars : [
		'reasoningValidator'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'as yet unclassified' }
GtLOllamaCompletionsEndpoint >> addInstructionsTo: input from: chat [
	| instructionString |

	instructionString := chat instructions instructionString.
	instructionString ifEmpty: [ ^ self ].
	input add: {
		'content' -> instructionString.
		'role' -> 'system'.
		} asDictionary.
]

{ #category : #'as yet unclassified' }
GtLOllamaCompletionsEndpoint >> assistantContentTextFrom: aGtLModelAssistantMessage [
	| rawData |

	rawData := aGtLModelAssistantMessage rawData.
	^ rawData atPath: { 'choices'. 1. 'message'. 'content' }.
]

{ #category : #'as yet unclassified' }
GtLOllamaCompletionsEndpoint >> assistantMessageAccessor [

	^ GtLOllamaCompletionsGemma4AssistantMessageAccessor new
]

{ #category : #'private - accessing' }
GtLOllamaCompletionsEndpoint >> entityFromContext: aGtLContext [
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
				(self newUserMessageVisitor userMessageWith: message) ] ].
	self addInstructionsTo: input from: chat.
	entity := {
		'model' -> model name.
		'stream' -> false.
		'messages' -> input asArray
		} asDictionary.
	chat reasoningEffort ifNotNil: [ :effort |
		entity at: 'reasoning_effort' put: effort ].

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
GtLOllamaCompletionsEndpoint >> finishedToolCallResponseFor: aToolCall [
	"This has only been tested successfully with qwen 3.6.
	gemma4 hasn't been successful."

	^ {'type' -> 'function_call'.
		'call_id' -> aToolCall id.
		'name' -> aToolCall name.
		'arguments' -> aToolCall rawArgumentsJsonString.
		'content' -> 'function_call details'.
		} asDictionary
]

{ #category : #'private - accessing' }
GtLOllamaCompletionsEndpoint >> newUserMessageVisitor [

	^ GtLOllamaCompletionsGemma4UserMessageVisitor new
]

{ #category : #accessing }
GtLOllamaCompletionsEndpoint >> path [

	^ '/v1/chat/completions'
]

{ #category : #accessing }
GtLOllamaCompletionsEndpoint >> reasoningValidator [
	^ reasoningValidator
]

{ #category : #accessing }
GtLOllamaCompletionsEndpoint >> reasoningValidator: anObject [
	reasoningValidator := anObject
]

{ #category : #api }
GtLOllamaCompletionsEndpoint >> resultFrom: requestResponse context: context [
	"Deserialise the provided response.
	This currently uses GtLOllamaResponse, which is also used by the Generate endpoint.
	Since they have different response formats this doesn't really make sense.  The parsing should be done here and a generic response object used, which can then be subclassed if different endpoints require specialisation."

	^ (GtLOllamaResponse from: requestResponse result)
		client: context model client;
		requestResponse: requestResponse
]

{ #category : #'private - accessing' }
GtLOllamaCompletionsEndpoint >> serializeToolCall: aToolCall [

	^ {'role' -> 'tool'.
		'tool_call_id' -> aToolCall id.
		'content' -> aToolCall result  mainDataView serializeToLlmPrimiteData compositeJsonDataBlock serializedJsonString } asDictionary
]

{ #category : #'private - accessing' }
GtLOllamaCompletionsEndpoint >> toolEntityFrom: aTool [

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
GtLOllamaCompletionsEndpoint >> validateReasoning: aValue [

	reasoningValidator validate: aValue
]
