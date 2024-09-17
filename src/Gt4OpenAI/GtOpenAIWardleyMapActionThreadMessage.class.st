Class {
	#name : #GtOpenAIWardleyMapActionThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> diffedMapModel [
	| ownModel differ |
	ownModel := self mapModel.

	self ancestor ifNil: [ ^ ownModel ].
	self ancestor mapModel ifNil: [ ^ ownModel ].

	differ := GtWardleyMapDiffer diffFrom: self ancestor mapModel to: ownModel.

	differ addedEdges
		do: [ :anEdge | anEdge addWardleyMapDecoratorModel: GtWardleyMapAddProposition new ].
	differ addedNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapAddProposition new ].
	differ removedNodes
		do: [ :aNode | 
			ownModel
				addNode: (aNode removeParent
						addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new) ].
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
					addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new.
			ownModel addEdge: newEdge ].

	^ ownModel
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> explanationCodeBlock [
	^ self contentJson at: 'Explanation' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action ifEmpty: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtRawMessageFor: aView [
	<gtLlmMessageView>
	<gtView>
	^ aView textEditor
		title: 'Raw message';
		priority: 5;
		text: [ self contentText ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifEmpty: [ ^ aView empty ].

	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: self diffedMapModel;
						openAITutorChat: self chat);
				vExact: 500 ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> mapCodeBlock [
	^ self contentJson at: 'Wardley Map' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> mapModel [
	self mapCodeBlock ifEmpty: [ ^ nil ].
	^ (GtWardleyMapParser parse: self mapCodeBlock) asWardleyMapModel
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> renamesCodeBlock [
	^ self contentJson at: 'Rename' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> topicCodeBlock [
	^ self contentJson at: 'Topic' ifAbsent: [ '' ]
]
