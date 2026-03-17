Class {
	#name : #GtLPrimitiveCompositeJsonDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'jsonDataBlocks'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPrimitiveCompositeJsonDataBlock >> addJsonDataBlock: aJsonBlock [
	jsonDataBlocks add: aJsonBlock
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> condensedJsonBlock [
	^jsonDataBlocks 
		inject: (GtLPrimitiveJsonDataBlock new
			jsonData: Dictionary new) 
		into: [ :resultBlock :currentBlock |
			resultBlock addJsonBlock: currentBlock.
			resultBlock	]
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
		priority: 10;
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
	| computedJsonData|
	computedJsonData := self condensedJsonBlock jsonData.
	^self dataKey 
		ifNil: [ computedJsonData ] 
		ifNotNil: [ 
			Dictionary new
				at: self dataKey put: computedJsonData;
				yourself ]
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonDataBlock >> serializedJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForAnthropic [
	^ self condensedJsonBlock serializeForAnthropic 
]

{ #category : #serialization }
GtLPrimitiveCompositeJsonDataBlock >> serializeForOpenAI [
	^ self condensedJsonBlock serializeForOpenAI 
]
