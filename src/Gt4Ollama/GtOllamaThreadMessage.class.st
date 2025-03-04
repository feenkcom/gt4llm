Class {
	#name : #GtOllamaThreadMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'promptEvalDuration',
		'model',
		'createdAt',
		'evalDuration',
		'totalDuration',
		'loadDuration',
		'doneReason',
		'promptEvalCount',
		'evalCount',
		'message'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaThreadMessage class >> serializationProperties [
	^ {
		#content -> #content.
		#message -> #message.
		#role -> #role.
		#eval_count -> #evalCount.
		#prompt_eval_duration->#promptEvalDuration.
		#model -> #model.
		#created_at -> #createdAt.
		#eval_duration -> #evalDuration.
		#total_duration -> #totalDuration.
		#load_duration -> #loadDuration.
		#done_reason -> #doneReason.
		#prompt_eval_count -> #promptEvalCount
	}
]

{ #category : #accessing }
GtOllamaThreadMessage >> content [
	^ self message at: 'content'
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessage >> content: aString [
]

{ #category : #accessing }
GtOllamaThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOllamaThreadMessage >> createdAt: anObject [
	createdAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtOllamaThreadMessage >> doneReason: anObject [
	doneReason := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalCount: anObject [
	evalCount := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalDuration [
	^ evalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalDuration: anObject [
	evalDuration := anObject ifNotNil: [ :aValue | aValue nanoSeconds ]
]

{ #category : #accessing }
GtOllamaThreadMessage >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> loadDuration: anObject [
	loadDuration := anObject nanoSeconds
]

{ #category : #accessing }
GtOllamaThreadMessage >> message [
	^ message
]

{ #category : #accessing }
GtOllamaThreadMessage >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> model [
	^ model
]

{ #category : #accessing }
GtOllamaThreadMessage >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalCount: anObject [
	promptEvalCount := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalDuration: anObject [
	promptEvalDuration := anObject nanoSeconds
]

{ #category : #accessing }
GtOllamaThreadMessage >> role [
	^ 'assistant'
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessage >> role: anArgument [
	"we ignore the role"
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessage >> toolCalls [
	^ (self message at: 'tool_calls' ifAbsent: [ {} ])
		collect: [ :aDict | GtLlmFunctionToolCall from: aDict ]
]

{ #category : #accessing }
GtOllamaThreadMessage >> totalDuration [
	^ totalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> totalDuration: anObject [
	totalDuration := anObject nanoSeconds
]
