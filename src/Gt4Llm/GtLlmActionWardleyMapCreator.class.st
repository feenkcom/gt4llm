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
GtLlmActionWardleyMapCreator >> createInitialMapSection [
	| editor |
	^ BrHorizontalPane new hMatchParent vFitContent
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'Create an initial map on: ');
		addChild: (editor := BrEditor new
					aptitude: BrGlamorousRegularEditorAptitude new + BrGlamorousTextAreaSpacingAptitude new);
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude new;
				icon: BrGlamorousVectorIcons accept;
				action: [ self
						announce: (GtLlmSendActionToChat action: 'Create an initial map' arguments: {editor text}) ])
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 2;
		stencil: [ BrVerticalPane new matchParent
				addChild: self createInitialMapSection;
				addChild: (GtWardleyMapElement withDefaultSections
						wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self model);
						yourself) ]
]
