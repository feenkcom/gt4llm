"
Summarizes code changes performed by code-modifying tools and exposes the collected changes through views.
"
Class {
	#name : #GtLCodeChangesToolCallsSummarizer,
	#superclass : #GtLToolCallsSummarizer,
	#instVars : [
		'relevantToolCalls',
		'codeChanges'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLCodeChangesToolCallsSummarizer class >> isActive [ 
	^true
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> addCodeChanges: aCollection [
	self codeChanges addAll: aCollection
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> addCodeChangesFrom: aToolCall [
	| result model |
	result := aToolCall result.
	model := result ifNotNil: [ :each | each model ].
	model ifNil: [ ^ self ].
	self addCodeChangesFromModel: model toolCall: aToolCall
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> addCodeChangesFromModel: aModel toolCall: aToolCall [
	(aModel isKindOf: GtLClassesCreationResult) ifTrue: [
		^ self 
			addCodeChangesLabeled: 'Created class/trait' 
			from: aModel successfulClassCreationResults 
			toolCall: aToolCall ].
		
	(aModel isKindOf: GtLClassModificationResult) ifTrue: [
		^ self addCodeChanges: { self 
				codeChangeEntryLabel: 'Changed class signature' 
				object: aModel 
				toolCall: aToolCall } ].
		
	(aModel isKindOf: GtLClassCommentChangeResult) ifTrue: [
		^ self addCodeChanges: { self 
				codeChangeEntryLabel: 'Changed class comment' 
				object: aModel 
				toolCall: aToolCall } ].
		
	(aModel isKindOf: GtLClassRemovalResult) ifTrue: [
		^ self addCodeChanges: { self 
				codeChangeEntryLabel: 'Removed class' 
				object: aModel 
				toolCall: aToolCall } ].
		
	(aModel isKindOf: GtLMethodCompilationResult) ifTrue: [
		^ self addCodeChanges: { self 
				codeChangeEntryLabel: 'Compiled method' 
				object: aModel 
				toolCall: aToolCall } ].
		
	(aModel isKindOf: GtLMethodsCompilationResult) ifTrue: [
		^ self 
				addCodeChangesLabeled: 'Compiled method' 
				from: aModel successfulMethodCompilationResults 
				toolCall: aToolCall ].
		
	(aModel isKindOf: GtLMethodRemovalResult) ifTrue: [
		^ self 
			addCodeChanges: { self codeChangeEntryLabel: 'Removed method' 
			object: aModel 
			toolCall: aToolCall } ].
		
	(aModel isKindOf: GtLMethodsRemovalResult) ifTrue: [
		^ self 
				addCodeChangesLabeled: 'Removed method' 
				from: aModel successfulMethodsRemovalResult 
				toolCall: aToolCall ]
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> addCodeChangesLabeled: aLabel from: aCollection toolCall: aToolCall [
	self addCodeChanges: (aCollection collect: [ :each |
		self codeChangeEntryLabel: aLabel object: each toolCall: aToolCall ])
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> classChangeHistories [
	"Group code changes by class name, including both method and class-level changes"
	| historiesByClassName methodHistoriesByReference group |
	historiesByClassName := Dictionary new.
	methodHistoriesByReference := Dictionary new.
	
	"Process method changes"
	self methodChangeResults do: [ :each |
		| changeResult methodReference methodHistory className classHistory |
		changeResult := each changeResult.
		methodReference := changeResult targetMethodReference.
		className := methodReference methodClassName.
		
		"Get or create class history"
		classHistory := historiesByClassName
			at: className
			ifAbsentPut: [ GtLClassChangeHistory new
				targetClassName: className;
				yourself ].
		
		"Get or create method history within the class"
		methodHistory := methodHistoriesByReference
			at: methodReference
			ifAbsentPut: [ 
				| newHistory |
				newHistory := GtLMethodChangeHistory new
					methodReference: methodReference;
					yourself.
				classHistory addMethodHistory: newHistory.
				newHistory ].
		methodHistory addChange: each ].
	
	"Process class definition changes (additions, modifications, removals) and comment changes"
	(self classChangeResults) 
		do: [ :each |
			| changeResult className classHistory |
			changeResult := each changeResult.
			className := changeResult targetClassName asString.
		
			"Get or create class history"
			classHistory := historiesByClassName
				at: className
				ifAbsentPut: [ GtLClassChangeHistory new
					targetClassName: className;
					yourself ].
		
			"Add as a definition change"
			classHistory addBehaviourChange: each ].
	
	group := GtLClassChangeHistoriesGroup new.
	historiesByClassName valuesDo: [ :each | group addHistory: each ].
	^ group
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> classChangeResults [
	^ self codeChanges select: [ :each | each isClassChangeResult ]
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> codeChangeEntryLabel: aLabel object: anObject toolCall: aToolCall [
	^ GtLSummarizerCodeChange new
		label: aLabel;
		changeResult: anObject;
		toolCall: aToolCall;
		yourself
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> codeChanges [
	^ codeChanges ifNil: [ codeChanges := GtLSummarizerCodeChangesGroup new ]
]

{ #category : #'gt-extensions' }
GtLCodeChangesToolCallsSummarizer >> gtChangesByToolFor: aView [
	<gtView>
	^ aView columnedList
		title: 'By tool';
		priority: 40;
		items: [ (self codeChanges groupedBy: [ :each | each toolCall name ]) associations ];
		column: 'Tool' text: [ :each | each key asString ];
		column: 'Changes' text: [ :each | each value size asString ] width: 100;
		send: [ :each | each value collect: [ :entry | entry changeResult ] ]
]

{ #category : #views }
GtLCodeChangesToolCallsSummarizer >> gtClassChangeHistoriesFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward 	
		title: 'Changes by class';
		priority: 15;
		object: [ self classChangeHistories ];
		view: #gtViewHistoriesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ]
]

{ #category : #'gt-extensions' }
GtLCodeChangesToolCallsSummarizer >> gtCodeChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Code changes';
		priority: 21.1;
		object: [ self codeChanges ];
		view: #gtCodeChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		actionUpdateButton
]

{ #category : #'gt-extensions' }
GtLCodeChangesToolCallsSummarizer >> gtCodeChangesListFor: aView [
	<gtView>
	^ aView forward
		title: 'Code changes (list)';
		priority: 21.4;
		object: [ self codeChanges ];
		view: #gtCodeChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		actionUpdateButton
]

{ #category : #'gt-extensions' }
GtLCodeChangesToolCallsSummarizer >> gtMethodChangeHistoriesFor: aView [
	<gtView>
	^ aView forward 	
			title: 'Changes by method';
			priority: 10;
			object: [ self methodChangeHistories ];
			view: #gtViewHistoriesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ]
]

{ #category : #views }
GtLCodeChangesToolCallsSummarizer >> gtPackageChangeHistoriesFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward 	
		title: 'Changes by package';
		priority: 20;
		object: [ self packageChangeHistories ];
		view: #gtViewHistoriesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ]
]

{ #category : #testing }
GtLCodeChangesToolCallsSummarizer >> hasSummaryData [
	^ self codeChanges isEmpty not
]

{ #category : #initialization }
GtLCodeChangesToolCallsSummarizer >> initialize [
	super initialize.
	relevantToolCalls := OrderedCollection new.
	codeChanges := GtLSummarizerCodeChangesGroup new
]

{ #category : #initialization }
GtLCodeChangesToolCallsSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantToolCalls := self toolCallsSelect: [ :each | 
		self isCodeChangeToolCall: each ].
	self rebuildCodeChanges
]

{ #category : #testing }
GtLCodeChangesToolCallsSummarizer >> isCodeChangeToolCall: aToolCall [
	^ #(createClass createClassesAndTraits changeClassOrTraitSignature changeClassOrTraitComment removeClass compileMethod compileMethods removeMethod removeMethods)
		includes: aToolCall name asSymbol
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> methodChangeHistories [
	| historiesByReference group |
	historiesByReference := Dictionary new.
	(self methodChangeResults) do: [ :each |
		| changeResult methodReference history |
		changeResult := each changeResult.
		methodReference := changeResult targetMethodReference.
		history := historiesByReference
			at: methodReference
			ifAbsentPut: [ GtLMethodChangeHistory new
				methodReference: methodReference;
				yourself ].
		history addChange: each ].
	group := GtLMethodChangeHistoriesGroup new.
	historiesByReference valuesDo: [ :each | group addHistory: each ].
	^ group
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> methodChangeResults [
	^ self codeChanges select: [ :each | each isMethodChangeResult ]
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> packageChangeHistories [
	"Group code changes by package name, including both method and class-level changes.
	For package move operations, the change is added to BOTH the source and destination packages."
	^ GtLPackageChangeHistoriesBuilder buildHistoryForCodeChanges: self codeChanges
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizer >> rebuildCodeChanges [
	codeChanges := GtLSummarizerCodeChangesGroup new.
	self relevantToolCalls do: [ :each | 
		self addCodeChangesFrom: each ]
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> relevantToolCalls [
	^ relevantToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> summaryText [
	^ self hasSummaryData
		ifTrue: [ '{1} code changes from {2} tool calls' format: { self codeChanges size. self relevantToolCalls size } ]
		ifFalse: [ 'No code changes' ]
]

{ #category : #accessing }
GtLCodeChangesToolCallsSummarizer >> title [
	^ 'Code changes'
]
