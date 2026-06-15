Class {
	#name : #GtLChatRegistryEmptyConnectionsElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'editorElement',
		'buttonElement',
		'updateConnectionsElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #initialization }
GtLChatRegistryEmptyConnectionsElement >> initialize [
	super initialize.

	self
		layout: (BlLinearLayout vertical
				alignCenterLeft;
				cellSpacing: 10);
		matchParent;
		padding: (BlInsets all: 20);
		background: Color white.

	self initializeEditorElement.
	self initializeButtonElement.
	self initializeUpdateConnectionsElement.
	self
		addChild: editorElement;
		addChild: (BrHorizontalPane new
				fitContent;
				alignCenterLeft;
				cellSpacing: 5;
				addChild: buttonElement;
				addChild: updateConnectionsElement)
]

{ #category : #initialization }
GtLChatRegistryEmptyConnectionsElement >> initializeButtonElement [
	buttonElement := BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: 'Setup LLM connections';
			action: [ :aButton | 
				BlSpace new
					withCommonSettings;
					spawnPage: (LeDatabase gtBook pageNamed: 'How to setup LLM connections')
						from: aButton ]
]

{ #category : #initialization }
GtLChatRegistryEmptyConnectionsElement >> initializeEditorElement [
	editorElement := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			vFitContent;
			hMatchParent;
			text: 'To work with the moldable AI agent, you need connections to LLMs. There aren''t any just yet.'
					asRopedText
]

{ #category : #initialization }
GtLChatRegistryEmptyConnectionsElement >> initializeUpdateConnectionsElement [
	updateConnectionsElement := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons refresh;
			label: 'Update Connections';
			action: [ :aButtonElement :aButtonModel :anEvent | 
				self updateConnectionsFrom: anEvent ]
]

{ #category : #'private - event handling' }
GtLChatRegistryEmptyConnectionsElement >> updateConnectionsFrom: anEvent [
	self registryViewModel ifNil: [ ^ self ].
	self registryViewModel updateConnections
]
