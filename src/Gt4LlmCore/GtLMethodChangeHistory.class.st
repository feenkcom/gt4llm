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

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> asDiffWithCurrentVersionElement [
	| currentContent changedContent change styler |
	currentContent := self currentMethodSourceCode.
	changedContent := self latestChange changeResult newStateMethodSourceCode.
	
	change := GtDiffBuilder
			computeDifferencesFrom: currentContent
			to: changedContent
			using: GtSmaCCDiffSplitter forPharo.
	styler := GtCodeDiffRBTextStyler new.
	
	^ GtEpiceaDiffElementWithLabelStencil new
		fromLabelText: 'Image content:';
		toLabelText: 'Change content:';
		ombuEntry: self;
		shouldHideDiff: false;
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

{ #category : #accessing }
GtLMethodChangeHistory >> currentMethodSourceCode [
	^self methodReference existsInImage
		ifTrue: [ self methodReference  compiledMethod sourceCode ] 
		ifFalse: ['']
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtActionBrowseEntryFor: anAction [
	<gtAction>
	
	self methodReference existsInImage ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
			label: 'Browse';
			priority: 3;
			tooltip: 'Browse current version of this method';
			action: [ :aButton | 
				aButton phlow spawnTool: (GtMethodCoderTool compiledMethod:
						self methodReference compiledMethod)  ] 
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtClassCoderViewFor: aView [
	<gtView>
	<gtCodeChangeView>
	
	self methodReference existsInImage ifFalse: [ ^ aView empty ].
	
	^ aView forward
		title: 'Current Coder';
		priority: 25;
		object: [ self methodReference ];
		view: #gtClassCoderViewFor:
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtCodeChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Code changes';
		priority: 15;
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

{ #category : #'gt-extensions' }
GtLMethodChangeHistory >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff (with current)';
		priority: 10;
		stencil: [ self asDiffWithCurrentVersionElement ]
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
