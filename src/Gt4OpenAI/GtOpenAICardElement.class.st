Class {
	#name : #GtOpenAICardElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'apiKeyButton',
		'testingButton',
		'testingLabel'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAICardElement >> apiKeyFile [
	^ GtOpenAIClient apiKeyFile
]

{ #category : #accessing }
GtOpenAICardElement >> apiKeyFile: aFile [
	GtOpenAIClient apiKeyFile: aFile.
	self onApiKeySet
]

{ #category : #accessing }
GtOpenAICardElement >> initialize [
	super initialize.

	self fitContent.

	self
		addChild: (BrHorizontalPane new fitContent
				addChild: self makeApiKeyDropdown;
				addChild: self makeTestingButton).
	self addChild: self makeTestingLabel.

	self onApiKeySet
]

{ #category : #accessing }
GtOpenAICardElement >> makeApiKeyDropdown [
	^ apiKeyButton := BrButton new
			margin: (BlInsets left: 0 right: 5);
			aptitude: BrGlamorousButtonWithLabelAptitude
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self apiKeyFile pathString ]
							content: [ self makeDropdownContent ])
]

{ #category : #accessing }
GtOpenAICardElement >> makeDropdownContent [
	| aFileBrowser |
	aFileBrowser := BrFileSelector new.
	aFileBrowser
		vExact: 250;
		hExact: 400;
		buttonLabel: 'Set';
		padding: (BlInsets all: 10);
		file: self apiKeyFile;
		addAptitude: BrGlamorousWithVerticalResizerAptitude
				+ BrGlamorousWithHorizontalResizerAptitude
				+ BrGlamorousWithHorizontalResizerAptitude new beLeft.

	aFileBrowser
		okAction: [ :aFileReference | 
			self apiKeyFile: aFileReference.
			aFileBrowser fireEvent: BrDropdownHideWish new ].

	aFileBrowser
		fileFilterBlock: [ :aFileReference | (FileSystemDirectoryEntry reference: aFileReference) isHidden not ].

	^ aFileBrowser
]

{ #category : #accessing }
GtOpenAICardElement >> makeTestingButton [
	testingButton := BrButton new
			margin: (BlInsets left: 5);
			aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
			icon: BrGlamorousVectorIcons play;
			label: 'Test key';
			action: [ [ GtOpenAIClient withApiKeyFromFile listModels.
				testingLabel
					text: ('Success!' asRopedText foreground: BrGlamorousColors successBackgroundColor) ]
					on: Error
					do: [ testingLabel
							text: ('Authentication error' asRopedText
									foreground: BrGlamorousColors errorBackgroundColor) ] ].
	^ testingButton
]

{ #category : #accessing }
GtOpenAICardElement >> makeTestingLabel [
	^ testingLabel := BrLabel new
			margin: (BlInsets top: 5);
			aptitude: BrGlamorousLabelAptitude;
			text: ''
]

{ #category : #accessing }
GtOpenAICardElement >> onApiKeySet [
	apiKeyButton label: self apiKeyFile pathString.

	testingLabel text: ''
]
