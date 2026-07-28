Class {
	#name : #GtLOpenAiResponsesResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> content [

	^ (self output asArray 
		select: [ :each | each includesKey: 'content' ])
		flatCollect: [ :each | 
			(each at: 'content') collect: [ :item |
			GtLOpenAiContentEntity new rawData: item ] ]
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> contentText [

	^ '' join: (self content collect: [ :contentEntity | contentEntity text ])
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> created [
	^ self rawData at: 'created'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> object [
	^ self rawData at: 'object'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> output [
	^ self rawData at: 'output'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> systemFingerprint [
	^ self rawData at: 'system_fingerprint'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> usage [
	^ GtLOllamaCompletionsUsageEntity new rawData: (self rawData at: 'usage')
]
