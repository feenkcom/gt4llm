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
				aptitude: (BrGlamorousLabelAptitude new foreground: Color darkGray);
				text: 'Create an initial map with the topic:');
		addChild: (editor := BrEditor new
					hExact: 200;
					vFitContent;
					geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
					margin: (BlInsets left: 5 right: 5);
					aptitude: BrGlamorousRegularEditorAptitude new
							+ (BrStyleCommonAptitude new
									default: [ :aStyle | 
										aStyle
											border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1) ]));
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude;
				icon: BrGlamorousVectorIcons accept;
				label: 'Create initial map';
				action: [ self
						announce: (GtLlmSendActionToChat action: 'Create an initial map' arguments: {editor text}) ]);
		margin: (BlInsets
				top: 2
				bottom: 2
				left: 5
				right: 5)
]

{ #category : #accessing }
GtLlmActionWardleyMapCreator >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 2;
		stencil: [ BrVerticalPane new matchParent
				addChild: self createInitialMapSection;
				addChild: (GtLlmWardleyMapElement withDefaultSections
						creator: self;
						wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self model);
						yourself) ]
]
