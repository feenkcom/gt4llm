Class {
	#name : #GtLOpenAICompactionResponse,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'createdAt',
		'output',
		'usage',
		'requestResponse'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #serialization }
GtLOpenAICompactionResponse class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#output -> #output.
		#usage -> #usage}
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> createdAt [
	^createdAt
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #testing }
GtLOpenAICompactionResponse >> hasToolCalls [
	^false
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> id [
	^id
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> output [
	^output
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> requestResponse [
	^requestResponse
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> usage [
	^usage
]

{ #category : #accessing }
GtLOpenAICompactionResponse >> usage: anObject [
	usage := anObject
]
