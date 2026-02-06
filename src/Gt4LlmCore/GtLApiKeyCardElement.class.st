Class {
	#name : #GtLApiKeyCardElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'apiKeyButton',
		'testingButton',
		'testingLabel',
		'fileError',
		'clientClass'
	],
	#category : 'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLApiKeyCardElement >> apiKeyFile [
	^ clientClass apiKeyFile
]

{ #category : #accessing }
GtLApiKeyCardElement >> apiKeyFile: aFile [
	clientClass apiKeyFile: aFile.
	self onApiKeySet
]

{ #category : #accessing }
GtLApiKeyCardElement >> clientClass [
	^ clientClass
]

{ #category : #accessing }
GtLApiKeyCardElement >> clientClass: anObject [
	clientClass := anObject.
	self onApiKeySet
]

{ #category : #accessing }
GtLApiKeyCardElement >> initialize [
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
GtLApiKeyCardElement >> keyFilePathString [
	| pathString |
	pathString := self apiKeyFile pathString.

	^ pathString size > 60
		ifTrue: [ (pathString truncate: 28) , (pathString last: 28) ]
		ifFalse: [ pathString ]
]

{ #category : #accessing }
GtLApiKeyCardElement >> makeApiKeyDropdown [
	^ apiKeyButton := BrButton new
			hFitContentLimited;
			vFitContent;
			margin: (BlInsets left: 0 right: 0);
			aptitude: BrGlamorousButtonWithLabelAptitude
					+ (BrGlamorousWithExplicitDropdownAptitude
							handle: [ BrButton new
									fitContent;
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self keyFilePathString ]
							content: [ self makeDropdownContent ])
]

{ #category : #accessing }
GtLApiKeyCardElement >> makeDropdownContent [
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
GtLApiKeyCardElement >> makeFileError [
	^ fileError := BrLabel new hFitContent
		margin: (BlInsets left: 5);
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors errorBackgroundColor);
		text: ''
]

{ #category : #accessing }
GtLApiKeyCardElement >> makeTestingButton [
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
						testingLabel aptitude - BrGlamorousWithExplicitDropdownAptitude.
						testingLabel
							addAptitude: (BrGlamorousWithExplicitTooltipAptitude
									content: [ | aContainer |
										aContainer := BlElement new
												size: 400 @ 400;
												background: self theme default contentBackground.
										(aFrozenError gtViewsFor: GtPhlowView empty)
											asElementDo: [ :anElement | 
												anElement size: 800 @ 800.
												aContainer addChild: anElement asScalableElement ].
										aContainer ]) ] ];
			constraintsDo: [ :c | c linear vertical alignCenter ].
	^ testingButton
]

{ #category : #accessing }
GtLApiKeyCardElement >> makeTestingLabel [
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
GtLApiKeyCardElement >> onApiKeySet [
	apiKeyButton label: self keyFilePathString.

	testingLabel label: ''.
	self apiKeyFile exists
		ifTrue: [ fileError text: '' ]
		ifFalse: [ fileError text: 'File does not exist' ]
]
