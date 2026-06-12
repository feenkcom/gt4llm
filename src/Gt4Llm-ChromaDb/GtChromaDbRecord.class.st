Class {
	#name : #GtChromaDbRecord,
	#superclass : #Object,
	#instVars : [
		'id',
		'document',
		'metadata',
		'uri',
		'include'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbRecord >> document [
	^ document
]

{ #category : #accessing }
GtChromaDbRecord >> document: anObject [
	document := anObject
]

{ #category : #accessing }
GtChromaDbRecord >> id [
	^ id
]

{ #category : #accessing }
GtChromaDbRecord >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtChromaDbRecord >> include [
	^ include
]

{ #category : #accessing }
GtChromaDbRecord >> include: anObject [
	include := anObject
]

{ #category : #accessing }
GtChromaDbRecord >> metadata [
	^ metadata
]

{ #category : #accessing }
GtChromaDbRecord >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtChromaDbRecord >> uri [
	^ uri
]

{ #category : #accessing }
GtChromaDbRecord >> uri: anObject [
	uri := anObject
]
