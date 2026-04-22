Class {
	#name : #GtLMcpResource,
	#superclass : #Object,
	#instVars : [
		'name',
		'title',
		'uri',
		'mimeType',
		'contentsBlock',
		'description'
	],
	#category : 'Gt4LlmCore-Mcp'
}

{ #category : #'as yet unclassified' }
GtLMcpResource >> contents [
	^ contentsBlock value
]

{ #category : #accessing }
GtLMcpResource >> contentsBlock [
	^ contentsBlock
]

{ #category : #accessing }
GtLMcpResource >> contentsBlock: anObject [
	contentsBlock := anObject
]

{ #category : #accessing }
GtLMcpResource >> description [
	^ description ifNil: [ name ]
]

{ #category : #accessing }
GtLMcpResource >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLMcpResource >> mimeType [
	^ mimeType
]

{ #category : #accessing }
GtLMcpResource >> mimeType: anObject [
	mimeType := anObject
]

{ #category : #accessing }
GtLMcpResource >> name [
	^ name
]

{ #category : #accessing }
GtLMcpResource >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLMcpResource >> title [
	^ title ifNil: [ name ]
]

{ #category : #accessing }
GtLMcpResource >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtLMcpResource >> uri [
	^ uri
]

{ #category : #accessing }
GtLMcpResource >> uri: anObject [
	uri := anObject
]
