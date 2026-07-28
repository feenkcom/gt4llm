Class {
	#name : #GtLModelResponse,
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
		'requestResponse',
		'providerInformation',
		'modelName'
	],
	#category : #'Gt4Llm-Ollama-Model'
}

{ #category : #serialization }
GtLModelResponse class >> from: aDictionary [
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].
	^ self new from: aDictionary; yourself
]

{ #category : #serialization }
GtLModelResponse class >> from: aDictionary model: aGtLLlmModel [

	^ (self from: aDictionary) model: aGtLLlmModel
]

{ #category : #accessing }
GtLModelResponse >> client [
	^ client
]

{ #category : #accessing }
GtLModelResponse >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLModelResponse >> content [
	^ self message at: 'content' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLModelResponse >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLModelResponse >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtLModelResponse >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtLModelResponse >> evalDuration [
	^ evalDuration
]

{ #category : #initialization }
GtLModelResponse >> from: aDictionary [
	rawData := aDictionary.
	message := aDictionary at: 'message' ifAbsent: [ Dictionary new ].
	modelName := aDictionary at: 'model' ifAbsent: [ nil ].
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
GtLModelResponse >> gtRawJsonFor: aView [
	<gtView>
	
	rawData ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'JSON';
		priority: 30;
		object: [ rawData ];
		view: #gtJsonFor:
]

{ #category : #testing }
GtLModelResponse >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtLModelResponse >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtLModelResponse >> message [
	^ message
]

{ #category : #accessing }
GtLModelResponse >> model [
	^ model
]

{ #category : #accessing }
GtLModelResponse >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLModelResponse >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLModelResponse >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtLModelResponse >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtLModelResponse >> providerInformation [
	^ providerInformation
]

{ #category : #accessing }
GtLModelResponse >> providerInformation: anObject [
	providerInformation := anObject
]

{ #category : #accessing }
GtLModelResponse >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLModelResponse >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLModelResponse >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLModelResponse >> toolCalls [

	^ model userMessageEndpoint toolCallsIn: rawData.
]

{ #category : #accessing }
GtLModelResponse >> totalDuration [
	^ totalDuration
]
