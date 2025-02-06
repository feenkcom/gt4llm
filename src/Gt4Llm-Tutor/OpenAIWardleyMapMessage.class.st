Class {
	#name : #OpenAIWardleyMapMessage,
	#superclass : #OpenAIActionMessage,
	#category : #'Gt4Llm-Tutor-Models'
}

{ #category : #accessing }
OpenAIWardleyMapMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
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

{ #category : #accessing }
OpenAIWardleyMapMessage >> explanationCodeBlock [
	^ self contentJson at: 'Explanation' ifAbsent: [ '' ]
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> gtRawMessageFor: aView [
	<gtLlmMessageView>
	<gtView>
	^ aView textEditor
		title: 'Raw message';
		priority: 5;
		text: [ self contentText ]
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].

	^ aView explicit
		title: 'Map';
		priority: 2;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: self diffedMapModel;
						openAITutorChat: self chat);
				vExact: 500 ]
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> mapCodeBlock [
	^ self contentJson at: 'Wardley Map' ifAbsent: [ '' ]
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> mapModel [
	self mapCodeBlock ifEmpty: [ ^ nil ].
	^ (GtWardleyMapParser parse: self mapCodeBlock) asWardleyMapModel
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> renamesCodeBlock [
	^ self contentJson at: 'Rename' ifAbsent: [ '' ]
]

{ #category : #accessing }
OpenAIWardleyMapMessage >> topicCodeBlock [
	^ self contentJson at: 'Topic' ifAbsent: [ '' ]
]
