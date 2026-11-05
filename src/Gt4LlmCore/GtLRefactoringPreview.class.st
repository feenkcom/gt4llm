Class {
	#name : #GtLRefactoringPreview,
	#superclass : #Object,
	#instVars : [
		'namespace',
		'objectId',
		'changes',
		'applied'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace [
	^self new initializeNamespace: aNamespace
]

{ #category : #accessing }
GtLRefactoringPreview >> applied [
	^applied
]

{ #category : #descriptions }
GtLRefactoringPreview >> appliedDescription [
	<magritteDescription>
	^(MABooleanDescription new)
		label: 'Applied';
		accessor: #applied;
		beRequired
]

{ #category : #applying }
GtLRefactoringPreview >> apply [
	GtRefactoryChangeManager instance performChange: namespace changes.
	applied := true
]

{ #category : #accessing }
GtLRefactoringPreview >> changes [
	^changes
]

{ #category : #descriptions }
GtLRefactoringPreview >> changesDescription [
	<magritteDescription>
	^(MAToManyRelationDescription new)
		label: 'Changes';
		accessor: #changes;
		classes: (Array with: GtLRefactoringChange);
		beRequired
]

{ #category : #views }
GtLRefactoringPreview >> gtChangesFor: aView [
	<gtView>
	<gtLlmView>
	^(aView forward)
		title: 'Changes';
		priority: 1;
		object: [self namespace];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect  
			tooltip: 'Inspect preview object'
			action: [ :aButton |
				aButton phlow spawnObject:  self ]
]

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace [
	namespace := aNamespace.
	applied := false.
	changes := (aNamespace changes gtBasicChanges
				collect: [:each | GtLRefactoringChange fromChange: each]) asArray
]

{ #category : #testing }
GtLRefactoringPreview >> isApplied [
	^applied
]

{ #category : #'llm views' }
GtLRefactoringPreview >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #accessing }
GtLRefactoringPreview >> namespace [
	^namespace
]

{ #category : #accessing }
GtLRefactoringPreview >> objectId [
	^objectId
]

{ #category : #accessing }
GtLRefactoringPreview >> objectId: aString [
	objectId := aString
]

{ #category : #descriptions }
GtLRefactoringPreview >> objectIdDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Object id';
		accessor: #objectId;
		beRequired
]
