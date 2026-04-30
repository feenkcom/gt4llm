Class {
	#name : #GtLDocumentDataView,
	#superclass : #GtLDataViewDecorator,
	#instVars : [
		'contentType',
		'documentBytesComputation',
		'computedDocumentBytes',
		'contentLabelComputation'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLDocumentDataView >> computeContentLabel [
	^contentLabelComputation ifNotNil: [ :aComputation |
			aComputation value ]
]

{ #category : #accessing }
GtLDocumentDataView >> computedDocumentBytes [
	^ computedDocumentBytes ifNil: [
		computedDocumentBytes := documentBytesComputation value ]
]

{ #category : #accessing }
GtLDocumentDataView >> contentLabel: aBlockClosure [
	contentLabelComputation := aBlockClosure
]

{ #category : #accessing }
GtLDocumentDataView >> contentType [
	^ contentType
]

{ #category : #accessing }
GtLDocumentDataView >> contentType: anObject [
	contentType := anObject
]

{ #category : #api }
GtLDocumentDataView >> document: aBlockClosure [
	"Set the document bytes computation block"
	self documentBytes: aBlockClosure
]

{ #category : #accessing }
GtLDocumentDataView >> documentBytes: aBlockClosure [
	documentBytesComputation := aBlockClosure
]

{ #category : #accessing }
GtLDocumentDataView >> encodedBytes [
	^ self computedDocumentBytes base64Encoded
]

{ #category : #api }
GtLDocumentDataView >> pdf: aBlockClosure [
	"Set the document bytes computation block and content type for PDF documents"
	self document: aBlockClosure.
	self contentType: 'application/pdf'
]

{ #category : #printing }
GtLDocumentDataView >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << ('data:', (self contentType ifNil: [ 'unknown' ]), ';base64,') ]
]

{ #category : #serialization }
GtLDocumentDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	aBuilder 
		addDocumentBlockFor: self computedDocumentBytes
		contentType: self contentType
		label: self computeContentLabel
		dataKey: self dataKey
		from: self
]
