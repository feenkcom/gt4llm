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

	^ GtLOpenAiResponsesAssistantMessageAccessor new
]

{ #category : #api }
GtLOpenAiResponsesEndpoint >> createPromptCompactionMessageForChat: aChat [
	| message |
	message := aChat createUserMessage.
	message
		configureWithCompactionExecution;
		addResponseFormatForMagritte: GtLChatCompactedData named: 'Compaction';
		markdown: 'You are performing a CONTEXT CHECKPOINT COMPACTION. Create a handoff summary for another LLM that will resume the task.'.
	^ message
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

	chat format ifNotNil: [ | schema |
		schema := chat format asJsonSchemaDictionary.
		entity
			at: 'text'
			put: {'format'
				-> {'type' -> 'json_schema'.
						'name' -> 'JsonSchema'.
						'schema' -> schema} asDictionary} asDictionary ].

	chat tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: (chat tools 
					collect: [ :aTool | self toolEntityFrom: aTool ]
					as: Array) ].

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
		} asDictionary
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> newMessageVisitor [

	^ GtLOpenAiResponsesMessageVisitor new
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
	"Deserialise the provided response"

	^ (GtLModelResponse 
		from: requestResponse result
		model: context model)
			client: context model client;
			requestResponse: requestResponse
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> serializeToolCall: aToolCall [
	| output |

	output := {
		'text' -> aToolCall result  mainDataView serializeToLlmPrimiteData compositeJsonDataBlock serializedJsonString.
		'type' -> 'input_text'.
		} asDictionary.
	^ {'type' -> 'function_call_output'.
		'call_id' -> aToolCall id.
		'output' -> { output } } asDictionary
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> toolCallsIn: rawData [
	<return: #Array of: #GtLFunctionToolCall>

	^ (rawData at: 'output')
		select: [ :aDict | (aDict at: 'type') = 'function_call' ]
		thenCollect: [ :aDict | 
			GtLFunctionToolCall new
					rawData: aDict;
					id: (aDict at: 'call_id');
					name: (aDict at: 'name');
					rawArguments: (aDict at: 'arguments') ]
]

{ #category : #'private - accessing' }
GtLOpenAiResponsesEndpoint >> toolEntityFrom: aTool [

		^ {
		'description' -> aTool description.
		'type' -> aTool type.
		'name' -> aTool name.
		'parameters' -> aTool parametersJsonSchemaDictionary.
		} asDictionary
]

{ #category : #validation }
GtLOpenAiResponsesEndpoint >> validateReasoning: aValue [

	reasoningValidator validate: aValue
]
