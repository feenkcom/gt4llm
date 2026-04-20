"
History of code changes for a single method, grouped by target method reference.
"
Class {
	#name : #GtLMethodChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'methodReference'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLMethodChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> asDiffElement [
	| previousContent newContent change styler |
	previousContent := self initialChange changeResult oldStateMethodSourceCode.
	newContent := self latestChange changeResult newStateMethodSourceCode.

	change := GtDiffBuilder
			computeDifferencesFrom: previousContent
			to: newContent
			using: GtSmaCCDiffSplitter forPharo.
	styler := GtCodeDiffRBTextStyler new.
	
	^ GtEpiceaDiffElementWithLabelStencil new
		fromLabelText: 'First Change:';
		toLabelText: 'Last Change:';
		ombuEntry: self;
		shouldHideDiff: previousContent = newContent;
		change: change;
		styler: styler
]

{ #category : #accessing }
GtLMethodChangeHistory >> changes [
	^ changes ifNil: [ changes := GtLSummarizerCodeChangesGroup new ]
]

{ #category : #accessing }
GtLMethodChangeHistory >> changes: aCollection [
	changes := aCollection
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtCodeChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Code changes';
		priority: 10;
		object: [ self changes ];
		view: #gtCodeChangesFor:
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtDiffFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [ self asDiffElement ]
]

{ #category : #printing }
GtLMethodChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self methodReference methodSignature
]

{ #category : #printing }
GtLMethodChangeHistory >> gtViewChangeDescriptionElement [
	^ self latestChange gtViewChangeDescriptionElement
]

{ #category : #printing }
GtLMethodChangeHistory >> gtViewChangeIcon [
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #windowMinimizeInactive ].
		
	self isLatestChangeRemoval ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeRemoveIcon ].
	
	self isInitialChangeAddition ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeAddIcon ].
	
	^ self latestChange gtViewChangeIcon
]

{ #category : #testing }
GtLMethodChangeHistory >> hasNoEffect [
	^ self isInitialChangeAddition and: [ 
		self isLatestChangeRemoval ] 
]

{ #category : #testing }
GtLMethodChangeHistory >> initialChange [
	^ self changes first
]

{ #category : #testing }
GtLMethodChangeHistory >> isInitialChangeAddition [
	^ self initialChange isMethodAdditionResult
]

{ #category : #testing }
GtLMethodChangeHistory >> isLatestChangeRemoval [
	^ self latestChange isMethodRemovalResult
]

{ #category : #accessing }
GtLMethodChangeHistory >> methodReference [
	^ methodReference
]

{ #category : #accessing }
GtLMethodChangeHistory >> methodReference: aMethodReference [
	methodReference := aMethodReference
]
