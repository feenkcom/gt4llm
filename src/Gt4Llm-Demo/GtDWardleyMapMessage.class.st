Class {
	#name : #GtDWardleyMapMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> diffedModel [
	| oldModel newModel unsetNodes unsetEdges nodes |
	oldModel := (GtWardleyMapParser parse: self pipeline instance contentValue)
			asWardleyMapModel.
	newModel := (GtWardleyMapParser parse: self wardleyMap) asWardleyMapModel.
	unsetNodes := oldModel nodes copy.
	nodes := Dictionary new.

	newModel nodes
		do: [ :aNode | 
			| aName |
			aName := aNode label.
			unsetNodes
				detect: [ :anUnsetNode | aName = anUnsetNode label ]
				ifFound: [ :anUnsetNode | unsetNodes remove: anUnsetNode ]
				ifNone: [ aNode removeParent
						addWardleyMapDecoratorModel: GtWardleyMapAddProposition new.
					oldModel addNode: aNode.
					nodes at: aName put: aNode ] ].

	unsetNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ].

	unsetEdges := oldModel edges copy.

	newModel edges
		do: [ :anEdge | 
			| aKey |
			aKey := anEdge fromNode label -> anEdge toNode label.
			unsetEdges
				detect: [ :anUnsetEdge | aKey = (anUnsetEdge fromNode label -> anUnsetEdge toNode label) ]
				ifFound: [ :anUnsetEdge | unsetEdges remove: anUnsetEdge ]
				ifNone: [ anEdge removeParent
						addWardleyMapDecoratorModel: GtWardleyMapAddProposition new;
						fromNode: (nodes at: aKey key);
						toNode: (nodes at: aKey value).
					oldModel addEdge: anEdge ] ].

	unsetEdges
		do: [ :anEdge | anEdge addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ].
	^ oldModel
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	| view |
	self wardleyMap isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView explicit
			title: 'Wardley map';
			priority: 1;
			stencil: [ GtWardleyMapElement new
					wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self diffedModel);
					vExact: 500 ].
	self isAssistantRole
		ifTrue: [ view
				actionButtonIcon: BrGlamorousVectorIcons accept
				tooltip: 'Save model'
				action: [ self chat pipeline instance updateContent: self wardleyMap ] ].
	^ view
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> gtWardleyMapScriptFor: aView [
	<gtView>
	<gtLlmMessageView>
	self wardleyMap isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Wardley map script';
		priority: 2;
		text: [ self wardleyMap ];
		styler: GtWardleyMapParser gtStyler
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> wardleyMap [
	^ self contentJson at: 'Wardley map'
]
