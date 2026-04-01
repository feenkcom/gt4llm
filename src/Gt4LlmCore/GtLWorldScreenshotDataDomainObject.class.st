Class {
	#name : #GtLWorldScreenshotDataDomainObject,
	#superclass : #Object,
	#instVars : [
		'encodedBytes'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #private }
GtLWorldScreenshotDataDomainObject >> bytes: aByteArray [ 
	encodedBytes := aByteArray
]

{ #category : #accessing }
GtLWorldScreenshotDataDomainObject >> encodedBytes [
	^ encodedBytes base64Encoded
]

{ #category : #views }
GtLWorldScreenshotDataDomainObject >> gtImageFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #'llm views' }
GtLWorldScreenshotDataDomainObject >> llmImageViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView imageData
		title: 'Image';
		png: [ encodedBytes ]
]

{ #category : #accessing }
GtLWorldScreenshotDataDomainObject >> skiaImage [
	^ SkiaImage
		fromBuffer: encodedBytes
		start: 0
		end: encodedBytes size - 1
]
