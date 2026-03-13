Class {
	#name : #GtLImageDataView,
	#superclass : #GtLPrimitiveDataView,
	#instVars : [
		'imageType',
		'imageBytesComputation',
		'computedImageBytes'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLImageDataView class >> fromElement: anElement [
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
GtLImageDataView class >> png: aBlockClosure [
	^ self new png: aBlockClosure
]

{ #category : #accessing }
GtLImageDataView >> computedImageBytes [
	^computedImageBytes ifNil: [
		computedImageBytes := imageBytesComputation value ]
]

{ #category : #accessing }
GtLImageDataView >> encodedBytes [
	^ self computedImageBytes base64Encoded
]

{ #category : #'gt - extensions' }
GtLImageDataView >> gtImageFor: aView [
	<gtView>
	
	imageBytesComputation ifNil: [ ^aView empty ].
	
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #accessing }
GtLImageDataView >> imageBytes: anObject [
	imageBytesComputation := anObject
]

{ #category : #accessing }
GtLImageDataView >> imageType [
	^ imageType
]

{ #category : #accessing }
GtLImageDataView >> imageType: anObject [
	imageType := anObject
]

{ #category : #initialization }
GtLImageDataView >> initializeWithPngBytesComputation: aByteArray [
	self imageBytes: aByteArray.
	self imageType: 'png'.
]

{ #category : #accessing }
GtLImageDataView >> png: aBlockClosure [
	self initializeWithPngBytesComputation: aBlockClosure
]

{ #category : #printing }
GtLImageDataView >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << ('data:image/',self imageType,';base64,') ]
]

{ #category : #serialization }
GtLImageDataView >> serializeToAnthropicResponseOutput [
	<return: #Array of: #NeoJSONObject>
	
	^{ NeoJSONObject new
			at: 'type' put: 'image';
			at: 'source'put:  {
				'media_type' -> 'image/png'.
				'type' ->'base64'.
				'data' -> self encodedBytes } asDictionary;
			yourself}
]

{ #category : #serialization }
GtLImageDataView >> serializeToOpenAIResponseOutput [
	<return: #Array of: #NeoJSONObject>
	"Return a JSON that represents tool response output.
	See GtLToolMessage>>#serializeForOpenAIResponsesAPI for more information."
	
	^ {NeoJSONObject new
			at: 'image_url' put: ('data:image/'
				,self imageType,';base64,' , self encodedBytes);
			at: 'type' put: 'input_image';
			yourself}
]

{ #category : #'gt - extensions' }
GtLImageDataView >> skiaImage [
	| currentBytes  |
	currentBytes := self computedImageBytes.
	^SkiaImage
		fromBuffer: currentBytes
		start: 0
		end: currentBytes size - 1
]
