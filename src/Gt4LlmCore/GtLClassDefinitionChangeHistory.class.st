"
I track class definition changes (creation, modification, removal).
"
Class {
	#name : #GtLClassDefinitionChangeHistory,
	#superclass : #GtLClassBasicChangeHistory,
	#instVars : [
		'changes'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLClassDefinitionChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> asDiffElement [
	| previousContent newContent change styler |
	previousContent := self initialChange 
		changeResult originalDefinitionWithCommentString.
	newContent := self latestChange 
		changeResult updatedDefinitionWithCommentString.

	change := GtDiffBuilder
			computeDifferencesFrom: previousContent
			to: newContent
			using: GtSmaCCDiffSplitter forPharo.
	styler := GtCodeDiffRBTextStyler new.
	
	^ (GtDiffElementWithLabelStencil new
		fromLabelText: 'First Change:';
		toLabelText: 'Last Change:';
		change: change;
		styler: styler) asElement
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> asDiffWithCurrentVersionElement [
	| currentContent changedContent change styler|
	currentContent := self currentClassDefinitionWithCommentString.
	changedContent := self latestChange changeResult updatedDefinitionWithCommentString.

	change := GtDiffBuilder
			computeDifferencesFrom: currentContent
			to: changedContent
			using: GtSmaCCDiffSplitter forPharo.
	styler := GtCodeDiffRBTextStyler new.
	
	^ (GtDiffElementWithLabelStencil new
		fromLabelText: 'Image content:';
		toLabelText: 'Change content:';
		change: change;
		styler: styler) asElement
]

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> changes [
	^ changes ifNil: [ changes := GtLSummarizerCodeChangesGroup new ]
]

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> changes: aGtLSummarizerCodeChangesGroup [
	changes := aGtLSummarizerCodeChangesGroup
]

{ #category : #'as yet unclassified' }
GtLClassDefinitionChangeHistory >> currentClassDefinitionWithCommentString [
	self targetClassName asClassIfPresent: [ :aClass | 
		^(GtLClassDefinitionDescription fromClass: aClass)  asDefinitionWithCommentString ].
	^ ''
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtDiffFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [ self asDiffElement ]
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff (with current)';
		priority: 10;
		stencil: [ self asDiffWithCurrentVersionElement ]
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtViewChangeDescriptionElement [
	^ GtLClassDefinitionChangeDescriptionElement new
		updateForChangeObject: self;
		yourself
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtViewChangeIcon [
	self changes ifEmpty: [ 
		^ Smalltalk ui icons iconNamed: #class ].
	
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #windowMinimizeInactive ].
	
	self isLatestChangeRemoval ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeRemoveIcon ].
	
	self isInitialChangeAddition ifTrue: [
		^ Smalltalk ui icons iconNamed: #changeAddIcon ].
		
	^ Smalltalk ui icons iconNamed: #changeUpdateIcon
]

{ #category : #testing }
GtLClassDefinitionChangeHistory >> hasNoEffect [
	^ self isInitialChangeAddition and: [ self isLatestChangeRemoval ]
]

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> initialChange [
	^ self changes ifEmpty: [ nil ] ifNotEmpty: [ self changes first ]
]

{ #category : #testing }
GtLClassDefinitionChangeHistory >> isInitialChangeAddition [
	| initialChange |
	self changes ifEmpty: [ ^ false ].
	initialChange := self initialChange.
	^ initialChange changeResult isClassAdditionResult
]

{ #category : #testing }
GtLClassDefinitionChangeHistory >> isLatestChangeRemoval [
	| latestChange |
	self changes ifEmpty: [ ^ false ].
	latestChange := self changes latestChange.
	^ latestChange changeResult isClassRemovalResult
]

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> latestChange [
	^ self changes ifEmpty: [ nil ] ifNotEmpty: [ self changes last ]
]
