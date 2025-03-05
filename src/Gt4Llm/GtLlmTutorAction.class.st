Class {
	#name : #GtLlmTutorAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'examples',
		'pipeline',
		'description',
		'format',
		'priority',
		'tutor',
		'definingMethod'
	],
	#category : 'Gt4Llm'
}

{ #category : #other }
GtLlmTutorAction class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> addExample: anExample [
	examples add: (anExample action: self)
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> asExpressionSource [
	^ self class name asString
		, ' new
	    name: ' , self name storeString
		, ';
	    priority: ' , self priority asString
		, ';
		description: ' , self description storeString
		, ';
		format: ' , self format storeString
		, ';
		examples: {' , ('.
			' join: (self examples collect: #asExpressionSource)) , '}'
]

{ #category : #accessing }
GtLlmTutorAction >> asInstructionPiece [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmInstructionComposite new
				addItem: self description;
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Examples';
						body: (GtLlmInstructionComposite new items: self examples)))
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> asMethodSource [
	| methodSource |
	methodSource := (self definingMethod
			ifNil: [ 'gtNAMEAction' ]
			ifNotNil: [ :aMethod | aMethod selector asString ])
			, '
	<gtLlmTutorAction>
	^ ' , self asExpressionSource.
	^ methodSource
]

{ #category : #accessing }
GtLlmTutorAction >> defaultPriority [
	^ 10
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> definingMethod [
	^ definingMethod
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> definingMethod: aMethod [
	definingMethod := nil
]

{ #category : #accessing }
GtLlmTutorAction >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorAction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> examples [
	^ examples
]

{ #category : #accessing }
GtLlmTutorAction >> examples: anObject [
	examples := anObject asOrderedCollection.

	examples do: [ :anExample | anExample action: self ]
]

{ #category : #accessing }
GtLlmTutorAction >> format [
	^ format
]

{ #category : #accessing }
GtLlmTutorAction >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> formatReferences [
	^ (self examples flatCollect: #formatReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtLlmTutorAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		text: [ self description ]
]

{ #category : #accessing }
GtLlmTutorAction >> gtExamplesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Examples';
		items: [ self examples ];
		column: 'Input' text: #inputJson;
		column: 'Output' text: #outputJson
]

{ #category : #accessing }
GtLlmTutorAction >> gtInputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmTutorAction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 2;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorAction >> gtOutputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> hasArgument [
	^ format formatCount > 0
]

{ #category : #accessing }
GtLlmTutorAction >> initialize [
	super initialize.

	self priority: self defaultPriority.
	self examples: OrderedCollection new.
	self name: ''.
	self description: ''.

	definingMethod := self initializeMethod
]

{ #category : #accessing }
GtLlmTutorAction >> initializeMethod [
	^ nil
]

{ #category : #accessing }
GtLlmTutorAction >> inputReferences [
	^ (self examples flatCollect: #inputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtLlmTutorAction >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorAction >> name: anObject [
	name := anObject.
	self format isEmptyOrNil ifTrue: [ self format: name ]
]

{ #category : #accessing }
GtLlmTutorAction >> onTutorChanged [
	self examples do: [ :anExample | anExample verify resolveReferences ]
]

{ #category : #accessing }
GtLlmTutorAction >> outputReferences [
	^ (self examples flatCollect: #outputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> persist [
	| methodSource |
	methodSource := self asMethodSource.

	self definingMethod methodClass
		compile: (RBConfigurableFormatter format: (RBParser parseMethod: methodSource)).
	definingMethod := self definingMethod methodClass
			>> self definingMethod selector
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline: anObject [
	pipeline := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLlmTutorAction >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmTutorAction >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> removeFromSystem [
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
]

{ #category : #accessing }
GtLlmTutorAction >> tutor [
	^ tutor
]

{ #category : #accessing }
GtLlmTutorAction >> tutor: anObject [
	tutor := anObject.
	
	self onTutorChanged
]
