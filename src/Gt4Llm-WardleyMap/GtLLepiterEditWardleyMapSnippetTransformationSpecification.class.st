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
	self wardleyMap
		ifNotNil: [ :wm | aNamespace changes addChange: (self changeObjectIn: wm) ].
	^ nil
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changeObject [
	^ self changeObjectIn: self wardleyMap
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changeObjectIn: aWardleyMap [
	^ GtWardleyMapCompositeChange new
		map: aWardleyMap;
		changes: (self changes collect: [ :each | each asChangeIn: aWardleyMap ]);
		yourself
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changes [
	^ changes
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changes: anObject [
	| idMap |
	changes := anObject.
	idMap := Dictionary new.
	changes do: [ :each | each updateNewUidsUsing: idMap ]
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
	map := self wardleyMap.
	self changes ifNil: [ ^ map ].
	self changes do: [ :each | each proposeModificationsIn: map ].
	^ map
]

{ #category : #printing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> gtDisplayOn: stream [
	stream << 'Wardley map snippet transformations (' << changes size printString
		<< ' change' << (changes size = 1 ifTrue: [ ')' ] ifFalse: [ 's)' ])
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> previewMap [
	^ self changeObject previewMap
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> proposedModificationsInPreview [
	| map |
	map := self wardleyMap copy.
	self changes ifNil: [ ^ map ].
	self changes do: [ :each | each proposeModificationsIn: map ].
	^ map
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> wardleyMap [
	^ self targetSnippet wardleyMap
]
