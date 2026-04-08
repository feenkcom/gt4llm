Class {
	#name : #GtLImageData,
	#superclass : #GtLPlainData,
	#instVars : [
		'imageType',
		'imageBytes'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLImageData class >> fromElement: anElement [
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
GtLImageData class >> png: aByteArray [
	^ self new 
		 initializeWithPngBytes: aByteArray
]

{ #category : #accessing }
GtLImageData >> encodedBytes [
	^ imageBytes base64Encoded
]

{ #category : #'gt - extensions' }
GtLImageData >> gtImageFor: aView [
	<gtView>
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #accessing }
GtLImageData >> imageBytes: anObject [
	imageBytes := anObject
]

{ #category : #accessing }
GtLImageData >> imageType [
	^ imageType
]

{ #category : #accessing }
GtLImageData >> imageType: anObject [
	imageType := anObject
]

{ #category : #initialization }
GtLImageData >> initializeWithPngBytes: aByteArray [
	self imageBytes: aByteArray.
	self imageType: 'png'.
]

{ #category : #accessing }
GtLImageData >> llmImageDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView imageData
			imageBytes: [ self encodedBytes ];
			imageType: imageType
]

{ #category : #printing }
GtLImageData >> printOn: aStream [ 
	aStream << ('data:image/',self imageType,';base64') 
]

{ #category : #'gt - extensions' }
GtLImageData >> skiaImage [
	^SkiaImage
		fromBuffer: imageBytes
		start: 0
		end: imageBytes size - 1
]
