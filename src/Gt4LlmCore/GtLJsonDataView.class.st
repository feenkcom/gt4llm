Class {
	#name : #GtLJsonDataView,
	#superclass : #GtLPrimitiveDataView,
	#instVars : [
		'jsonObjectComputationBlock',
		'computedJsonObject'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt - extensions' }
GtLJsonDataView >> gtViewJsonObjectFor: aView [
	<gtView>
	
	jsonObjectComputationBlock ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'JSON Object';
		priority: 10;
		object: [ self llmJsonObject  asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtLJsonDataView >> gtViewJsonStringFor: aView [
	<gtView>
	
	jsonObjectComputationBlock ifNil: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'JSON string';
		priority: 12;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		text: [  self llmJsonString  ]
]

{ #category : #accessing }
GtLJsonDataView >> jsonObject: aBlockClosure [
	jsonObjectComputationBlock := aBlockClosure
]

{ #category : #serialization }
GtLJsonDataView >> llmJsonObject [
	^computedJsonObject ifNil: [
		computedJsonObject := jsonObjectComputationBlock value ]
]

{ #category : #serialization }
GtLJsonDataView >> llmJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonObject
]

{ #category : #serialization }
GtLJsonDataView >> serializeToAnthropicResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: 'text' put: self llmJsonString;
			at: 'type' put: 'text';
			yourself}
]

{ #category : #serialization }
GtLJsonDataView >> serializeToOpenAIResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self llmJsonString;
			at: #type put: #input_text;
			yourself}
]
