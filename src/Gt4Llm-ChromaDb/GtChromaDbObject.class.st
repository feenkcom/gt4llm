Class {
	#name : #GtChromaDbObject,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'requestResponse'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #'instance creation' }
GtChromaDbObject class >> requestResponse: aGtLRequestResponse [

	^ self new requestResponse: aGtLRequestResponse
]

{ #category : #accessing }
GtChromaDbObject >> rawData [
	^ rawData
]

{ #category : #accessing }
GtChromaDbObject >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtChromaDbObject >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtChromaDbObject >> requestResponse: aGtLRequestResponse [

	requestResponse := aGtLRequestResponse.
	rawData := requestResponse result.
]
