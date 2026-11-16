"
Read-only retrieval of GT Lepiter-aware working-copy changes relative to the reference commit.
"
Class {
	#name : #GtLMagritteToolForGitRepositoryChanges,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForGitRepositoryChanges >> description [
	^ 'Retrieve uncommitted GT working-copy changes against the reference commit for an exact registered Iceberg repository name. Includes image code and Lepiter-aware changes, not merely a disk git diff. Returns logical diff-tree paths, addition/removal/modification kinds and full old/reference and new/working-copy contents. Does not commit, stage or discard changes.'
]

{ #category : #accessing }
GtLMagritteToolForGitRepositoryChanges >> name [
	^ 'getGitRepositoryChanges'
]

{ #category : #execution }
GtLMagritteToolForGitRepositoryChanges >> privatePerformToolCall: aToolCall inContext: aContext [
	| name repository |
	name := aToolCall arguments at: 'repositoryName'.
	repository := IceRepository registry
			detect: [ :each | each name = name ]
			ifNone: [ ^ GtLMissingDomainObject new objectName: name ].
	^ GtLGitRepositoryChanges new
		initializeFromRepository: (GtGitRepository fromIcebergRepository: repository)
]

{ #category : #magritte }
GtLMagritteToolForGitRepositoryChanges >> repositoryNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #repositoryName;
		label: 'Exact registered repository name';
		beRequired
]
