Class {
	#name : #GtLLepiterEditWardleyMapSnippetTransformationSpecification,
	#superclass : #GtLLepiterEditSnippetTransformationSpecification,
	#instVars : [
		'changes',
		'originalMap',
		'idMap',
		'wardleyMap'
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
		ifNotNil: [ :wm | aNamespace changes addChange: self changeObject ].
	^ nil
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> assignNewIds [
	idMap ifNotNil: [ ^ self ].
	idMap := (self wardleyMap
			ifNotNil: [ :map | 
				map
					optionAt: #newIds
					ifPresent: [ :dict | dict copy ]
					ifAbsent: [  ] ]) ifNil: [ Dictionary new ].
	changes do: [ :each | each updateNewUidsUsing: idMap ]
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> changeObject [
	| changeObjects |
	self assignNewIds.
	changeObjects := OrderedCollection
			withAll: (self changes collect: [ :each | each asChangeIn: self wardleyMap ]).
	idMap notEmpty
		ifTrue: [ changeObjects
				add: (GtWardleyMapAddOptionChange new
						map: self wardleyMap;
						key: #newIds;
						value: idMap;
						yourself) ].
	^ GtWardleyMapCompositeChange new
		map: self wardleyMap;
		originalMap: self originalMap;
		changes: changeObjects;
		yourself
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

{ #category : #views }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> gtOriginalMapFor: aView [
	<gtView>
	^ aView forward
		title: 'OriginalMap live';
		object: [ originalMap ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> highlightedModificationsInPreview [
	^ self changeObject highlightedModificationsInPreview
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> originalMap [
	^ originalMap ifNil: [ originalMap := self wardleyMap copy ]
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> originalMap: anObject [
	originalMap := anObject
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> pageUidString: anUid [
	super pageUidString: anUid.
	self resetOriginalMap
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> previewMap [
	^ self changeObject previewMap
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> proposedModificationsInPreview [
	| map |
	map := self originalMap copy.
	self changes ifNil: [ ^ map ].
	self changes do: [ :each | each proposeModificationsIn: map ].
	^ map
]

{ #category : #initialization }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> resetOriginalMap [
	originalMap := nil.
	self snippetUid ifNil: [ ^ self ].
	self pageUidString isEmptyOrNil ifTrue: [ ^ self ].
	originalMap := self wardleyMap copy
]

{ #category : #'as yet unclassified' }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> snippetUid: anUid [
	super snippetUid: anUid.
	self resetOriginalMap
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> wardleyMap [
	wardleyMap ifNotNil: [ ^ wardleyMap ].
	^ [ wardleyMap := self targetSnippet wardleyMap ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #accessing }
GtLLepiterEditWardleyMapSnippetTransformationSpecification >> wardleyMap: anObject [
	wardleyMap := anObject.
	originalMap := wardleyMap copy
]
