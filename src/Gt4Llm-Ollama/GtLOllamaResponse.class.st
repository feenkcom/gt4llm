Class {
	#name : #GtLOllamaResponse,
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
	#category : 'Gt4Llm-Ollama-Model'
}

{ #category : #serialization }
GtLOllamaResponse class >> from: aDictionary [
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].
	^ self new from: aDictionary; yourself
]

{ #category : #accessing }
GtLOllamaResponse >> client [
	^ client
]

{ #category : #accessing }
GtLOllamaResponse >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLOllamaResponse >> content [
	^ self message at: 'content' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLOllamaResponse >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOllamaResponse >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtLOllamaResponse >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtLOllamaResponse >> evalDuration [
	^ evalDuration
]

{ #category : #initialization }
GtLOllamaResponse >> from: aDictionary [
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

{ #category : #ui }
GtLOllamaResponse >> gtRawJsonFor: aView [
	<gtView>
	
	rawData ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'JSON';
		priority: 30;
		object: [ rawData ];
		view: #gtJsonFor:
]

{ #category : #testing }
GtLOllamaResponse >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtLOllamaResponse >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtLOllamaResponse >> message [
	^ message
]

{ #category : #accessing }
GtLOllamaResponse >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaResponse >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtLOllamaResponse >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtLOllamaResponse >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOllamaResponse >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaResponse >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaResponse >> toolCalls [
	| toolCalls |

	rawData at: 'choices' ifPresent: [ :choices |
		choices detect: [ :choice |
			choice at: 'message'
				ifPresent: [ :aMessage |
					aMessage at: 'tool_calls'
						ifPresent: [ :anArray | 
							toolCalls := anArray.
							true. ]
						ifAbsent: [ false ] ]
				ifAbsent: [ false ] ]
			ifNone: [] ].
	toolCalls ifNil: [ ^ #() ].
	^ toolCalls collect: [ :aToolCall | | function rawArguments |
			function := aToolCall at: 'function' 
									ifAbsent: [ Dictionary new ].
			rawArguments := NeoJSONReader fromString: (function at: 'arguments' ifAbsent: [ '{}' ]).
			GtLFunctionToolCall new
				id: (aToolCall at: 'id' ifAbsent: [ UUID new asString ]);
				name: (function at: 'name' ifAbsent: [ '' ]);
				rawArguments: rawArguments;
				arguments: rawArguments;
				yourself ]
			as: Array.
]

{ #category : #accessing }
GtLOllamaResponse >> totalDuration [
	^ totalDuration
]
