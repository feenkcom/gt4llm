"
Read-only lookup of a registered Iceberg repository by exact name.
"
Class {
	#name : #GtLMagritteToolForGitRepositoryLookup,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForGitRepositoryLookup >> description [
	^ 'Look up a registered Iceberg repository by exact, case-sensitive name. Returns name, location, branch and origin. Does not clone or modify repositories.'
]

{ #category : #accessing }
GtLMagritteToolForGitRepositoryLookup >> name [
	^ 'lookupGitRepository'
]

{ #category : #execution }
GtLMagritteToolForGitRepositoryLookup >> privatePerformToolCall: aToolCall inContext: aContext [
	| name repository |
	name := aToolCall arguments at: 'repositoryName'.
	repository := IceRepository registry
			detect: [ :each | each name = name ]
			ifNone: [ ^ GtLMissingDomainObject new objectName: name ].
	^ GtLGitRepositoryDescription new
		repository: (GtGitRepository fromIcebergRepository: repository);
		yourself
]

{ #category : #magritte }
GtLMagritteToolForGitRepositoryLookup >> repositoryNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #repositoryName;
		label: 'Exact registered repository name';
		beRequired
]
