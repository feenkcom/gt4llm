Class {
	#name : #GtLlmActionWardleyMapCreator,
	#superclass : #GtLlmWardleyMapCreator,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'Gt4Llm-Examples'
}

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
						wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self model);
						yourself) ]
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> setNodes: aListOfNodes [
	| unsetNodes |
	unsetNodes := self model nodes copy.

	aListOfNodes
		do: [ :aNode | 
			| aName |
			aName := aNode at: 'name'.
			unsetNodes
				detect: [ :anUnsetNode | aName = anUnsetNode label ]
				ifFound: [ :anUnsetNode | unsetNodes remove: anUnsetNode ]
				ifNone: [ | aNodeModel |
					aNodeModel := GtWardleyMapNodeModel new
							label: aName;
							x: (aNode at: 'x');
							y: (aNode at: 'y');
							addWardleyMapDecoratorModel: GtWardleyMapAddProposition new.
					self model addNode: aNodeModel.
					nodes at: aName put: aNodeModel ] ].

	unsetNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ]
]
