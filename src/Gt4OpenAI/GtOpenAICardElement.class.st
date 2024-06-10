Class {
	#name : #GtOpenAICardElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'apiKeyButton',
		'testingButton'
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

	self addChild: self makeApiKeyDropdown.
	self addChild: self makeTestingButton.

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
				testingButton
					icon: BrGlamorousVectorIcons accept;
					label: 'Success!' ]
					on: Error
					do: [ testingButton
							icon: BrGlamorousVectorIcons cancel;
							label: 'Authentication error' ].
				testingButton disable ].
	^ testingButton
]

{ #category : #accessing }
GtOpenAICardElement >> onApiKeySet [
	apiKeyButton label: self apiKeyFile pathString.

	testingButton enable
		icon: BrGlamorousVectorIcons play;
		label: 'Test API key'
]
