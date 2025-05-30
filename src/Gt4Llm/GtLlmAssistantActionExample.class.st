Class {
	#name : #GtLlmAssistantActionExample,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'inputReferences',
		'action',
		'outputReferences',
		'unverified'
	],
	#category : #Gt4Llm
}

{ #category : #'instance creation' }
GtLlmAssistantActionExample class >> new [
	"Answer an initalised instance of the receiver.
	For GemStone compatibility."

	^ self basicNew initialize.
]

{ #category : #accessing }
GtLlmAssistantActionExample >> action [
	^ action
]

{ #category : #accessing }
GtLlmAssistantActionExample >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantActionExample >> asExpressionSource [
	^ self class name asString
		, ' new
	input: { '
		, ('. '
				join: (self input associations
						collect: [ :aPair | 
							'''' , aPair key , ''' -> '
								, (aPair value ifNil: [ 'nil' ] ifNotNil: [ :aValue | aValue storeString ]) ]))
		, ' } asDictionary;
	output: { '
		, ('. '
				join: (self output associations
						collect: [ :aPair | 
							'''' , aPair key , ''' -> '
								, (aPair value ifNil: [ 'nil' ] ifNotNil:[ :aValue | aValue storeString ]) ]))
		, ' } asDictionary'
]

{ #category : #accessing }
GtLlmAssistantActionExample >> asInstructionPiece [
	^ GtLlmInstructionList new
		source: self;
		addItem: ('Prompt:
```json
' , self inputJson
				, '
```') asInstructionPiece;
		addItem: ('Output:
```json
' , self outputJson
				, '
```') asInstructionPiece
]

{ #category : #accessing }
GtLlmAssistantActionExample >> formatReferences [
	^ inputReferences, outputReferences
]

{ #category : #accessing }
GtLlmAssistantActionExample >> gtInputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmAssistantActionExample >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmAssistantActionExample >> gtOutputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmAssistantActionExample >> initialize [
	super initialize.
	
	inputReferences := OrderedCollection new.
	outputReferences := OrderedCollection new.
	self markVerified
]

{ #category : #accessing }
GtLlmAssistantActionExample >> input [
	^ input
]

{ #category : #accessing }
GtLlmAssistantActionExample >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmAssistantActionExample >> inputJson [
	^ STONJSON toStringPretty: self input
]

{ #category : #accessing }
GtLlmAssistantActionExample >> inputJson: aJson [
	^ self input: (STONJSON fromString: aJson)
]

{ #category : #accessing }
GtLlmAssistantActionExample >> inputReferences [
	^ inputReferences
]

{ #category : #accessing }
GtLlmAssistantActionExample >> inputReferences: anObject [
	inputReferences := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantActionExample >> markUnverified [
	unverified := true
]

{ #category : #'as yet unclassified' }
GtLlmAssistantActionExample >> markVerified [
	unverified := false
]

{ #category : #accessing }
GtLlmAssistantActionExample >> output [
	^ output
]

{ #category : #accessing }
GtLlmAssistantActionExample >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLlmAssistantActionExample >> outputJson [
	^ STONJSON toStringPretty: self output
]

{ #category : #accessing }
GtLlmAssistantActionExample >> outputJson: aJson [
	^ self output: (STONJSON fromString: aJson)
]

{ #category : #accessing }
GtLlmAssistantActionExample >> outputReferences [
	^ outputReferences
]

{ #category : #accessing }
GtLlmAssistantActionExample >> outputReferences: anObject [
	outputReferences := anObject
]

{ #category : #accessing }
GtLlmAssistantActionExample >> resolveReferences [
	inputReferences := input associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action assistant formatNamed: anAssociation key)
					addInputReference: self action ].
	outputReferences := output associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action assistant formatNamed: anAssociation key)
					addOutputReference: self action ]
]

{ #category : #accessing }
GtLlmAssistantActionExample >> unverified [
	^ unverified
]

{ #category : #accessing }
GtLlmAssistantActionExample >> unverified: anObject [
	unverified := anObject
]

{ #category : #accessing }
GtLlmAssistantActionExample >> verify [
	unverified ifTrue: [ ^ self ].
	self
		assert: self output keys asSet
				= (self action assistant formatComponents collect: #name) asSet
		description: 'Keys in the example output must correspond to the action format'
]
