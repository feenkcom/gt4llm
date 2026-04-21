Class {
	#name : #GtLPrimitiveMessageDataBuilder,
	#superclass : #Object,
	#instVars : [
		'messageDataBlock',
		'currentCompositeJsonDataBlock'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addDocumentBlockFor: aByteArray contentType: aContentType dataKey: aDataKey from: aDataView [
	self addDocumentDataBlock: (GtLPrimitiveDocumentDataBlock new 
		documentBytes: aByteArray;
		contentType: aContentType;
		dataKey: aDataKey;
		sourceDataView: aDataView)
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addDocumentDataBlock: aDocumentBlock [
	messageDataBlock addDocumentDataBlock: aDocumentBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addImageBlockFor: aByteArray type: anImageType dataKey: aDataKey from: aDataView [
	self addImageDataBlock: (GtLPrimitiveImageDataBlock new 
		imageBytes: aByteArray;
		imageType: anImageType;
		dataKey: aDataKey;
		sourceDataView: aDataView)
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addImageDataBlock: anImageBlock [
	messageDataBlock addImageDataBlock: anImageBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addJsonDataBlock: aJsonDataBlock [
	currentCompositeJsonDataBlock addJsonDataBlock: aJsonDataBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> addJsonDataBlockFor: aJsonData  dataKey: aDataKey from: aDataView [
	aJsonData isString ifTrue: [
		self addJsonDataBlock: (GtLPrimitiveJsonBareDataBlock new
			jsonData: aJsonData;
			dataKey: aDataKey;
			sourceDataView: aDataView).
		^self ].
	
	self addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: aJsonData;
		dataKey: aDataKey;
		sourceDataView: aDataView)
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> forArrayWithDataKey: aDataKey do: aBlock [
	| previousComposite |
	
	self assert: aDataKey notNil.
	
	^[
		previousComposite := currentCompositeJsonDataBlock.
		currentCompositeJsonDataBlock := GtLPrimitiveCompositeJsonArrayDataBlock new
			dataKey: aDataKey.
	
		aBlock value.
		
		currentCompositeJsonDataBlock containedJsonDataBlocksCount > 0 ifTrue: [
			previousComposite addJsonDataBlock: currentCompositeJsonDataBlock ].
	] 
		ensure: [
			currentCompositeJsonDataBlock := previousComposite ]
]

{ #category : #adding }
GtLPrimitiveMessageDataBuilder >> forDataKey: aDataKey do: aBlock [
	| previousComposite |
	
	aDataKey ifNil: [ ^aBlock value. ].
	
	^[
		previousComposite := currentCompositeJsonDataBlock.
		currentCompositeJsonDataBlock := GtLPrimitiveCompositeJsonGenericDataBlock new
			dataKey: aDataKey.
		previousComposite addJsonDataBlock: currentCompositeJsonDataBlock.
		
		aBlock value
	] 
		ensure: [
			currentCompositeJsonDataBlock := previousComposite ]
]

{ #category : #initialization }
GtLPrimitiveMessageDataBuilder >> initialize [ 
	super initialize.
	
	messageDataBlock := GtLPrimitiveMessageDataBlock new.
	currentCompositeJsonDataBlock := messageDataBlock compositeJsonDataBlock.
]

{ #category : #accessing }
GtLPrimitiveMessageDataBuilder >> messageDataBlock [
	^messageDataBlock
]

{ #category : #accessing }
GtLPrimitiveMessageDataBuilder >> sourceDataView: aDataView [
	messageDataBlock sourceDataView: aDataView
]
