"
I track the additions and removals of a single variable of a class. I am created on demand by {{gtMethod:GtLClassDefinitionChangeHistory>>#variableChangeHistories}} and keep a reference to that class definition history.
"
Class {
	#name : #GtLVariableChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'variableName',
		'variableType',
		'changes',
		'classDefinitionHistory'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLVariableChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
]

{ #category : #accessing }
GtLVariableChangeHistory >> changes [
	^ changes ifNil: [ changes := GtLSummarizerCodeChangesGroup new ]
]

{ #category : #accessing }
GtLVariableChangeHistory >> classDefinitionHistory [
	^ classDefinitionHistory
]

{ #category : #accessing }
GtLVariableChangeHistory >> classDefinitionHistory: aClassDefinitionChangeHistory [
	classDefinitionHistory := aClassDefinitionChangeHistory
]

{ #category : #printing }
GtLVariableChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: (self variableType descriptionFor: self variableName)
]

{ #category : #'gt - extensions' }
GtLVariableChangeHistory >> gtViewChangeDescriptionElement [
	^ self latestChange gtViewChangeDescriptionElement
]

{ #category : #views }
GtLVariableChangeHistory >> gtViewChangeHistoryChildren [
	^ self changes items
]

{ #category : #views }
GtLVariableChangeHistory >> gtViewChangeIcon [
	self hasNoEffect
		ifTrue: [ ^ Smalltalk ui icons iconNamed: #windowMinimizeInactive ].
	self isLatestChangeRemoval
		ifTrue: [ ^ Smalltalk ui icons iconNamed: #changeRemoveIcon ].
	self isInitialChangeAddition
		ifTrue: [ ^ Smalltalk ui icons iconNamed: #changeAddIcon ].
	^ self latestChange gtViewChangeIcon
]

{ #category : #printing }
GtLVariableChangeHistory >> gtViewChangesCount [
	^ self changes size
]

{ #category : #testing }
GtLVariableChangeHistory >> hasNoEffect [
	^ self isInitialChangeAddition and: [ self isLatestChangeRemoval ]
]

{ #category : #accessing }
GtLVariableChangeHistory >> initialChange [
	^ self changes initialChange
]

{ #category : #testing }
GtLVariableChangeHistory >> isInitialChangeAddition [
	^ self initialChange isVariableAdditionResult
]

{ #category : #testing }
GtLVariableChangeHistory >> isLatestChangeRemoval [
	^ self latestChange isVariableRemovalResult
]

{ #category : #accessing }
GtLVariableChangeHistory >> targetClassName [
	^ self classDefinitionHistory targetClassName
]

{ #category : #accessing }
GtLVariableChangeHistory >> variableName [
	^ variableName
]

{ #category : #accessing }
GtLVariableChangeHistory >> variableName: aString [
	variableName := aString
]

{ #category : #accessing }
GtLVariableChangeHistory >> variableType [
	^ variableType
]

{ #category : #accessing }
GtLVariableChangeHistory >> variableType: aVariableType [
	variableType := aVariableType
]
