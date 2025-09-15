Class {
	#name : #GtOpenAIWardleyMapMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #accessing }
GtOpenAIWardleyMapMessage class >> leJsonV4Name [

	^ #gtOpenAIWardleyMapMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> diffedMapModel [
	| ownModel differ |
	ownModel := self mapModel.
	self ancestor ifNil: [ ^ ownModel ].
	self ancestor mapModel ifNil: [ ^ ownModel ].
	differ := GtWardleyMapDiffer diffFrom: self ancestor mapModel to: ownModel.
	differ addedEdges
		do: [ :anEdge | anEdge addWardleyMapDecoratorModel: GtWardleyMapAddProposition new beReadOnly ].
	differ addedNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapAddProposition new beReadOnly ].
	differ removedNodes
		do: [ :aNode | 
			ownModel
				addNode: (aNode removeParent
						addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new beReadOnly) ].
	differ removedEdges
		do: [ :anEdge | 
			| newEdge |
			newEdge := GtWardleyMapEdgeModel new
					fromNode: (ownModel
							nodeWithName: anEdge fromNode label
							ifFound: #yourself
							ifNone: [ self error: 'Node not found' ]);
					toNode: (ownModel
							nodeWithName: anEdge toNode label
							ifFound: #yourself
							ifNone: [ self error: 'Node not found' ]);
					addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new beReadOnly.
			ownModel addEdge: newEdge ].
	^ ownModel
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> gtChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].
	^ aView explicit
		title: 'Changes';
		priority: 2;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: self diffedMapModel);
				constraintsDo: [ :c | c minHeight: 300 ];
				matchParent]
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> gtInstanceFor: aView [
	<gtView>
	^ aView forward
		title: 'Chat instance';
		priority: 15;
		object: [ self chat ];
		view: #gtInstanceFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> gtRenamesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self renamesCodeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView columnedList
		title: 'Renames';
		priority: 10;
		items: [ self renames associations ];
		column: 'Name' text: #key;
		column: 'Proposals' text: [:aPair | ',' join: aPair value] weight: 2;
		send: #value
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].
	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self mapModel);
				constraintsDo: [ :c | c minHeight: 300 ];
				matchParent ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Apply propositions'
			action: [ :aButton | self chat updateInstance: self mapCodeBlock ]
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> mapCodeBlock [
	^ self contentJson at: 'Wardley Map' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> mapModel [
	self mapCodeBlock ifEmpty: [ ^ nil ].
	^ (GtWardleyMapParser parse: self mapCodeBlock) asWardleyMapModel
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> renames [
	^ STONJSON fromString: self renamesCodeBlock
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapMessage >> renamesCodeBlock [
	^ self contentJson at: 'Rename' ifAbsent: [ '' ]
]
