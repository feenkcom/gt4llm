Class {
	#name : #GtLPrimitiveImageDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'imageBytes',
		'imageType',
		'encodedBytes',
		'contentLabel'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveImageDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveImageDataBlock: self
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> contentLabel [
	^contentLabel
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> contentLabel: anObject [
	contentLabel := anObject
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> encodedBytes [
	^encodedBytes
]

{ #category : #views }
GtLPrimitiveImageDataBlock >> gtImageFor: aView [
	<gtView>
	
	imageBytes ifNil: [ ^aView empty ].
	
	^ aView forward
		title: 'Image';
		priority: 20;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> imageBytes [
	^imageBytes
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> imageBytes: anObject [
	imageBytes := anObject.
	encodedBytes := imageBytes base64Encoded.
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> imageType [
	^imageType
]

{ #category : #accessing }
GtLPrimitiveImageDataBlock >> imageType: anObject [
	imageType := anObject
]

{ #category : #serialization }
GtLPrimitiveImageDataBlock >> serializeForAnthropic [
	<return: #Array of: #NeoJSONObject>
	
	^{NeoJSONObject new
			at: 'type' put: 'image';
			at: 'source'put:  {
				'media_type' -> 'image/png'.
				'type' ->'base64'.
				'data' -> self encodedBytes } asDictionary;
			yourself}
]

{ #category : #serialization }
GtLPrimitiveImageDataBlock >> serializeForMCP [
	<return: #Array of: #NeoJSONObject>
	
	^{NeoJSONObject new
			at: 'type' put: 'image';
			at: 'data' put: self encodedBytes;
			at: 'mimeType' put: 'image/png';
			yourself}
]

{ #category : #serialization }
GtLPrimitiveImageDataBlock >> serializeForOllamaGenerate [
	<return: #Array of: #NeoJSONObject>

	^ { self encodedBytes }
]

{ #category : #serialization }
GtLPrimitiveImageDataBlock >> serializeForOllamaOpenAi [
	<return: #Array of: #NeoJSONObject>

	^ {NeoJSONObject new
			at: 'image_url' put: ('data:image/'
				,self imageType,';base64,' , self encodedBytes);
			at: 'type' put: 'image_url';
			yourself}
]

{ #category : #serialization }
GtLPrimitiveImageDataBlock >> serializeForOpenAI [
	<return: #Array of: #NeoJSONObject>
	
	^ {NeoJSONObject new
			at: 'image_url' put: ('data:image/'
				,self imageType,';base64,' , self encodedBytes);
			at: 'type' put: 'input_image';
			yourself}
]

{ #category : #views }
GtLPrimitiveImageDataBlock >> skiaImage [
	^SkiaImage
		fromBuffer: imageBytes
		start: 0
		end: imageBytes size - 1
]
