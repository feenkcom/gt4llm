Class {
	#name : #GtLPrimitiveMessageDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'compositeJsonDataBlock',
		'imageDataBlocks',
		'documentDataBlocks'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #adding }
GtLPrimitiveMessageDataBlock >> addDocumentDataBlock: aDocumentBlock [
	documentDataBlocks add: aDocumentBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBlock >> addImageDataBlock: anImageBlock [
	imageDataBlocks add: anImageBlock
]

{ #category : #adding }
GtLPrimitiveMessageDataBlock >> addJsonDataBlock: aJsonBlock [
	compositeJsonDataBlock addJsonDataBlock: aJsonBlock
]

{ #category : #utils }
GtLPrimitiveMessageDataBlock >> compositeJsonData [
	^compositeJsonDataBlock llmJsonData
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
	| blocks |
	blocks := OrderedCollection new.
	compositeJsonDataBlock containedJsonDataBlocksCount > 0
		ifTrue: [ blocks add: compositeJsonDataBlock ].
	blocks addAll: imageDataBlocks.
	blocks addAll: documentDataBlocks.
	^ blocks
]

{ #category : #accessing }
GtLPrimitiveMessageDataBlock >> documentDataBlocks [
	^ documentDataBlocks
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtPhlowTreeChildren [
	^ self dataBlocks
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtViewCondensedJsonDataFor: aView [
	<gtView>
	^(aView forward)
		title: 'JSON Data';
		priority: 15;
		object: [self compositeJsonDataBlock];
		view: #gtViewJsonDataFor:
]

{ #category : #views }
GtLPrimitiveMessageDataBlock >> gtViewCondensedJsonStringFor: aView [
	<gtView>
	^(aView forward)
		title: 'JSON String';
		priority: 15.1;
		object: [self compositeJsonDataBlock];
		view: #gtViewJsonStringFor:
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
	
	compositeJsonDataBlock := GtLPrimitiveCompositeJsonGenericDataBlock new.
	imageDataBlocks := OrderedCollection new.
	documentDataBlocks := OrderedCollection new.
]

{ #category : #utils }
GtLPrimitiveMessageDataBlock >> llmJsonData [
	^compositeJsonDataBlock llmJsonData
]

{ #category : #accessing }
GtLPrimitiveMessageDataBlock >> secondaryDataBlocks [
	| blocks |
	blocks := OrderedCollection new.
	blocks addAll: imageDataBlocks.
	documentDataBlocks ifNotNil: [ blocks addAll: documentDataBlocks ].
	^ blocks
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForAnthropic [
	^ self dataBlocks 
			flatCollect: [ :each |
				each serializeForAnthropic ] 
			as: Array
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForMCP [
	^ self dataBlocks 
			flatCollect: [ :each |
				each serializeForMCP ] 
			as: Array
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForOllamaGenerate [
	^ self dataBlocks 
			flatCollect: [ :each |
				each serializeForOllamaGenerate ] 
			as: Array
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForOllamaOpenAi [
	^ self dataBlocks 
			flatCollect: [ :each |
				each serializeForOllamaOpenAi ] 
			as: Array
]

{ #category : #serialization }
GtLPrimitiveMessageDataBlock >> serializeForOpenAI [
	^ self dataBlocks 
			flatCollect: [ :each |
				each serializeForOpenAI ] 
			as: Array
]
