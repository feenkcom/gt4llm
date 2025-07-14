Class {
	#name : #GtMcpResource,
	#superclass : #Object,
	#instVars : [
		'name',
		'title',
		'uri',
		'mimeType',
		'contentsBlock',
		'description'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtMcpResource >> contents [
	^ contentsBlock value
]

{ #category : #accessing }
GtMcpResource >> contentsBlock [
	^ contentsBlock
]

{ #category : #accessing }
GtMcpResource >> contentsBlock: anObject [
	contentsBlock := anObject
]

{ #category : #accessing }
GtMcpResource >> description [
	^ description ifNil: [ name ]
]

{ #category : #accessing }
GtMcpResource >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtMcpResource >> mimeType [
	^ mimeType
]

{ #category : #accessing }
GtMcpResource >> mimeType: anObject [
	mimeType := anObject
]

{ #category : #accessing }
GtMcpResource >> name [
	^ name
]

{ #category : #accessing }
GtMcpResource >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtMcpResource >> title [
	^ title ifNil: [ name ]
]

{ #category : #accessing }
GtMcpResource >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtMcpResource >> uri [
	^ uri
]

{ #category : #accessing }
GtMcpResource >> uri: anObject [
	uri := anObject
]
