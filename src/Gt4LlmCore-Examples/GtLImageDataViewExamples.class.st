"
I provide examples for GtLImageDataView.
"
Class {
	#name : #GtLImageDataViewExamples,
	#superclass : #GtLDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'examples - support' }
GtLImageDataViewExamples >> sampleImageBytes [
	<gtExample>
	| element form stream imageBytes |
	element := BlElement new
		size: 100@100;
		background: Color blue.
	
	form := BlExporter form element: element; export.
	stream := ByteArray new writeStream.
	PNGReadWriter putForm: form onStream: stream.
	imageBytes := stream contents.
	
	self assert: imageBytes isNotEmpty.
	
	^ imageBytes
]

{ #category : #examples }
GtLImageDataViewExamples >> standaloneImageDataViewWithoutDataKey [
	<gtExample>
	| basicView imageBytes |
	
	imageBytes := self sampleImageBytes.
	
	basicView := GtLImageDataView new
		png: [ imageBytes ].
	
	self assert: basicView title isNil.
	self assert: basicView dataKey isNil.
	self assert: basicView imageType equals: 'png'.
	self assert: basicView computedImageBytes equals: imageBytes.
	
	^ basicView
]

{ #category : #examples }
GtLImageDataViewExamples >> standaloneImageDataViewWithoutDataKey_serialization [
	<gtExample>
	| basicView dataBlock imageDataBlock imageBytes |
	
	imageBytes := self sampleImageBytes.
	basicView := self standaloneImageDataViewWithoutDataKey.
	dataBlock := basicView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: basicView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	imageDataBlock := dataBlock imageDataBlocks first.
	self assert: imageDataBlock sourceDataView equals: basicView.
	self assert: imageDataBlock dataKey isNil.
	self assert: imageDataBlock imageBytes equals: imageBytes.
	self assert: imageDataBlock imageType equals: 'png'.
	self assert: imageDataBlock encodedBytes equals: imageBytes base64Encoded.
	
	^ dataBlock
]
