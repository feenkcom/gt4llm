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
	#category : #'Gt4Llm-Actions'
}

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> addExample: anExample [
	examples add: (anExample action: self)
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> asExpression [
	^ self class name asString
		, ' new
	name: ''' , self name
		, ''';
	priority: ' , self priority asString
		, ';
		description: ''' , self description
		, ''';
		examples: {' , ('.
			' join: (self examples collect: #asExpression)) , '}'
]

{ #category : #accessing }
GtLlmTutorAction >> asInstruction [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmCompositeInstruction new
				addItem: self description;
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Examples';
						body: (GtLlmCompositeInstruction new items: self examples)))
]

{ #category : #accessing }
GtLlmTutorAction >> defaultPriority [
	^ 10
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> definingMethod [
	^ definingMethod
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
GtLlmTutorAction >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		beRequired;
		priority: 3;
		accessor: #description
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
GtLlmTutorAction >> examplesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Examples';
		priority: 5;
		accessor: #examples;
		classes: {GtLlmTutorActionExample};
		beModifiable;
		blocItemStencil: [ :anItemViewModel :anItemIndex | 
			anItemViewModel asElement
				fitContent;
				border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1);
				margin: (BlInsets
						top: 0
						right: 5
						bottom: 5
						left: 0);
				padding: (BlInsets all: 5);
				background: Color white ];
		  newItemStencil: [ GtLlmTutorActionExample new ]
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
GtLlmTutorAction >> formatDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Format';
		beRequired;
		priority: 5;
		accessor: #format
]

{ #category : #accessing }
GtLlmTutorAction >> formatReferences [
	^ (self examples flatCollect: #formatReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutorAction >> gtDefinitionFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
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
		object: [self asInstruction ];
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
	
	definingMethod := (thisContext stack at: 3) blocDefiningMethod
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
	self format ifNil: [ self format: name ]
]

{ #category : #accessing }
GtLlmTutorAction >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		beRequired;
		priority: 1;
		accessor: #name
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
	self definingMethod methodClass
		compile: self definingMethod selector asString
				, '
	<gtLlmAction>
	^ ' , self asExpression.
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

{ #category : #accessing }
GtLlmTutorAction >> priorityDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Priority';
		priority: 2;
		accessor: #priority
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
