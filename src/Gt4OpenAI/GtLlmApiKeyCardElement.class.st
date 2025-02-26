Class {
	#name : #GtLlmApiKeyCardElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'apiKeyButton',
		'testingButton',
		'testingLabel',
		'fileError',
		'clientClass'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtLlmApiKeyCardElement >> apiKeyFile [
	^ clientClass apiKeyFile
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> apiKeyFile: aFile [
	clientClass apiKeyFile: aFile.
	self onApiKeySet
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> clientClass [
	^ clientClass
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> clientClass: anObject [
	clientClass := anObject.
	self onApiKeySet
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> initialize [
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
				addChild: self makeTestingLabel)
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> keyFilePathString [
	| pathString |
	pathString := self apiKeyFile pathString.

	^ pathString size > 60
		ifTrue: [ (pathString truncate: 28) , (pathString last: 28) ]
		ifFalse: [ pathString ]
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> makeApiKeyDropdown [
	^ apiKeyButton := BrButton new
			hFitContentLimited;
			vFitContent;
			margin: (BlInsets left: 0 right: 0);
			aptitude: BrGlamorousButtonWithLabelAptitude
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									fitContent;
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self keyFilePathString ]
							content: [ self makeDropdownContent ])
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> makeDropdownContent [
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
GtLlmApiKeyCardElement >> makeFileError [
	^ fileError := BrLabel new hFitContent
		margin: (BlInsets left: 5);
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors errorBackgroundColor);
		text: ''
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> makeTestingButton [
	testingButton := BrButton new
			fitContent;
			aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
			icon: BrGlamorousVectorIcons play;
			label: 'Test key';
			action: [ [ clientClass withApiKeyFromFile listModels.
				testingLabel
					label: ('Success!' asRopedText foreground: BrGlamorousColors successBackgroundColor) ]
					on: Error
					do: [ :anError | 
						| aFrozenError errorText |
						aFrozenError := GtMagritteActionUtility freeze: anError.
						errorText := (aFrozenError isKindOf: NetworkError)
								ifTrue: [ 'Network error' ]
								ifFalse: [ 'Authentication error' ].
						testingLabel
							model: aFrozenError;
							label: (errorText asRopedText foreground: BrGlamorousColors errorBackgroundColor).
						testingLabel aptitude - BrGlamorousWithDropdownAptitude.
						testingLabel
							addAptitude: (BrGlamorousWithTooltipAptitude
									content: [ | aContainer |
										aContainer := BlElement new
												size: 400 @ 400;
												background: self theme default contentBackgroundColor.
										(aFrozenError gtViewsFor: GtPhlowView empty)
											asElementDo: [ :anElement | 
												anElement size: 800 @ 800.
												aContainer addChild: anElement asScalableElement ].
										aContainer ]) ] ];
			constraintsDo: [ :c | c linear vertical alignCenter ].
	^ testingButton
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> makeTestingLabel [
	^ testingLabel := BrButton new
			hFitContentLimited;
			vFitContent;
			margin: (BlInsets left: 5);
			aptitude: BrGlamorousLabelAptitude;
			label: '';
			action: [ :theButton | 
				theButton model ifNotNil: [ :anObject | 
					anObject inspect ] ]
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> onApiKeySet [
	apiKeyButton label: self keyFilePathString.

	testingLabel label: ''.
	self apiKeyFile exists
		ifTrue: [ fileError text: '' ]
		ifFalse: [ fileError text: 'File does not exist' ]
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> testAction [
	^ testAction
]

{ #category : #accessing }
GtLlmApiKeyCardElement >> testAction: anObject [
	testAction := anObject
]
