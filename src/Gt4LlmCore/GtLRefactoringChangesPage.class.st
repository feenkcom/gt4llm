"
I am where a group of changes is listed from and how many of its changes, in a call of the getRefactoringChanges tool ({{gtClass:GtLToolForRefactoringChanges}}): `offset` changes are skipped, then at most `limit` are listed.
"
Class {
	#name : #GtLRefactoringChangesPage,
	#superclass : #Object,
	#instVars : [
		'offset',
		'limit'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #magritte }
GtLRefactoringChangesPage >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The offset and limit of the group.';
		yourself
]

{ #category : #accessing }
GtLRefactoringChangesPage >> limit [
	^ limit
]

{ #category : #accessing }
GtLRefactoringChangesPage >> limit: aNumber [
	limit := aNumber
]

{ #category : #magritte }
GtLRefactoringChangesPage >> limitDescription [
	"At least 1: a page without changes would not move on"

	<magritteDescription>
	^ MANumberDescription new
		label: 'Limit';
		accessor: #limit;
		comment: 'The maximum number of changes to list. Defaults to '
				, GtLRefactoringDisplayOptions defaultLimit printString , ', at most '
				, GtLRefactoringDisplayOptions maximumLimit printString , '.';
		beIntegerInJsonSchema;
		min: 1;
		beOptional
]

{ #category : #accessing }
GtLRefactoringChangesPage >> normalizedLimit [
	^ GtLRefactoringDisplayOptions normalizedLimit: limit
]

{ #category : #accessing }
GtLRefactoringChangesPage >> normalizedOffset [
	"JSON numbers can be read as floats"

	^ (offset ifNil: [ 0 ]) truncated
]

{ #category : #accessing }
GtLRefactoringChangesPage >> offset [
	^ offset
]

{ #category : #accessing }
GtLRefactoringChangesPage >> offset: aNumber [
	offset := aNumber
]

{ #category : #magritte }
GtLRefactoringChangesPage >> offsetDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Offset';
		accessor: #offset;
		comment: 'The number of changes of the group to skip. Defaults to 0; to continue, pass the nextOffset of the group.';
		beIntegerInJsonSchema;
		min: 0;
		beOptional
]

{ #category : #printing }
GtLRefactoringChangesPage >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(offset: ';
		print: self normalizedOffset;
		nextPutAll: ', limit: ';
		print: self normalizedLimit;
		nextPut: $)
]
