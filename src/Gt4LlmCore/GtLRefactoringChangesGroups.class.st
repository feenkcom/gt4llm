"
I am the groups argument of the getRefactoringChanges tool ({{gtClass:GtLToolForRefactoringChanges}}): the groups of changes to list, each with its page ({{gtClass:GtLRefactoringChangesPage}}). My keys are the keys of the groups in the responses of the refactoring tools.
"
Class {
	#name : #GtLRefactoringChangesGroups,
	#superclass : #Object,
	#instVars : [
		'classChanges',
		'methodChanges',
		'lepiterChanges',
		'otherChanges'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #accessing }
GtLRefactoringChangesGroups >> classChanges [
	^ classChanges
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> classChanges: aPage [
	classChanges := aPage
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> classChangesDescription [
	<magritteDescription>
	^ self
		pageDescriptionAccessor: #classChanges
		label: 'Class changes'
		comment: 'The changed classes.'
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The groups to list, by their keys in the responses, each with its offset and limit. Required for a preview or result whose changes are grouped.';
		yourself
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> lepiterChanges [
	^ lepiterChanges
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> lepiterChanges: aPage [
	lepiterChanges := aPage
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> lepiterChangesDescription [
	<magritteDescription>
	^ self
		pageDescriptionAccessor: #lepiterChanges
		label: 'Lepiter changes'
		comment: 'The changed Lepiter snippets, counted one by one across databases and pages.'
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> methodChanges [
	^ methodChanges
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> methodChanges: aPage [
	methodChanges := aPage
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> methodChangesDescription [
	<magritteDescription>
	^ self
		pageDescriptionAccessor: #methodChanges
		label: 'Method changes'
		comment: 'The changed methods.'
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> otherChanges [
	^ otherChanges
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> otherChanges: aPage [
	otherChanges := aPage
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> otherChangesDescription [
	<magritteDescription>
	^ self
		pageDescriptionAccessor: #otherChanges
		label: 'Other changes'
		comment: 'The other changes, such as package changes.'
]

{ #category : #magritte }
GtLRefactoringChangesGroups >> pageDescriptionAccessor: aSelector label: aLabel comment: aString [
	^ MAToOneRelationDescription new
		label: aLabel;
		accessor: aSelector;
		classes: {GtLRefactoringChangesPage};
		comment: aString;
		beOptional
]

{ #category : #accessing }
GtLRefactoringChangesGroups >> pagesByGroupName [
	"Return the pages of the groups asked for, by the keys of the groups in the responses"

	| pages |
	pages := OrderedDictionary new.
	{'classChanges' -> classChanges.
		'methodChanges' -> methodChanges.
		'lepiterChanges' -> lepiterChanges.
		'otherChanges' -> otherChanges}
		do: [ :each | each value ifNotNil: [ :aPage | pages at: each key put: aPage ] ].
	^ pages
]
