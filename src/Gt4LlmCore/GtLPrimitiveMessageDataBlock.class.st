Class {
	#name : #GtLPrimitiveMessageDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'compositeJsonDataBlock',
		'imageDataBlocks'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPrimitiveMessageDataBlock >> addImageDataBlock: anImageBlock [
	imageDataBlocks add: anImageBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBlock >> addJsonDataBlock: aJsonBlock [
	compositeJsonDataBlock addJsonDataBlock: aJsonBlock
]

{ #category : #utils }
GtLPrimitiveMessageDataBlock >> compositeJsonDataBlock [
	^compositeJsonDataBlock
]

{ #category : #accessing }
GtLPrimitiveMessageDataBlock >> containedJsonDataBlocksCount [
	^ compositeJsonDataBlock containedJsonDataBlocksCount
]

{ #category : #accessing }
GtLPrimitiveMessageDataBlock >> dataBlocks [
	^{self compositeJsonDataBlock} , imageDataBlocks
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtPhlowTreeChildren [
	^ self dataBlocks
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtViewCondensedJsonDataFor: aView [
	<gtView>
	^(aView forward)
		title: 'Condensed JSON Data';
		priority: 15;
		object: [self compositeJsonDataBlock];
		view: #gtViewJsonDataFor:
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtViewDataBlocksFor: aView [
	<gtView>
	^(aView columnedTree)
		title: 'Data Blocks';
		priority: 10;
		items: [self dataBlocks];
		expandAll;
		children: [ :each | each gtPhlowTreeChildren  ];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #accessing }
GtLPrimitiveMessageDataBlock >> imageDataBlocks [
	^imageDataBlocks
]

{ #category : #initialization }
GtLPrimitiveMessageDataBlock >> initialize [
	super initialize.
	
	compositeJsonDataBlock := GtLPrimitiveCompositeJsonDataBlock new.
	imageDataBlocks := OrderedCollection new.
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForAnthropic [
	^ self dataBlocks flatCollect: [ :each |
			each serializeForAnthropic ] 
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForOpenAI [
	^ self dataBlocks flatCollect: [ :each |
			each serializeForOpenAI ] 
]
