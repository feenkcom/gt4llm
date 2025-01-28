Class {
	#name : #GtOpenAIVectorStore,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'name',
		'createdAt',
		'status',
		'usageBytes',
		'fileCounts'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #'as yet unclassified' }
GtOpenAIVectorStore class >> serializationProperties [
	^ {#id -> #id.
		#name -> #name.
		#created_at -> #createdAt.
		#status -> #status.
		#usage_bytes -> #usageBytes.
		#file_counts -> #fileCounts}
]

{ #category : #accessing }
GtOpenAIVectorStore >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIVectorStore >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtOpenAIVectorStore >> fileCounts [
	^ fileCounts
]

{ #category : #accessing }
GtOpenAIVectorStore >> fileCounts: anObject [
	fileCounts := anObject
]

{ #category : #accessing }
GtOpenAIVectorStore >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIVectorStore >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIVectorStore >> name [
	^ name
]

{ #category : #accessing }
GtOpenAIVectorStore >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtOpenAIVectorStore >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIVectorStore >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIVectorStore >> usageBytes [
	^ usageBytes
]

{ #category : #accessing }
GtOpenAIVectorStore >> usageBytes: anObject [
	usageBytes := anObject
]
