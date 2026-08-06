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
		markdown: 'Compact this chat for later continuation. Summarize:
- The initial and remaining goals
- Essential lessons and decisions
- Open questions
- Next steps'.
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
