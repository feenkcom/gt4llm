Class {
	#name : #OpenAIWardleyMapMessage,
	#superclass : #OpenAIActionMessage,
	#category : #'Gt4OpenAI-Model'
}

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> diffedMapModel [
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
OpenAIWardleyMapMessage >> gtChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].
	^ aView explicit
		title: 'Changes';
		priority: 2;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: self diffedMapModel;
						openAITutorChat: self chat);
				vExact: 500 ]
]

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].
	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: self mapModel;
						openAITutorChat: self chat);
				vExact: 500 ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Apply propositions'
			action: [ :aButton | self chat updateInstance: self mapCodeBlock ]
]

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> mapCodeBlock [
	^ self contentJson at: 'Wardley Map' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> mapModel [
	self mapCodeBlock ifEmpty: [ ^ nil ].
	^ (GtWardleyMapParser parse: self mapCodeBlock) asWardleyMapModel
]

{ #category : #'as yet unclassified' }
OpenAIWardleyMapMessage >> renamesCodeBlock [
	^ self contentJson at: 'Rename' ifAbsent: [ '' ]
]
