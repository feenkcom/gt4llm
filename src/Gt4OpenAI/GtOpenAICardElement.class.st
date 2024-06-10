Class {
	#name : #GtOpenAICardElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'apiKeyButton',
		'testingButton',
		'testingLabel',
		'fileError'
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
		addChild: (BrHorizontalPane new vFitContent hMatchParent
				addChild: self makeApiKeyDropdown;
				addChild: self makeFileError).
	self
		addChild: (BrHorizontalPane new vFitContent hMatchParent
				margin: (BlInsets top: 5);
				addChild: self makeTestingButton;
				addChild: self makeTestingLabel).

	self onApiKeySet
]

{ #category : #accessing }
GtOpenAICardElement >> keyFilePathString [
	| pathString |
	pathString := self apiKeyFile pathString.

	^ pathString size > 60
		ifTrue: [ (pathString truncate: 28) , (pathString last: 28) ]
		ifFalse: [ pathString ]
]

{ #category : #accessing }
GtOpenAICardElement >> makeApiKeyDropdown [
	^ apiKeyButton := BrButton new
			margin: (BlInsets left: 0 right: 5);
			aptitude: BrGlamorousButtonWithLabelAptitude
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self keyFilePathString ]
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
GtOpenAICardElement >> makeFileError [
	^ fileError := BrLabel new hFitContent
		margin: (BlInsets left: 5);
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors errorBackgroundColor);
		text: ''
]

{ #category : #accessing }
GtOpenAICardElement >> makeTestingButton [
	testingButton := BrButton new
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
	^ testingLabel := BrLabel new hFitContent
			margin: (BlInsets left: 5);
			aptitude: BrGlamorousLabelAptitude;
			text: ''
]

{ #category : #accessing }
GtOpenAICardElement >> onApiKeySet [
	apiKeyButton label: self keyFilePathString.

	testingLabel text: ''.
	self apiKeyFile exists
		ifTrue: [ fileError text: '' ]
		ifFalse: [ fileError text: 'File does not exist' ]
]
