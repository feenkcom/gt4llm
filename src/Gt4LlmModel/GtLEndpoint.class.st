Class {
	#name : #GtLEndpoint,
	#superclass : #Object,
	#instVars : [
		'additionalEntity'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #private }
GtLEndpoint >> addAdditionalEntityTo: entity [

	additionalEntity ifNil: [ ^ self ].

	entity addAll: additionalEntity.
]

{ #category : #accessing }
GtLEndpoint >> additionalEntity [
	"Answer a dictionary that is appended to every entity sent to the LLM"

	^ additionalEntity ifNil: [ additionalEntity := Dictionary new ]
]

{ #category : #api }
GtLEndpoint >> createApiCompactionMessageForChat: aChat [

	^ self subclassResponsibility
]

{ #category : #api }
GtLEndpoint >> createPromptCompactionMessageForChat: aChat [
	| message |
	message := aChat createUserMessage.
	message
		addResponseFormatForMagritte: GtLChatCompactedData named: 'Compaction';
		markdown: 'You are performing a CONTEXT CHECKPOINT COMPACTION. Create a handoff summary for another LLM that will resume the task.'.
	^ message
]

{ #category : #'private - accessing' }
GtLEndpoint >> entityFromContext: aGtLContext [

	^ self subclassResponsibility
]

{ #category : #api }
GtLEndpoint >> newContextForModel: model [

	^ GtLEndpointContext new
		model: model;
		provider: model provider.
]

{ #category : #accessing }
GtLEndpoint >> path [
	^ self subclassResponsibility
]
