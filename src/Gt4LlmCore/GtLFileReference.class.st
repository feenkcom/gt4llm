Class {
	#name : #GtLFileReference,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLFileReference class >> fileReference: aFileReference [
	^ self new
		fileReference: aFileReference;
		yourself
]

{ #category : #'instance creation' }
GtLFileReference class >> fromFileReference: aFileReference [
	"Create the appropriate subclass based on file extension"
	| extension |
	extension := aFileReference extension asLowercase.
	
	(#('pdf') includes: extension)
		ifTrue: [ ^ GtLPdfFile fileReference: aFileReference ].
	
	(#('png' 'jpg' 'jpeg' 'gif' 'webp') includes: extension)
		ifTrue: [ ^ GtLImageFile fileReference: aFileReference ].
	
	(#('txt' 'md' 'json' 'xml' 'html' 'css' 'js' 'st') includes: extension)
		ifTrue: [ ^ GtLTextFile fileReference: aFileReference ].
	
	^ GtLGenericFile fileReference: aFileReference
]

{ #category : #accessing }
GtLFileReference >> asFileReference [
	^ self fileReference
]

{ #category : #accessing }
GtLFileReference >> base64EncodedContent [ 
	^ self fileReference binaryContents base64Encoded
]

{ #category : #accessing }
GtLFileReference >> contentType [
	"Subclasses should override to return their specific content type"
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLFileReference >> fileReference [
	^ fileReference
]

{ #category : #accessing }
GtLFileReference >> fileReference: aFileReference [
	fileReference := aFileReference
]

{ #category : #printing }
GtLFileReference >> gtDisplayOn: aStream [
	^ self fileReference gtDisplayOn: aStream
]
