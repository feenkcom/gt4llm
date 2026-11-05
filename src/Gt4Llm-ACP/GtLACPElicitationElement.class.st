"
I render ACP user questions, draft form controls and answer summaries. I share interaction layout, buttons, toolbars and error handling with permissions.
"
Class {
	#name : #GtLACPElicitationElement,
	#superclass : #GtLACPInteractionElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPElicitationElement >> buildHeader [
	self addChild: self questionHeader
]

{ #category : #building }
GtLACPElicitationElement >> buildPendingContent [
	request fields
		keysAndValuesDo: [ :key :field | self addChild: (self field: field key: key) ].
	self addChild: errorLabel.
	self addChild: self questionToolbar
]

{ #category : #building }
GtLACPElicitationElement >> buildResolvedContent [
	request state = #decline
		ifTrue: [ ^ self addChild: (self text: 'Questions skipped') ].
	request state = #cancel
		ifTrue: [ ^ self addChild: (self text: 'Questions cancelled') ].
	request state = #accept
		ifTrue: [ ^ request fields
				keysAndValuesDo: [ :key :field | 
					(request answerAt: key)
						ifNotNil: [ :value | 
							self
								addChild: (self
										text: (field at: 'title' ifAbsent: [ key ]) , ': '
												, (value isArray ifTrue: [ ', ' join: value ] ifFalse: [ value asString ])) ] ] ].
	^ self addChild: (self text: request state asString)
]

{ #category : #building }
GtLACPElicitationElement >> choiceTextFor: anOption [
	^ self
		titleAndDescriptionFor: anOption
		defaultTitle: (anOption at: 'const') asString
]

{ #category : #building }
GtLACPElicitationElement >> choices: options field: aField key: aKey [
	| pane |
	pane := BrVerticalPane new
			hMatchParent;
			vFitContent;
			yourself.
	self
		fillChoices: pane
		options: options
		field: aField
		key: aKey.
	^ pane
]

{ #category : #accessing }
GtLACPElicitationElement >> elicitation: anElicitation [
	request := anElicitation.
	self id: ('acp-elicitation-' , request requestId asString) asSymbol.
	self build
]

{ #category : #building }
GtLACPElicitationElement >> field: aField key: aKey [
	| pane options type editor |
	pane := BrVerticalPane new
			hMatchParent;
			vFitContent;
			margin: (BlInsets top: 4 bottom: 4);
			yourself.
	pane
		addChild: (self text: (self titleAndDescriptionFor: aField defaultTitle: aKey)).
	options := request optionsFor: aField.
	type := aField at: 'type'.
	type = 'boolean'
		ifTrue: [ options := {{'const' -> true.
						'title' -> 'Yes'} asDictionary.
					{'const' -> false.
						'title' -> 'No'} asDictionary} ].
	options notEmpty
		ifTrue: [ pane
				addChild: (self
						choices: options
						field: aField
						key: aKey).
			^ pane ].
	editor := BrEditor new
			id: ('acp-question-' , aKey) asSymbol;
			aptitude: BrGlamorousRegularEditorAptitude;
			hMatchParent;
			vFitContent;
			margin: (BlInsets left: 5 right: 5);
			border: (BlBorder paint: self theme button defaultBorderColor width: 1);
			padding: (BlInsets all: 5);
			text: ((request answerAt: aKey) ifNil: [ '' ] ifNotNil: [ :value | value asString ]);
			yourself.
	editor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | 
			| value |
			value := event text asString.
			(#('number' 'integer') includes: type)
				ifTrue: [ value := value isEmpty
							ifTrue: [ nil ]
							ifFalse: [ [ value asNumber ] on: Error do: [ :ex | value ] ] ].
			self performAction: [ request answerAt: aKey put: value ] ].
	pane addChild: editor.
	^ pane
]

{ #category : #building }
GtLACPElicitationElement >> fillChoices: pane options: options field: aField key: aKey [
	pane removeChildren.
	options
		withIndexDo: [ :option :index | 
			| value selected checkbox row text toggle |
			value := option at: 'const'.
			selected := (aField at: 'type') = 'array'
					ifTrue: [ ((request answerAt: aKey) ifNil: [ #() ]) includes: value ]
					ifFalse: [ (request answerAt: aKey) = value ].
			toggle := [ | answer |
				answer := (aField at: 'type') = 'array'
						ifTrue: [ | values |
							values := ((request answerAt: aKey) ifNil: [ #() ]) asOrderedCollection.
							selected
								ifTrue: [ values remove: value ifAbsent: [  ] ]
								ifFalse: [ values add: value ].
							values asArray ]
						ifFalse: [ selected ifTrue: [ nil ] ifFalse: [ value ] ].
				request answerAt: aKey put: answer.
				self
					fillChoices: pane
					options: options
					field: aField
					key: aKey ].
			checkbox := BrCheckbox new
					id: ('acp-question-' , aKey , '-option-' , index asString) asSymbol;
					aptitude: BrGlamorousCheckboxAptitude;
					checked: selected;
					margin: (BlInsets right: 6);
					constraintsDo: [ :c | c linear vertical alignCenter ];
					whenCheckedDo: [ self performAction: toggle ];
					whenUncheckedDo: [ self performAction: toggle ];
					yourself.
			text := (self text: (self choiceTextFor: option))
					padding: BlInsets empty;
					yourself.
			text
				when: BlClickEvent
				do: [ :event | 
					event consumed: true.
					self performAction: toggle ].
			row := BrHorizontalPane new
					padding: (BlInsets all: 5);
					hMatchParent;
					vFitContent;
					addChild: checkbox;
					addChild: text;
					yourself.
			pane addChild: row ]
]

{ #category : #building }
GtLACPElicitationElement >> questionHeader [
	| line question |
	question := BrButton new
			id: #'acp-question-title';
			aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
			hMatchParent;
			alignCenterLeft;
			padding: BlInsets empty;
			label: request message;
			action: [ :button | button phlow spawnObject: (request toolCall ifNil: [ request ]) ];
			yourself.
	line := BrHorizontalPane new
			id: #'acp-question-header';
			hMatchParent;
			vFitContent;
			addChild: (GtLACPWorkBadgeElement new
					id: #'acp-question-kind';
					text: 'question';
					yourself);
			addChild: question;
			yourself.
	line
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			line phlow spawnObject: (request toolCall ifNil: [ request ]) ].
	^ line
]

{ #category : #building }
GtLACPElicitationElement >> questionToolbar [
	^ self newToolbar
		id: #'acp-question-toolbar';
		addItem: (self
				button: 'Submit'
				id: #'acp-question-submit'
				action: [ request submit ]);
		addItem: (self
				button: 'Skip'
				id: #'acp-question-skip'
				action: [ request decline ]);
		yourself
]

{ #category : #building }
GtLACPElicitationElement >> titleAndDescriptionFor: aDictionary defaultTitle: aTitle [
	| text |
	text := (aDictionary at: 'title' ifAbsent: [ aTitle ]) asRopedText.
	aDictionary
		at: 'description'
		ifPresent: [ :description | 
			description
				ifNotNil: [ text := text , (('  ' , description) asRopedText foreground: Color gray) ] ].
	^ text
]
