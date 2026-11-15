"
Repository metadata exposed to an LLM. Retains the GT repository for contextual inspection.
"
Class {
	#name : #GtLGitRepositoryDescription,
	#superclass : #Object,
	#instVars : [
		'repository'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLGitRepositoryDescription >> branch [
	^ repository branchDescription asString
]

{ #category : #magritte }
GtLGitRepositoryDescription >> branchDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #branch;
		beReadOnly
]

{ #category : #llm }
GtLGitRepositoryDescription >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLGitRepositoryDescription >> location [
	^ repository icebergRepository location
		ifNil: [ '' ]
		ifNotNil: [ :aLocation | aLocation fullName ]
]

{ #category : #magritte }
GtLGitRepositoryDescription >> locationDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #location;
		beReadOnly
]

{ #category : #accessing }
GtLGitRepositoryDescription >> origin [
	^ repository originDescription asString
]

{ #category : #magritte }
GtLGitRepositoryDescription >> originDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #origin;
		beReadOnly
]

{ #category : #accessing }
GtLGitRepositoryDescription >> repository [
	^ repository
]

{ #category : #accessing }
GtLGitRepositoryDescription >> repository: anObject [
	repository := anObject
]

{ #category : #accessing }
GtLGitRepositoryDescription >> repositoryName [
	^ repository name
]

{ #category : #magritte }
GtLGitRepositoryDescription >> repositoryNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #repositoryName;
		beReadOnly
]
