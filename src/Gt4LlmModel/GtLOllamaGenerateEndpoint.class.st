Class {
	#name : #GtLOllamaGenerateEndpoint,
	#superclass : #GtLEndpoint,
	#instVars : [
		'reasoningValidator'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'as yet unclassified' }
GtLOllamaGenerateEndpoint >> assistantMessageAccessor [

	^ GtLOllamaGenerateAssistantMessageAccessor new
]

{ #category : #'private - accessing' }
GtLOllamaGenerateEndpoint >> entityFromContext: aGtLContext [
	| chat model messages userMessage entity input |

	chat := aGtLContext chat.
	model := chat model.
	messages := aGtLContext chat messages.
	"Ollama generate only accepts a single user message."
	self assert: (messages items count: #isUserMessage) = 1
		description: 'Only a single message is currently supported'.
	userMessage := (messages select: #isUserMessage) first.
	input := self newUserMessageVisitor userMessageWith: userMessage.
	entity := {
		'model' -> aGtLContext model name.
		'stream' -> false.
		} asDictionary.
	input first associations do:
		[ :assoc | entity add: assoc ].
	chat reasoningEffort ifNotNil: [ :effort |
		entity at: 'think' put: effort ].
	chat instructions ifNotNil: 
		[ entity at: 'system' put: 
			chat instructions instructionString ].
	^ entity
]

{ #category : #'private - accessing' }
GtLOllamaGenerateEndpoint >> newUserMessageVisitor [

	^ GtLOllamaGenerateUserMessageVisitor new
]

{ #category : #accessing }
GtLOllamaGenerateEndpoint >> path [

	^ '/api/generate'
]

{ #category : #accessing }
GtLOllamaGenerateEndpoint >> reasoningValidator [
	^ reasoningValidator
]

{ #category : #accessing }
GtLOllamaGenerateEndpoint >> reasoningValidator: anObject [
	reasoningValidator := anObject
]

{ #category : #validation }
GtLOllamaGenerateEndpoint >> validateReasoning: aValue [

	reasoningValidator validate: aValue
]
