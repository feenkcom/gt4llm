"
I track class definition changes (creation, modification, removal).
"
Class {
	#name : #GtLClassDefinitionChangeHistory,
	#superclass : #GtLClassBasicChangeHistory,
	#instVars : [
		'changes'
	],
	#category : #'Gt4LlmCore-Summaries'
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
		fromLabel: 'Initial version:';
		toLabel: 'Changed version:';
		styler: [ :aSource | 
			GtPharoStyler new
				coderViewModel: (GtPharoSnippetCoder forSource: aSource) asCoderViewModel;
				yourself ]
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
		styler: [ :aSource | 
			GtPharoStyler new
				coderViewModel: (GtPharoSnippetCoder forSource: aSource) asCoderViewModel;
				yourself ]
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtViewChangeDescriptionElement [
	^ GtLClassDefinitionChangeDescriptionElement new
		updateForClassDefinitionChangeHistory: self
]

{ #category : #'gt - extensions' }
GtLClassDefinitionChangeHistory >> gtViewChangeHistoryChildren [
	^ #()
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

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> gtViewChangesCount [
	^ self changes size
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
	"A rename adds the class under its new name"

	| initialChange |
	self changes ifEmpty: [ ^ false ].
	initialChange := self initialChange changeResult.
	^ initialChange isClassAdditionResult
		or: [ initialChange isClassRenameResult
				and: [ initialChange currentClassName asString = self targetClassName asString ] ]
]

{ #category : #testing }
GtLClassDefinitionChangeHistory >> isLatestChangeRemoval [
	"A rename removes the class under its old name"

	| latestChange |
	self changes ifEmpty: [ ^ false ].
	latestChange := self changes latestChange changeResult.
	^ latestChange isClassRemovalResult
		or: [ latestChange isClassRenameResult
				and: [ latestChange originalClassName = self targetClassName asString ] ]
]

{ #category : #private }
GtLClassDefinitionChangeHistory >> newVariableChangeHistoryFor: aVariableChangeResult [
	^ GtLVariableChangeHistory new
		variableName: aVariableChangeResult variableName;
		variableType: aVariableChangeResult variableType;
		classDefinitionHistory: self;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionChangeHistory >> variableChangeHistories [
	| histories |
	histories := OrderedDictionary new.
	self changes
		do: [ :aClassChange | 
			(self variableChangesFrom: aClassChange)
				do: [ :aVariableChange | 
					| aVariableChangeResult |
					aVariableChangeResult := aVariableChange changeResult.
					(histories
						at: {aVariableChangeResult variableType.
								aVariableChangeResult variableName}
						ifAbsentPut: [ self newVariableChangeHistoryFor: aVariableChangeResult ])
						addChange: aVariableChange ] ].
	^ GtLVariableChangeHistoriesGroup new
		addItems: histories values;
		yourself
]

{ #category : #private }
GtLClassDefinitionChangeHistory >> variableChangesFrom: aClassChange [
	| aClassChangeResult variableChanges |
	aClassChangeResult := aClassChange changeResult.
	variableChanges := OrderedCollection new.
	GtLVariableType all
		do: [ :aVariableType | 
			variableChanges
				addAll: (self
						variableChangesOf: GtLVariableAdditionResult
						named: (aClassChangeResult addedVariableNamesFor: aVariableType)
						type: aVariableType
						from: aClassChange);
				addAll: (self
						variableChangesOf: GtLVariableRemovalResult
						named: (aClassChangeResult removedVariableNamesFor: aVariableType)
						type: aVariableType
						from: aClassChange) ].
	^ variableChanges
]

{ #category : #private }
GtLClassDefinitionChangeHistory >> variableChangesOf: aVariableChangeResultClass named: someVariableNames type: aVariableType from: aClassChange [
	^ someVariableNames
		collect: [ :aVariableName | 
			(aVariableChangeResultClass
				named: aVariableName
				type: aVariableType
				from: aClassChange) asSummarizerCodeChange ]
]
