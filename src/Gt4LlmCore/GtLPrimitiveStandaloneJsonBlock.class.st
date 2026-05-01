Class {
	#name : #GtLPrimitiveStandaloneJsonBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'jsonData'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveStandaloneJsonBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveStandaloneJsonBlock: self
]

{ #category : #accessing }
GtLPrimitiveStandaloneJsonBlock >> containedJsonDataBlocksCount [
	"Return 1 as this block itself counts as a single json data block."
	^ 1
]

{ #category : #views }
GtLPrimitiveStandaloneJsonBlock >> gtViewJsonDataFor: aView [
	<gtView>
	
	jsonData ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ self llmJsonData  asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #views }
GtLPrimitiveStandaloneJsonBlock >> gtViewJsonStringFor: aView [
	<gtView>
	
	jsonData ifNil: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'JSON string';
		priority: 12;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		text: [  self serializedJsonString  ]
]

{ #category : #accessing }
GtLPrimitiveStandaloneJsonBlock >> jsonData [
	^jsonData
]

{ #category : #accessing }
GtLPrimitiveStandaloneJsonBlock >> jsonData: anObject [
	jsonData := anObject
]

{ #category : #accessing }
GtLPrimitiveStandaloneJsonBlock >> llmJsonData [
	^self dataKey
		ifNil: [ self jsonData] 
		ifNotNil: [
			Dictionary new 
				at: self dataKey put: self jsonData;
				yourself]
]

{ #category : #serialization }
GtLPrimitiveStandaloneJsonBlock >> serializeForAnthropic [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: 'text' put: self serializedJsonString;
			at: 'type' put: 'text';
			yourself}
]

{ #category : #serialization }
GtLPrimitiveStandaloneJsonBlock >> serializeForMCP [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	
	^ {NeoJSONObject new
			at: 'type' put: 'text';
			at: 'text' put: self serializedJsonString;
			yourself}
]

{ #category : #serialization }
GtLPrimitiveStandaloneJsonBlock >> serializeForOllamaGenerate [
	"Return a JSON that represents tool response output."
	<return: #Array of: #NeoJSONObject>
	
	^ {NeoJSONObject new
			at: #prompt put: self serializedJsonString;
			yourself}
]

{ #category : #serialization }
GtLPrimitiveStandaloneJsonBlock >> serializeForOllamaOpenAi [
	"Return a JSON that represents tool response output."
	<return: #Array of: #NeoJSONObject>
	
	^ {NeoJSONObject new
			at: #text put: self serializedJsonString;
			at: #type put: #text;
			yourself}
]

{ #category : #serialization }
GtLPrimitiveStandaloneJsonBlock >> serializeForOpenAI [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self serializedJsonString;
			at: #type put: #input_text;
			yourself}
]

{ #category : #accessing }
GtLPrimitiveStandaloneJsonBlock >> serializedJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]
