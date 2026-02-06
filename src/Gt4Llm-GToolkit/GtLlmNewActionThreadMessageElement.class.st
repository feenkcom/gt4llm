Class {
	#name : #GtLlmNewActionThreadMessageElement,
	#superclass : #GtLlmNewThreadMessageElement,
	#instVars : [
		'toggleGroup',
		'descriptionElement'
	],
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initialize [
	super initialize.

	self initializeToggleGroup.
	self initializeDescriptionElement.

	self addChildFirst: descriptionElement as: #description.
	self
		addChildFirst: (BrScrollPane new vFitContent
				aptitude: BrScrollPaneAptitude;
				content: toggleGroup)
		as: #toggle.

	self vFitContent
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeContentsElement [
	super initializeContentsElement.
	contentsElement visibility: BlVisibility gone.
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeDescriptionElement [
	descriptionElement := BrEditor new beReadOnlyWithoutSelection
			hMatchParent;
			vFitContentLimited;
			aptitude: (BrGlamorousRegularEditorAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor)
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeToggleGroup [
	toggleGroup := BrToggleGroup new vFitContent
			aptitude: BrGlamorousToggleGroupAptitude new;
			margin: (BlInsets
					top: 3
					bottom: 0
					left: 8
					right: 8)
]

{ #category : #'private - actions' }
GtLlmNewActionThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel currentAction hasArgument
		ifTrue: [ threadMessageViewModel contents: contentsElement text requester: self ].
	threadMessageViewModel sendMessage
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> updateContentsElement [
	contentsElement
		styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateElement [
	super updateElement.
	self updateToggleGroup.
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateToggleGroup [
	toggleGroup removeToggles.
	self threadMessageViewModel actions
		do: [ :anAction | 
			| toggleElement |
			toggleElement := BrToggle new
					aptitude: BrGlamorousToggleWithLabelAptitude new;
					label: anAction name.
			toggleElement
				when: BrToggleActivatedEvent
				do: [ :anEvent | 
					descriptionElement text: anAction description.
					contentsElement
						text: '';
						visibility: (anAction hasArgument
								ifTrue: [ BlVisibility visible ]
								ifFalse: [ BlVisibility gone ]).
					self threadMessageViewModel currentAction: anAction ].
			toggleElement
				when: BlClickEvent
				do: [ :anEvent | anEvent modifiers isAlt ifTrue: [ toggleElement phlow spawnObject: anAction ] ].
			toggleGroup addToggle: toggleElement ].
	toggleGroup viewModel toggles
		ifNotEmpty: [ :aGroupOfToggles | aGroupOfToggles first activate ]
]
