"
Snapshot of changes from the reference commit to the current GT working copy. No repository mutations are performed.
"
Class {
	#name : #GtLGitRepositoryChanges,
	#superclass : #Object,
	#instVars : [
		'repositoryName',
		'changes',
		'diff'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLGitRepositoryChanges >> changes [
	^ changes
]

{ #category : #magritte }
GtLGitRepositoryChanges >> changesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #changes;
		classes: {GtLGitChange};
		beReadOnly
]

{ #category : #private }
GtLGitRepositoryChanges >> collectChangesFrom: aNode into: aCollection [
	aNode value hasChanges
		ifTrue: [ aCollection add: (GtLGitChange new initializeFromNode: aNode) ].
	aNode children do: [ :each | self collectChangesFrom: each into: aCollection ]
]

{ #category : #accessing }
GtLGitRepositoryChanges >> diff [
	^ diff
]

{ #category : #'gt-views' }
GtLGitRepositoryChanges >> gtChangesFor: aView [
	"Which definitions changed, and how? Select a row to inspect old and new contents."

	<gtView>
	^ aView columnedList
		title: 'Changes';
		priority: 1;
		items: [ self changes ];
		column: 'Kind' text: #kind;
		column: 'Logical path'
			text: #path
			weight: 4
]

{ #category : #initialization }
GtLGitRepositoryChanges >> initializeFromRepository: aRepository [
	repositoryName := aRepository name.
	diff := aRepository workingCopyDiff.
	^ self initializeFromTree: diff treeToShow
]

{ #category : #initialization }
GtLGitRepositoryChanges >> initializeFromTree: aTree [
	| collected |
	collected := OrderedCollection new.
	aTree ifNotNil: [ self collectChangesFrom: aTree into: collected ].
	changes := collected asArray
]

{ #category : #llm }
GtLGitRepositoryChanges >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLGitRepositoryChanges >> repositoryName [
	^ repositoryName
]

{ #category : #magritte }
GtLGitRepositoryChanges >> repositoryNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #repositoryName;
		beReadOnly
]
