"
I display ACP session configuration beneath the session title. My collapsed summary shows current model and effort; my expanded content is a Magritte form that applies selections through ACP. I use the coder expander appearance and preserve expansion state when advertised values or choices change.
"
Class {
	#name : #GtLACPSessionConfigurationElement,
	#superclass : #BrExpander,
	#instVars : [
		'configOptions',
		'session'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPSessionConfigurationElement >> buildDetails [
	configOptions
		ifEmpty: [ ^ BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'No configuration options advertised';
				margin: (BlInsets all: 5);
				yourself ].
	^ GtLACPSessionConfigurationForm new
		session: session;
		configOptions: configOptions;
		asElement
]

{ #category : #building }
GtLACPSessionConfigurationElement >> buildSectionLabel: aString [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new
				foreground: Color gray;
				fontSize: 12);
		text: aString , ':';
		margin: (BlInsets
				top: 5
				right: 5
				bottom: 5
				left: 5);
		yourself
]

{ #category : #building }
GtLACPSessionConfigurationElement >> buildSummary [
	| pane |
	pane := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			alignCenterLeft;
			yourself.
	pane addChild: (self buildSectionLabel: 'Model').
	pane
		addChild: ((self buildValueLabelFor: (self optionForCategory: 'model' ids: #('model')))
				id: #'acp-configuration-model';
				yourself).
	pane addChild: (self buildSectionLabel: 'Effort').
	pane
		addChild: ((self
				buildValueLabelFor: (self optionForCategory: 'thought_level' ids: #('reasoning_effort' 'effort')))
				id: #'acp-configuration-effort';
				yourself).
	^ pane
]

{ #category : #building }
GtLACPSessionConfigurationElement >> buildValueLabelFor: anOption [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new
				glamorousCodeFont;
				fontSize: 12);
		text: (self currentValueLabelFor: anOption);
		hFitContentLimited;
		margin: (BlInsets
				top: 5
				right: 10
				bottom: 5
				left: 0);
		yourself
]

{ #category : #private }
GtLACPSessionConfigurationElement >> choiceNamed: aValue in: choices [
	choices
		do: [ :each | 
			(each includesKey: 'options')
				ifTrue: [ (self choiceNamed: aValue in: (each at: 'options'))
						ifNotNil: [ :choice | ^ choice ] ]
				ifFalse: [ (each at: 'value' ifAbsent: [ nil ]) = aValue ifTrue: [ ^ each ] ] ].
	^ nil
]

{ #category : #accessing }
GtLACPSessionConfigurationElement >> configOptions [
	^ configOptions
]

{ #category : #accessing }
GtLACPSessionConfigurationElement >> configOptions: aCollection [
	| options |
	options := aCollection ifNil: [ #() ].
	configOptions = options ifTrue: [ ^ self ].
	configOptions := options deepCopy.
	self updateElements
]

{ #category : #private }
GtLACPSessionConfigurationElement >> currentValueLabelFor: anOption [
	| value choice |
	anOption ifNil: [ ^ 'Not advertised' ].
	(anOption includesKey: 'currentValue') ifFalse: [ ^ 'Not available' ].
	value := anOption at: 'currentValue'.
	choice := self
			choiceNamed: value
			in: (anOption at: 'options' ifAbsent: [ #() ]).
	^ choice
		ifNil: [ value asString ]
		ifNotNil: [ choice at: 'name' ifAbsent: [ value asString ] ]
]

{ #category : #initialization }
GtLACPSessionConfigurationElement >> initialize [
	super initialize.
	configOptions := #().
	self
		aptitude: GtCoderExpanderAptitude;
		hMatchParent;
		vFitContent.
	self margin: (BlInsets top: 5 bottom: 5).
	self
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			self expand ].
	self updateElements
]

{ #category : #private }
GtLACPSessionConfigurationElement >> optionForCategory: aCategory ids: fallbackIds [
	^ configOptions
		detect: [ :each | (each at: 'category' ifAbsent: [ '' ]) = aCategory ]
		ifNone: [ configOptions
				detect: [ :each | fallbackIds includes: (each at: 'id' ifAbsent: [ '' ]) ]
				ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLACPSessionConfigurationElement >> session: aSession [
	session == aSession ifTrue: [ ^ self ].
	session := aSession.
	configOptions := (session ifNil: [ #() ] ifNotNil: #configOptions) deepCopy.
	self updateElements
]

{ #category : #updating }
GtLACPSessionConfigurationElement >> updateElements [
	self header: [ self buildSummary ].
	self content: [ self buildDetails ]
]
