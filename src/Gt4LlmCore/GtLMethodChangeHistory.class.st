"
I track changes to a single method.

Instance variables:
- `methodReference` - the target method
- `changes` - a {{gtClass:GtLSummarizerCodeChangesGroup}} of changes
"
Class {
	#name : #GtLMethodChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'methodReference',
		'changes'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLMethodChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
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
		title: 'Current coder';
		priority: 25;
		object: [ self methodReference ];
		view: #gtClassCoderViewFor:
]

{ #category : #'gt - extensions' }
GtLMethodChangeHistory >> gtDiffFor: aView [
	<gtView>
	^ aView diff
		title: 'Diff';
		priority: 5;
		from: [ 
			self initialChange changeResult oldStateMethodSourceCode ];
		to: [ 
			self latestChange changeResult newStateMethodSourceCode ];
		fromLabel: 'First Change:';
		toLabel: 'Last Change:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #'gt - extensions' }
GtLMethodChangeHistory >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	^ aView diff
		title: 'Diff (with current)';
		priority: 10;
		from: [ 
			self currentMethodSourceCode ];
		to: [ 
			self latestChange changeResult newStateMethodSourceCode ];
		fromLabel: 'Image content:';
		toLabel: 'Change content:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #printing }
GtLMethodChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self methodReference methodSignature
]

{ #category : #'gt-extensions' }
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
