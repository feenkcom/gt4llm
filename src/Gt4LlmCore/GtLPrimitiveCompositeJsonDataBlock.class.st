Class {
	#name : #GtLPrimitiveCompositeJsonDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'jsonDataBlocks'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #adding }
GtLPrimitiveCompositeJsonDataBlock >> addJsonDataBlock: aJsonBlock [
	jsonDataBlocks add: aJsonBlock
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> condensedJsonBlock [
	^self subclassResponsibility
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> containedJsonDataBlocksCount [
	"Return the total number of contained json blocks, recursively counting nested composites."
	^ jsonDataBlocks inject: 0 into: [ :sum :each |
			sum + each containedJsonDataBlocksCount ]
]

{ #category : #'gt - extensions' }
GtLPrimitiveCompositeJsonDataBlock >> gtPhlowTreeChildren [
	^ jsonDataBlocks
]

{ #category : #'gt - extensions' }
GtLPrimitiveCompositeJsonDataBlock >> gtViewDataBlocksFor: aView [
	<gtView>
	
	^(aView columnedTree)
		title: 'Data Blocks';
		priority: 5;
		items: [ self jsonDataBlocks];
		children: [ :each | each gtPhlowTreeChildren  ];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #'gt - extensions' }
GtLPrimitiveCompositeJsonDataBlock >> gtViewJsonDataFor: aView [
	<gtView>
	
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ self llmJsonData  asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtLPrimitiveCompositeJsonDataBlock >> gtViewJsonStringFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'JSON string';
		priority: 12;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		text: [  self serializedJsonString  ]
]

{ #category : #initialize }
GtLPrimitiveCompositeJsonDataBlock >> initialize [
	super initialize.
	
	jsonDataBlocks := OrderedCollection new.
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> jsonDataBlocks [
	^jsonDataBlocks
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> llmJsonData [
	^self dataKey
		ifNil: [ self condensedJsonBlock llmJsonData] 
		ifNotNil: [
			Dictionary new 
				at: self dataKey put: self condensedJsonBlock llmJsonData;
				yourself]
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForAnthropic [
	^ self condensedJsonBlock serializeForAnthropic 
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForMCP [
	^ self condensedJsonBlock serializeForMCP 
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForOllamaGenerate [
	^ self condensedJsonBlock serializeForOllamaGenerate
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForOllamaOpenAi [
	^ self condensedJsonBlock serializeForOllamaOpenAi
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForOpenAI [
	^ self condensedJsonBlock serializeForOpenAI 
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> serializedJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]
