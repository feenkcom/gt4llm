Class {
	#name : #GtLPrimitiveJsonDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'jsonData'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> addJsonBlock: anotherJsonBlock [
	| commonKeys |
	commonKeys := jsonData keys 
		intersection: anotherJsonBlock llmJsonData keys.
	commonKeys ifNotEmpty: [ 
		Error signal: ('Cannot merge json objects. Common keys found: '
			, commonKeys sorted asCommaString)  ].
		
	anotherJsonBlock llmJsonData keysAndValuesDo: [ :aKey :aValue |
		jsonData 
			at: aKey
			ifPresent: [ :existingValue |
				Error signal: 'Key already present: ', aKey asString]
			ifAbsent: [ jsonData  
				at: aKey
				put: aValue ] ]
]

{ #category : #views }
GtLPrimitiveJsonDataBlock >> gtViewJsonDataFor: aView [
	<gtView>
	
	jsonData ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ self llmJsonData  asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #views }
GtLPrimitiveJsonDataBlock >> gtViewJsonStringFor: aView [
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
GtLPrimitiveJsonDataBlock >> jsonData [
	^jsonData
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> jsonData: anObject [
	jsonData := anObject
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> jsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self jsonData
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> llmJsonData [
	^self dataKey
		ifNil: [ self jsonData] 
		ifNotNil: [
			Dictionary new 
				at: self dataKey put: self jsonData;
				yourself]
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> serializedJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]

{ #category : #serialization }
GtLPrimitiveJsonDataBlock >> serializeForAnthropic [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: 'text' put: self serializedJsonString;
			at: 'type' put: 'text';
			yourself}
]

{ #category : #serialization }
GtLPrimitiveJsonDataBlock >> serializeForOpenAI [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self serializedJsonString;
			at: #type put: #input_text;
			yourself}
]
