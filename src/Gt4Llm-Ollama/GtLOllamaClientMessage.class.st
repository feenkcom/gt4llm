Class {
	#name : #GtLOllamaClientMessage,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client',
		'message',
		'model',
		'createdAt',
		'evalCount',
		'evalDuration',
		'loadDuration',
		'doneReason',
		'promptEvalCount',
		'promptEvalDuration',
		'totalDuration',
		'requestResponse'
	],
	#category : #'Gt4Llm-Ollama-Model'
}

{ #category : #serialization }
GtLOllamaClientMessage class >> from: aDictionary [
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].
	^ self new from: aDictionary; yourself
]

{ #category : #accessing }
GtLOllamaClientMessage >> client [
	^ client
]

{ #category : #accessing }
GtLOllamaClientMessage >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLOllamaClientMessage >> content [
	^ self message at: 'content' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLOllamaClientMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOllamaClientMessage >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtLOllamaClientMessage >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtLOllamaClientMessage >> evalDuration [
	^ evalDuration
]

{ #category : #initialization }
GtLOllamaClientMessage >> from: aDictionary [
	rawData := aDictionary.
	message := aDictionary at: 'message' ifAbsent: [ Dictionary new ].
	model := aDictionary at: 'model' ifAbsent: [ nil ].
	createdAt := aDictionary at: 'created_at' ifAbsent: [ nil ].
	evalCount := aDictionary at: 'eval_count' ifAbsent: [ nil ].
	evalDuration := aDictionary at: 'eval_duration' ifAbsent: [ nil ].
	loadDuration := aDictionary at: 'load_duration' ifAbsent: [ nil ].
	doneReason := aDictionary at: 'done_reason' ifAbsent: [ nil ].
	promptEvalCount := aDictionary at: 'prompt_eval_count' ifAbsent: [ nil ].
	promptEvalDuration := aDictionary at: 'prompt_eval_duration' ifAbsent: [ nil ].
	totalDuration := aDictionary at: 'total_duration' ifAbsent: [ nil ]
]

{ #category : #testing }
GtLOllamaClientMessage >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtLOllamaClientMessage >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtLOllamaClientMessage >> message [
	^ message
]

{ #category : #accessing }
GtLOllamaClientMessage >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaClientMessage >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtLOllamaClientMessage >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtLOllamaClientMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOllamaClientMessage >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaClientMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaClientMessage >> toolCalls [
	^ (self message at: 'tool_calls' ifAbsent: [ #() ])
		collect: [ :each |
			| function |
			function := each at: 'function' ifAbsent: [ Dictionary new ].
			GtLFunctionToolCall new
				id: (each at: 'id' ifAbsent: [ UUID new asString ]);
				name: (function at: 'name' ifAbsent: [ '' ]);
				rawArguments: (function at: 'arguments' ifAbsent: [ Dictionary new ]);
				arguments: (function at: 'arguments' ifAbsent: [ Dictionary new ]);
				yourself ]
]

{ #category : #accessing }
GtLOllamaClientMessage >> totalDuration [
	^ totalDuration
]
