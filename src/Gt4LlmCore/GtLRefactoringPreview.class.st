Class {
	#name : #GtLRefactoringPreview,
	#superclass : #Object,
	#instVars : [
		'namespace',
		'objectId',
		'changes'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace objectId: aString [
	^self new initializeNamespace: aNamespace objectId: aString
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
		view: #gtApplyingChangesFor:
]

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace objectId: aString [
	namespace := aNamespace.
	objectId := aString.
	changes := (aNamespace changes gtBasicChanges
				collect: [:each | GtLRefactoringChange fromChange: each]) asArray
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

{ #category : #descriptions }
GtLRefactoringPreview >> objectIdDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Object id';
		accessor: #objectId;
		beRequired
]
