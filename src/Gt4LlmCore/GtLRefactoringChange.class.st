Class {
	#name : #GtLRefactoringChange,
	#superclass : #Object,
	#instVars : [
		'changeDescription',
		'newSource'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringChange class >> changeDescription: aDescriptionString newSource: aSourceString [
	^self new initializeChangeDescription: aDescriptionString
		newSource: aSourceString
]

{ #category : #'instance creation' }
GtLRefactoringChange class >> fromChange: aRefactoryChange [
	^self changeDescription: aRefactoryChange changeString
		newSource: aRefactoryChange textToDisplay asString
]

{ #category : #accessing }
GtLRefactoringChange >> changeDescription [
	^changeDescription
]

{ #category : #descriptions }
GtLRefactoringChange >> changeDescriptionDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Change description';
		accessor: #changeDescription;
		beRequired
]

{ #category : #accessing }
GtLRefactoringChange >> gtDisplayOn: aStream [
	aStream nextPutAll: self changeDescription
]

{ #category : #initialization }
GtLRefactoringChange >> initializeChangeDescription: aDescriptionString newSource: aSourceString [
	changeDescription := aDescriptionString.
	newSource := aSourceString
]

{ #category : #'llm views' }
GtLRefactoringChange >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #accessing }
GtLRefactoringChange >> newSource [
	^newSource
]

{ #category : #descriptions }
GtLRefactoringChange >> newSourceDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'New source';
		accessor: #newSource;
		beRequired
]
