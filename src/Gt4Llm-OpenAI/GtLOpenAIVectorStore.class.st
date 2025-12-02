Class {
	#name : #GtLOpenAIVectorStore,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'name',
		'createdAt',
		'status',
		'usageBytes',
		'fileCounts'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIVectorStore class >> leJsonV4Name [

	^ #gtOpenAIVectorStore
]

{ #category : #'as yet unclassified' }
GtLOpenAIVectorStore class >> serializationProperties [
	^ {#id -> #id.
		#name -> #name.
		#created_at -> #createdAt.
		#status -> #status.
		#usage_bytes -> #usageBytes.
		#file_counts -> #fileCounts}
]

{ #category : #accessing }
GtLOpenAIVectorStore >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIVectorStore >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLOpenAIVectorStore >> fileCounts [
	^ fileCounts
]

{ #category : #accessing }
GtLOpenAIVectorStore >> fileCounts: anObject [
	fileCounts := anObject
]

{ #category : #accessing }
GtLOpenAIVectorStore >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIVectorStore >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIVectorStore >> name [
	^ name
]

{ #category : #accessing }
GtLOpenAIVectorStore >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLOpenAIVectorStore >> status [
	^ status
]

{ #category : #accessing }
GtLOpenAIVectorStore >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtLOpenAIVectorStore >> usageBytes [
	^ usageBytes
]

{ #category : #accessing }
GtLOpenAIVectorStore >> usageBytes: anObject [
	usageBytes := anObject
]
