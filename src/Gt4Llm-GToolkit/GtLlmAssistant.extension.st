Extension { #name : #GtLlmAssistant }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistant >> addInstructionSectionForLepiterPages: pageNames titled: title [
	| instructionString |
	instructionString := String cr
			join: (pageNames
					collect: [ :pageName | 
						GtLlmLepiterContentExporter new
							startHeaderLevel: 2;
							page: (LeDatabase gtBook pageNamed: pageName);
							export ]).
	self
		addInstructionSection: (GtLlmInstructionSection new
				title: title;
				body: instructionString)
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistant >> gtActionsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.

	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ self instruction ];
		view: #gtActionsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						methodCoderViewModelValueHolder: valueHolder;
						onMethodCoderSaved: [ self recomputeActions.
							anElement phlow fireToolUpdateWish.
							anElement fireEvent: BrDropdownHideWish new ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtACTIONNAME
 	<gtLlmAssistantAction>
 	^ GtLlmAssistantAction new
 		name: '''';
 		priority: 1;
 		description: '''';
 		examples: {}'.
				methodCoder ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistant >> gtFormatComponentsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.
	^ aView forward
		title: 'Formats';
		priority: 11;
		object: [ instruction ];
		view: #gtFormatsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						onMethodCoderSaved: [ :anAnnouncement | 
							| method |
							method := anAnnouncement method.
							self recomputeFormats.
							methodCoder phlow fireToolUpdateWish.
							methodCoder
								enqueueTask: (BlTaskAction new action: [ methodCoder fireEvent: BrDropdownHideWish new ]) ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtFORMATNAMEDescription
	<gtLlmAssistantFormat>
	^ GtLlmAsssistantFormatDescription new
		name: '''';
		priority: 1;
		format: '''';
		example: '''''.
				methodCoder methodCoderViewModelValueHolder: valueHolder ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistant >> searchTool [
	"<gtLlmTool>"
	^ GtLlmFunctionTool new
		name: 'search';
		parameters: {'query'};
		description: 'Generic search across all entities in the system. Returns a heterogeneous collection of things grouped by entity.';
		block: [ :functionCall | 
			| spotter searches result |
			spotter := GtSpotter
					on: (GtWorldSpotterSearchStart new
							knowledgeBase: LeDatabasesRegistry uniqueInstance defaultLogicalDatabase).

			spotter steps first searchQuery: functionCall anyArgument.

			searches := (spotter steps first createSearchResultsStream
					flatCollect: #value) toArray wait groupedBy: #search.

			result := {} asDictionary.

			searches
				keysAndValuesDo: [ :aKey :aValue | 
					result
						at: aKey title
						put: (aValue collect: [ :aCandidate | (aKey itemNameFor: aCandidate item) asString ]) ].

			STONJSON toString: result ]
]
