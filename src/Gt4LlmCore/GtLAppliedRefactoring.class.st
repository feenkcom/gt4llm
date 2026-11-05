Class {
	#name : #GtLAppliedRefactoring,
	#superclass : #Object,
	#instVars : [
		'preview'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLAppliedRefactoring class >> preview: aRefactoringPreview [
	^self new initializePreview: aRefactoringPreview
]

{ #category : #accessing }
GtLAppliedRefactoring >> changesCount [
	^preview changesCount
]

{ #category : #descriptions }
GtLAppliedRefactoring >> changesCountDescription [
	<magritteDescription>
	^(MANumberDescription new)
		label: 'Changes count';
		accessor: #changesCount;
		beRequired
]

{ #category : #views }
GtLAppliedRefactoring >> gtChangesFor: aView [
	<gtView>
	<gtLlmView>
	^(aView forward)
		title: 'Applied changes';
		priority: 1;
		object: [preview namespace];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the preview'
			action: [:aButton | aButton phlow spawnObject: preview]
]

{ #category : #views }
GtLAppliedRefactoring >> gtStatusFor: aView [
	<gtView>
	<gtLlmView>
	^(aView columnedList)
		title: 'Status';
		priority: 2;
		items: 
				[Array with: 'Status' -> self status
					with: 'Changes count' -> self changesCount];
		column: 'Property'
			text: [:each | each key]
			width: 150;
		column: 'Value' text: [:each | each value];
		send: [:each | each value]
]

{ #category : #initialization }
GtLAppliedRefactoring >> initializePreview: aRefactoringPreview [
	preview := aRefactoringPreview
]

{ #category : #'llm views' }
GtLAppliedRefactoring >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #accessing }
GtLAppliedRefactoring >> preview [
	^preview
]

{ #category : #accessing }
GtLAppliedRefactoring >> status [
	^'applied'
]

{ #category : #descriptions }
GtLAppliedRefactoring >> statusDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Status';
		accessor: #status;
		beRequired
]
