Class {
	#name : #GtLJsonDataView,
	#superclass : #GtLDataViewDecorator,
	#instVars : [
		'jsonDataComputationBlock',
		'computedJsonData'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #'api - scripting' }
GtLJsonDataView >> data: aBlockClosure [
	jsonDataComputationBlock := aBlockClosure
]

{ #category : #'gt - extensions' }
GtLJsonDataView >> gtViewJsonDataFor: aView [
	<gtView>
	
	jsonDataComputationBlock ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ self llmJsonData  asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtLJsonDataView >> gtViewJsonStringFor: aView [
	<gtView>
	
	jsonDataComputationBlock ifNil: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'JSON string';
		priority: 12;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		text: [  self llmJsonString  ]
]

{ #category : #serialization }
GtLJsonDataView >> llmJsonData [
	^computedJsonData ifNil: [
		computedJsonData := jsonDataComputationBlock value ]
]

{ #category : #serialization }
GtLJsonDataView >> llmJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]

{ #category : #'api - scripting' }
GtLJsonDataView >> object: aBlockClosure [
	self data: [ 
		|jsonObject|
		jsonObject := Dictionary new.
		aBlockClosure value: jsonObject.
		jsonObject ]
]

{ #category : #serialization }
GtLJsonDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	| currentData |
	self 
		performComputation: [currentData := self llmJsonData ]
		onErrorDataDo: [ :anErrorData | ^ anErrorData ]
		withReason: 'Error computing target JSON object'
		withBuilder: aBuilder.
	
	aBuilder 
		addJsonDataBlockFor: currentData
		dataKey: self dataKey
		from: self
]
