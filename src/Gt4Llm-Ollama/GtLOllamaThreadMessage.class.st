Class {
	#name : #GtLOllamaThreadMessage,
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
GtLOllamaThreadMessage class >> from: aDictionary [
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].
	^ self new from: aDictionary; yourself
]

{ #category : #accessing }
GtLOllamaThreadMessage >> client [
	^ client
]

{ #category : #accessing }
GtLOllamaThreadMessage >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLOllamaThreadMessage >> content [
	^ self message at: 'content' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLOllamaThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOllamaThreadMessage >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtLOllamaThreadMessage >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtLOllamaThreadMessage >> evalDuration [
	^ evalDuration
]

{ #category : #initialization }
GtLOllamaThreadMessage >> from: aDictionary [
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
GtLOllamaThreadMessage >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtLOllamaThreadMessage >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtLOllamaThreadMessage >> message [
	^ message
]

{ #category : #accessing }
GtLOllamaThreadMessage >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaThreadMessage >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtLOllamaThreadMessage >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtLOllamaThreadMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOllamaThreadMessage >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaThreadMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaThreadMessage >> toolCalls [
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
GtLOllamaThreadMessage >> totalDuration [
	^ totalDuration
]
