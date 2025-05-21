Class {
	#name : #GtLlmAssistantAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'examples',
		'pipeline',
		'description',
		'format',
		'priority',
		'definingMethod',
		'assistant',
		'arguments'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmAssistantAction class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> addArgument: anArgument [
	arguments add: anArgument
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> addExample: anExample [
	examples add: (anExample action: self)
]

{ #category : #accessing }
GtLlmAssistantAction >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLlmAssistantAction >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> asExpressionSource [
	^ self class name asString
		, ' new
	    name: ' , self name storeString
		, ';
	    priority: ' , self priority asString
		, ';
		description: ' , self description storeString
		, (self arguments
				collect: [ :anArgument | 
					';
		addArgument: ''' , anArgument , '''' ])
		, ';
		examples: {'
		, ('.
			' join: (self examples collect: #asExpressionSource)) , '}'
]

{ #category : #accessing }
GtLlmAssistantAction >> asInstructionPiece [
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
GtLlmAssistantAction >> asMethodSource [
	| methodSource |
	methodSource := (self definingMethod
			ifNil: [ 'gtNAMEAction' ]
			ifNotNil: [ :aMethod | aMethod selector asString ])
			, '
	<gtLlmAssistantAction>
	^ ' , self asExpressionSource.
	^ methodSource
]

{ #category : #accessing }
GtLlmAssistantAction >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLlmAssistantAction >> assistant: anObject [
	assistant := anObject.
	
	self onAssistantChanged
]

{ #category : #accessing }
GtLlmAssistantAction >> defaultPriority [
	^ 10
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> definingMethod [
	^ definingMethod
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> definingMethod: aMethod [
	definingMethod := nil
]

{ #category : #accessing }
GtLlmAssistantAction >> description [
	^ description
]

{ #category : #accessing }
GtLlmAssistantAction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmAssistantAction >> examples [
	^ examples
]

{ #category : #accessing }
GtLlmAssistantAction >> examples: anObject [
	examples := anObject asOrderedCollection.

	examples do: [ :anExample | anExample action: self ]
]

{ #category : #accessing }
GtLlmAssistantAction >> formatReferences [
	^ (self examples flatCollect: #formatReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtLlmAssistantAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		text: [ self description ]
]

{ #category : #accessing }
GtLlmAssistantAction >> gtExamplesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Examples';
		items: [ self examples ];
		column: 'Input' text: #inputJson;
		column: 'Output' text: #outputJson
]

{ #category : #accessing }
GtLlmAssistantAction >> gtInputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmAssistantAction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 2;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmAssistantAction >> gtOutputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> hasArgument [
	^ arguments isNotEmpty
]

{ #category : #accessing }
GtLlmAssistantAction >> initialize [
	super initialize.

	self priority: self defaultPriority.
	self examples: OrderedCollection new.
	self arguments: OrderedCollection new.
	self name: ''.
	self description: ''.

	definingMethod := self initializeMethod
]

{ #category : #accessing }
GtLlmAssistantAction >> inputReferences [
	^ (self examples flatCollect: #inputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtLlmAssistantAction >> name [
	^ name
]

{ #category : #accessing }
GtLlmAssistantAction >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmAssistantAction >> onAssistantChanged [
	self examples do: [ :anExample | anExample verify resolveReferences ]
]

{ #category : #accessing }
GtLlmAssistantAction >> outputReferences [
	^ (self examples flatCollect: #outputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> persist [
	| methodSource |
	methodSource := self asMethodSource.

	"TODO: RBConfigurableFormatter and RBParser are defined as part of Rowan.
	It needs to be exported to .gs to be usable in GemStone"
	self definingMethod methodClass
		compile: (#RBConfigurableFormatter asClass format: (#RBParser asClass parseMethod: methodSource)).
	definingMethod := self definingMethod methodClass
			>> self definingMethod selector
]

{ #category : #accessing }
GtLlmAssistantAction >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmAssistantAction >> pipeline: anObject [
	pipeline := anObject
]

{ #category : #accessing }
GtLlmAssistantAction >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLlmAssistantAction >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmAssistantAction >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantAction >> removeFromSystem [
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
]
