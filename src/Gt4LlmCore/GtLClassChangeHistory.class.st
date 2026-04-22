"
I track changes to a single class, including its methods.

Instance variables:
- `targetClassName` - the target class name
- `behaviourChanges` - a {{gtClass:GtLSummarizerCodeChangesGroup}} of class-level changes (definition and comment)
- `methodHistories` - a {{gtClass:GtLMethodChangeHistoriesGroup}} with method changes

Computed accessors:
- `definitionChangeHistory` - returns a {{gtClass:GtLClassDefinitionChangeHistory}} filtered from behaviourChanges
- `commentChangeHistory` - returns a {{gtClass:GtLClassCommentChangeHistory}} filtered from behaviourChanges

`#changes` returns all changes (behaviour + method) combined.
"
Class {
	#name : #GtLClassChangeHistory,
	#superclass : #GtLClassBasicChangeHistory,
	#instVars : [
		'methodHistories',
		'behaviourChanges'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLClassChangeHistory >> addBehaviourChange: aCodeChange [
	self behaviourChanges add: aCodeChange
]

{ #category : #accessing }
GtLClassChangeHistory >> addMethodHistory: aMethodHistory [
	methodHistories addHistory: aMethodHistory
]

{ #category : #accessing }
GtLClassChangeHistory >> behaviourChanges [
	^ behaviourChanges ifNil: [ behaviourChanges := GtLSummarizerCodeChangesGroup new ]
]

{ #category : #accessing }
GtLClassChangeHistory >> behaviourChanges: aGtLSummarizerCodeChangesGroup [
	behaviourChanges := aGtLSummarizerCodeChangesGroup
]

{ #category : #accessing }
GtLClassChangeHistory >> changes [
	"Return all changes: behaviour changes and method changes"
	| allChanges |
	allChanges := GtLSummarizerCodeChangesGroup new.
	allChanges addAll: self behaviourChanges.
	self methodHistories items do: [ :methodHistory |
		allChanges addAll: methodHistory changes ].
	^ allChanges
]

{ #category : #accessing }
GtLClassChangeHistory >> definitionChangeHistory [
	| history |
	history := GtLClassDefinitionChangeHistory new
		targetClassName: self targetClassName;
		yourself.
	self behaviourChanges 
		do: [ :each | history addChange: each ].
	^ history
]

{ #category : #views }
GtLClassChangeHistory >> gtBehaviourChangesFor: aView [
	<gtView>
	^(aView forward)
		title: 'Behaviour changes';
		priority: 40;
		object: [behaviourChanges];
		view: #gtCodeChangesFor:
]

{ #category : #printing }
GtLClassChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self targetClassName
]

{ #category : #views }
GtLClassChangeHistory >> gtMethodHistoriesFor: aView [
	<gtView>
	^(aView forward)
		title: 'Methods';
		priority: 5;
		object: [methodHistories];
		view: #gtViewHistoriesFor:
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangeDescriptionElement [
	"Return description element for display in tree"
	^ BlTextElement new 
		padding: (BlInsets all: 0);
		constraintsDo: [ :c | 
			c linear vertical alignCenter ];
		text: (self targetClassName asRopedText 
			bold; 
			glamorousRegularFont)
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangeDescriptionElements [
	^ {BlTextElement new 
		padding: (BlInsets all: 0);
		constraintsDo: [ :c | 
			c linear vertical alignCenter ];
		text: (self targetClassName asRopedText 
			bold; 
			glamorousRegularFont)}
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangeEditTime [
	"Return the latest edit time across all changes"
	| times |
	times := OrderedCollection new.
	
	"Collect times from method histories"
	self methodHistories items do: [ :each | 
		each gtViewChangeEditTime ifNotNil: [ :t | times add: t ] ].
	
	"Collect times from behaviour changes"
	self behaviourChanges do: [ :each | 
		each gtViewChangeEditTime ifNotNil: [ :t | times add: t ] ].
	
	^ times ifEmpty: [ nil ] ifNotEmpty: [ times max ]
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangeHistoryChildren [
	"Return definition/comment histories and method histories as children for tree view"
	| children |
	children := OrderedCollection new.
	self definitionChangeHistory changes ifNotEmpty: [
		children add: self definitionChangeHistory ].
	children addAll: self methodHistories items.
	^ children
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangeIcon [
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #windowMinimizeInactive ].
		
	self hasOnlyMethodChanges ifTrue: [
		^ Smalltalk ui icons iconNamed: #class ].
	
	self isLatestDefinitionChangeRemoval ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeRemoveIcon ].
	
	self isInitialDefinitionChangeAddition ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeAddIcon ].
		
	^ Smalltalk ui icons iconNamed: #changeUpdateIcon
]

{ #category : #views }
GtLClassChangeHistory >> gtViewChangesCount [
	"Return total count including method changes and class-level changes"
	| methodChangesCount |
	methodChangesCount := self methodHistories items
		inject: 0
		into: [ :sum :each | sum + each gtViewChangesCount ].
	^ methodChangesCount + self behaviourChanges size
]

{ #category : #'gt - extensions' }
GtLClassChangeHistory >> gtViewDefinitionDiffFor: aView [
	<gtView>
	self hasBehaviourChanges ifFalse: [ ^ aView empty ].
	
	^ aView diff
		title: 'Definition diff';
		priority: 10;
		from: [ self initialBehaviourChange changeResult originalDefinitionWithCommentString ];
		to: [ self latestBehaviourChange changeResult updatedDefinitionWithCommentString ];
		fromLabel: 'First Change:';
		toLabel: 'Last Change:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #testing }
GtLClassChangeHistory >> hasBehaviourChanges [
	^ self behaviourChanges size > 0
]

{ #category : #testing }
GtLClassChangeHistory >> hasNoEffect [
	^ self hasOnlyMethodChanges
		ifTrue: [
			"In case only methods changed, all method histories should have no effect"
			self methodHistories items allSatisfy: #hasNoEffect ]
		ifFalse: [
			"Check if definition changes cancel out"
			self isInitialDefinitionChangeAddition 
				and: [ self isLatestDefinitionChangeRemoval ] ]
]

{ #category : #testing }
GtLClassChangeHistory >> hasOnlyMethodChanges [
	^ self hasBehaviourChanges not
]

{ #category : #accessing }
GtLClassChangeHistory >> initialBehaviourChange [ 
	^ self behaviourChanges initialChange 
]

{ #category : #initialization }
GtLClassChangeHistory >> initialize [
	super initialize.
	methodHistories := GtLMethodChangeHistoriesGroup new
]

{ #category : #testing }
GtLClassChangeHistory >> isInitialDefinitionChangeAddition [
		| initialChange |
	self behaviourChanges ifEmpty: [ ^ false ].
	initialChange := self initialBehaviourChange.
	^ initialChange changeResult isClassAdditionResult
]

{ #category : #testing }
GtLClassChangeHistory >> isLatestDefinitionChangeRemoval [
		| initialChange |
	self behaviourChanges ifEmpty: [ ^ false ].
	initialChange := self latestBehaviourChange.
	^ initialChange changeResult isClassRemovalResult
]

{ #category : #accessing }
GtLClassChangeHistory >> latestBehaviourChange [ 
	^ self behaviourChanges latestChange 
]

{ #category : #accessing }
GtLClassChangeHistory >> methodHistories [
	^ methodHistories
]

{ #category : #accessing }
GtLClassChangeHistory >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassChangeHistory >> targetClassName: aString [
	targetClassName := aString
]
