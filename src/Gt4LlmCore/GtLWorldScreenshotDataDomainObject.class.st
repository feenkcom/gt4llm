Class {
	#name : #GtLWorldScreenshotDataDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'encodedBytes'
	],
	#category : #Gt4LlmCore
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

{ #category : #serialization }
GtLWorldScreenshotDataDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #String>
	^ 'data:image/jpeg;base64', self encodedBytes
]

{ #category : #accessing }
GtLWorldScreenshotDataDomainObject >> skiaImage [
	^ SkiaImage
		fromBuffer: encodedBytes
		start: 0
		end: encodedBytes size - 1
]
