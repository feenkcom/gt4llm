Class {
	#name : #GtLPrimitiveImageData,
	#superclass : #GtLPrimitiveData,
	#instVars : [
		'imageType',
		'imageBytes'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPrimitiveImageData class >> fromElement: anElement [
	| rootElement form |
	rootElement := BlScripter new
			element: anElement;
			elementWithoutParent.
	form := BlExporter png
			element: rootElement;
			doExport: [ :aCanvas | aCanvas asForm ].
	^ self png: (ByteArray
		streamContents: [ :out | PNGReadWriter putForm: form onStream: out ])
]

{ #category : #'instance creation' }
GtLPrimitiveImageData class >> png: aByteArray [
	^ self new 
		 initializeWithPngBytes: aByteArray
]

{ #category : #accessing }
GtLPrimitiveImageData >> encodedBytes [
	^ imageBytes base64Encoded
]

{ #category : #'gt - extensions' }
GtLPrimitiveImageData >> gtImageFor: aView [
	<gtView>
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #accessing }
GtLPrimitiveImageData >> imageBytes: anObject [
	imageBytes := anObject
]

{ #category : #accessing }
GtLPrimitiveImageData >> imageType [
	^ imageType
]

{ #category : #accessing }
GtLPrimitiveImageData >> imageType: anObject [
	imageType := anObject
]

{ #category : #initialization }
GtLPrimitiveImageData >> initializeWithPngBytes: aByteArray [
	self imageBytes: aByteArray.
	self imageType: 'png'.
]

{ #category : #printing }
GtLPrimitiveImageData >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << ('data:image/',self imageType,';base64,').
		aStream print: self encodedBytes]
]

{ #category : #serialization }
GtLPrimitiveImageData >> serializeToOpenAIResponseOutput [
	"Return a JSON that represents tool response output.
	See GtLToolMessage>>#serializeForOpenAIResponsesAPI for more information."

	<return: #Array of: #NeoJSONObject>
	
	^ NeoJSONObject new
			at: #image_url put: ('data:image/',self imageType,';base64,' , self encodedBytes);
			at: #type put: #input_image;
			yourself
]

{ #category : #'gt - extensions' }
GtLPrimitiveImageData >> skiaImage [
	^SkiaImage
		fromBuffer: imageBytes
		start: 0
		end: imageBytes size - 1
]
