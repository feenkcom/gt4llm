Class {
	#name : #GtLPlainImage,
	#superclass : #GtLPlainData,
	#instVars : [
		'imageType',
		'imageBytes'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPlainImage class >> fromElement: anElement [
	| rootElement form |
	rootElement := BlScripter new
			element: anElement;
			extent: 1600@1200;
			elementWithoutParent.
	form := BlExporter png
			element: rootElement;
			doExport: [ :aCanvas | aCanvas asForm ].
	^ self png: (ByteArray
		streamContents: [ :out | PNGReadWriter putForm: form onStream: out ])
]

{ #category : #'instance creation' }
GtLPlainImage class >> png: aByteArray [
	^ self new 
		 initializeWithPngBytes: aByteArray
]

{ #category : #accessing }
GtLPlainImage >> encodedBytes [
	^ imageBytes base64Encoded
]

{ #category : #'gt - extensions' }
GtLPlainImage >> gtImageFor: aView [
	<gtView>
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #accessing }
GtLPlainImage >> imageBytes: anObject [
	imageBytes := anObject
]

{ #category : #accessing }
GtLPlainImage >> imageType [
	^ imageType
]

{ #category : #accessing }
GtLPlainImage >> imageType: anObject [
	imageType := anObject
]

{ #category : #initialization }
GtLPlainImage >> initializeWithPngBytes: aByteArray [
	self imageBytes: aByteArray.
	self imageType: 'png'.
]

{ #category : #accessing }
GtLPlainImage >> llmImageDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView imageData
			imageBytes: [ self encodedBytes ];
			imageType: imageType
]

{ #category : #printing }
GtLPlainImage >> printOn: aStream [ 
	aStream << ('data:image/',self imageType,';base64') 
]

{ #category : #'gt - extensions' }
GtLPlainImage >> skiaImage [
	^SkiaImage
		fromBuffer: imageBytes
		start: 0
		end: imageBytes size - 1
]
