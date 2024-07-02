Class {
	#name : #GtLlmActionWardleyMapCreator,
	#superclass : #GtLlmWardleyMapCreator,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> addRenameFor: aName withOptions: aListOfOptions [
	model
		nodeWithName: aName
		ifFound: [ :aNode | 
			aNode
				addWardleyMapDecoratorModel: (GtWardleyMapRenameProposition new options: aListOfOptions) ]
		ifNone: [  ]
]

{ #category : #announcer }
GtLlmActionWardleyMapCreator >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> gtInspectModelFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Inspect instance';
		priority: 1;
		action: [ :aButton | aButton phlow spawnObject: self model ]
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 2;
		stencil: [ BrVerticalPane new matchParent
				addChild: (GtLlmWardleyMapElement withDefaultSections
						creator: self;
						wardleyMapViewModel: (GtWardleyMapViewModel new 
							wardleyMapModel: self model;
							llmCreator: self);
						yourself) ]
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> gtWardleyScriptFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Script';
		priority: 5;
		object: [ self model ];
		view: #gtWardleyScriptFor:
]

{ #category : #initialization }
GtLlmActionWardleyMapCreator >> initializeWardleyMapModel: aGtWardleyMapModel [
	model := aGtWardleyMapModel.
	nodes := (aGtWardleyMapModel nodes collect: [ :aNode | aNode label -> aNode ])
			asDictionary
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> proposeModel: aModel [
	| unsetNodes unsetEdges |
	unsetNodes := self model nodes copy.

	aModel nodes
		do: [ :aNode | 
			| aName |
			aName := aNode label.
			unsetNodes
				detect: [ :anUnsetNode | aName = anUnsetNode label ]
				ifFound: [ :anUnsetNode | unsetNodes remove: anUnsetNode ]
				ifNone: [ aNode removeParent
						addWardleyMapDecoratorModel: GtWardleyMapAddProposition new.
					self model addNode: aNode.
					nodes at: aName put: aNode ] ].

	unsetNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ].

	unsetEdges := self model edges copy.

	aModel edges
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
					self model addEdge: anEdge ] ].

	unsetEdges
		do: [ :anEdge | anEdge addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ]
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> serialize [
	^ '```wardley-map
' , self model asWardleyMapScript
		, '
```'
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> setNodes: aListOfNodes [
	| unsetNodes |
	unsetNodes := self model nodes copy.

	aListOfNodes
		do: [ :aNode | 
			| aName foundNode |
			aName := aNode at: 'name'.
			foundNode := nil.
			unsetNodes
				detect: [ :anUnsetNode | aName = anUnsetNode label ]
				ifFound: [ :anUnsetNode | 
					unsetNodes remove: anUnsetNode.
					foundNode := anUnsetNode ]
				ifNone: [ | aNodeModel |
					aNodeModel := GtWardleyMapNodeModel new
							label: aName;
							x: (aNode at: 'evolution');
							y: 1 - (aNode at: 'visibility');
							addWardleyMapDecoratorModel: GtWardleyMapAddProposition new.
					self model addNode: aNodeModel.
					nodes at: aName put: aNodeModel.
					foundNode := aNodeModel ].
			((aNode includesKey: 'alternative_names')
				and: [ (aNode at: 'alternative_names') isEmptyOrNil not ])
				ifTrue: [ foundNode
						addWardleyMapDecoratorModel: (GtWardleyMapRenameProposition new options: (aNode at: 'alternative_names')) ] ].

	unsetNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ]
]
