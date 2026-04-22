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
	^ aView diff
		title: 'Diff';
		priority: 5;
		from: [ self initialChange changeResult originalDefinitionWithCommentString ];
		to: [ self latestChange changeResult updatedDefinitionWithCommentString ];
		fromLabel: 'First Change:';
		toLabel: 'Last Change:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	^ aView diff
		title: 'Diff (with current)';
		priority: 10;
		from: [ self currentClassDefinitionWithCommentString ];
		to: [ self latestChange changeResult updatedDefinitionWithCommentString ];
		fromLabel: 'Image content:';
		toLabel: 'Change content:';
		styler: GtCodeDiffRBTextStyler new
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
