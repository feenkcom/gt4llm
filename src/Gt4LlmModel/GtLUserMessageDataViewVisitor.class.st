Class {
	#name : #GtLUserMessageDataViewVisitor,
	#superclass : #Object,
	#instVars : [
		'stream',
		'stack'
	],
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitGtLCompositeDataView: aView [

	stack add: aView dataKey -> aView.
	aView dataViews do: [ :dataView |
		dataView acceptVisitor: self ].
	stack removeLast.
]

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitGtLForwardObjectDataView: aView [

	stack add: aView dataKey -> aView.
	aView targetDataView acceptVisitor: self.
	stack removeLast.
]

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitGtLImageDataView: aView [

	stream nextPut: 'image' -> aView encodedBytes
]

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitGtLJsonDataView: aView [

	stream nextPut: 'content' -> aView llmJsonString
]

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitGtLMagritteDataView: aView [

	stream nextPutAll: aView computeTargetView llmJsonData associations
]

{ #category : #visitor }
GtLUserMessageDataViewVisitor >> visitNodes: aCollection [

	stack := OrderedCollection new.
	^ Array streamContents: [ :aStream |
		stream := aStream.
		aCollection do: [ :each |
			each acceptVisitor: self ] ].
]
