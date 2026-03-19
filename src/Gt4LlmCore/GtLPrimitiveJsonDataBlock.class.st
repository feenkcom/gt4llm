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
	commonKeys := self keysForMerge 
		intersection: anotherJsonBlock keysForMerge.
	commonKeys ifNotEmpty: [
		Error signal: ('Cannot merge json objects. Common keys found: '
			, commonKeys sorted asCommaString) ].
		
	anotherJsonBlock llmJsonData keysAndValuesDo: [ :aKey :aValue |
		jsonData 
			at: aKey
			ifPresent: [ :existingValue |
				Error signal: 'Key already present: ', aKey asString]
			ifAbsent: [ jsonData  
				at: aKey
				put: aValue ] ]
]

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> addJsonBlock: anotherJsonBlock disabiguatingKeys: allowedDuplicatedKeys [
	| commonKeys notAllowedCommonKeys |
	commonKeys := self keysForMerge 
		intersection: anotherJsonBlock keysForMerge.
	notAllowedCommonKeys := commonKeys copyWithoutAll: allowedDuplicatedKeys.
	notAllowedCommonKeys  ifNotEmpty: [ 
		Error signal: ('Cannot merge json objects. Common keys found: '
			, notAllowedCommonKeys sorted asCommaString)  ].
		
	anotherJsonBlock llmJsonData keysAndValuesDo: [ :aKey :aValue |
		| targetKey |
		targetKey := aKey.
		((jsonData includesKey: aKey) and: [ allowedDuplicatedKeys includes: aKey ]) ifTrue: [
				| newKey |
				newKey := self disambiguateKey: aKey in: jsonData.
				targetKey := newKey ].
		
		jsonData 
			at: targetKey
			ifPresent: [ :existingValue |
				Error signal: 'Key already present: ', targetKey asString ]
			ifAbsent: [ jsonData  
				at: targetKey
				put: aValue ] ]
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> containedJsonDataBlocksCount [
	"Return 1 as this block itself counts as a single json data block."
	^ 1
]

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> disambiguateKey: aKey in: aJsonDictionary [
	| newKey index |
	
	index := 0.
	newKey := aKey.
	[ 
		(index > 100) ifTrue: [
				Error signal: ''].
		index := index + 1.
		newKey := aKey, '_', index asString.
	] doWhileTrue: [
		aJsonDictionary includesKey: newKey ].
	
	^ newKey
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
GtLPrimitiveJsonDataBlock >> keysForMerge [
	^self dataKey
		ifNil: [ 
			(self jsonData isDictionary)
				ifTrue: [ self jsonData keys ]
				ifFalse: [ #() ] ] 
		ifNotNil: [
			{self dataKey} ]
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

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> serializedJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self llmJsonData
]
