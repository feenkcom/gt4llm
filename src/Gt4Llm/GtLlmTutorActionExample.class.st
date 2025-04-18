Class {
	#name : #GtLlmTutorActionExample,
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
GtLlmTutorActionExample class >> new [
	"Answer an initalised instance of the receiver.
	For GemStone compatibility."

	^ self basicNew initialize.
]

{ #category : #accessing }
GtLlmTutorActionExample >> action [
	^ action
]

{ #category : #accessing }
GtLlmTutorActionExample >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorActionExample >> asExpressionSource [
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
GtLlmTutorActionExample >> asInstructionPiece [
	^ GtLlmInstructionSection new
		source: self;
		title: 'Example';
		body: (GtLlmInstructionComposite new
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Prompt';
						body: ('```json
' , self inputJson
								, '
```') asInstructionPiece);
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Output';
						body: ('```json
' , self outputJson
								, '
```') asInstructionPiece))
]

{ #category : #accessing }
GtLlmTutorActionExample >> formatReferences [
	^ inputReferences, outputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtInputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtOutputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmTutorActionExample >> initialize [
	super initialize.
	
	inputReferences := OrderedCollection new.
	outputReferences := OrderedCollection new.
	self markVerified
]

{ #category : #accessing }
GtLlmTutorActionExample >> input [
	^ input
]

{ #category : #accessing }
GtLlmTutorActionExample >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputJson [
	^ STONJSON toStringPretty: self input
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputJson: aJson [
	^ self input: (STONJSON fromString: aJson)
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputReferences [
	^ inputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputReferences: anObject [
	inputReferences := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorActionExample >> markUnverified [
	unverified := true
]

{ #category : #'as yet unclassified' }
GtLlmTutorActionExample >> markVerified [
	unverified := false
]

{ #category : #accessing }
GtLlmTutorActionExample >> output [
	^ output
]

{ #category : #accessing }
GtLlmTutorActionExample >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputJson [
	^ STONJSON toStringPretty: self output
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputJson: aJson [
	^ self output: (STONJSON fromString: aJson)
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputReferences [
	^ outputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputReferences: anObject [
	outputReferences := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> resolveReferences [
	inputReferences := input associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action tutor formatNamed: anAssociation key)
					addInputReference: self action ].
	outputReferences := output associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action tutor formatNamed: anAssociation key)
					addOutputReference: self action ]
]

{ #category : #accessing }
GtLlmTutorActionExample >> unverified [
	^ unverified
]

{ #category : #accessing }
GtLlmTutorActionExample >> unverified: anObject [
	unverified := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> verify [
	unverified ifTrue: [ ^ self ].
	self
		assert: self output keys asSet
				= (self action tutor formatComponents collect: #name) asSet
		description: 'Keys in the example output must correspond to the action format'
]
