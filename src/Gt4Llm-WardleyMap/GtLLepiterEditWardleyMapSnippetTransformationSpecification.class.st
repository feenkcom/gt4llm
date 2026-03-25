Class {
	#name : #GtLLepiterEditWardleyMapSnippetTransformationSpecification,
	#superclass : #GtLLepiterEditSnippetTransformationSpecification,
	#instVars : [
		'changes'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #testing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #'json schema' }
GtLLepiterEditWardleyMapSnippetTransformationSpecification class >> jsonSchemaLabel [
	^ 'EditWardleyMapSnippet'
]

{ #category : #refactoring }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> asRefactoringIn: aNamespace [
	self changes ifNil: [ ^ nil ].
	self targetSnippet wardleyMap
		ifNotNil: [ :wm | self changes do: [ :each | aNamespace changes addChange: (each asChangeIn: wm) ] ].
	^ nil
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changes [
	^ changes
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changes: anObject [
	changes := anObject
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #changes;
		classes: (GtWardleyMapChangeSpecification withAllSubclasses select: #isConcrete);
		useExplicitContainerForChildren;
		beRequired
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> createProposedModifications [
	| map |
	map := self targetSnippet wardleyMap.
	self changes ifNil: [ ^ map ].
	self changes do: [ :each | each proposeModificationsIn: map ].
	^ map
]
