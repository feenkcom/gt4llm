Class {
	#name : #GtLInputAttachment,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLInputAttachment class >> fileReference: aFileReference [
	^ self new
		fileReference: aFileReference;
		yourself
]

{ #category : #accessing }
GtLInputAttachment >> asFileReference [
	^ self fileReference
]

{ #category : #accessing }
GtLInputAttachment >> base64EncodedContent [ 
	^ self fileReference binaryContents base64Encoded
]

{ #category : #accessing }
GtLInputAttachment >> fileReference [
	^ fileReference
]

{ #category : #accessing }
GtLInputAttachment >> fileReference: aFileReference [
	fileReference := aFileReference
]

{ #category : #printing }
GtLInputAttachment >> gtDisplayOn: aStream [
	^ self fileReference gtDisplayOn: aStream
]
