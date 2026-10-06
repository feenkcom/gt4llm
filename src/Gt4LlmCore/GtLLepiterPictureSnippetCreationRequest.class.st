"
Request for creating a picture snippet.
"
Class {
	#name : #GtLLepiterPictureSnippetCreationRequest,
	#superclass : #GtLLepiterSnippetCreationRequest,
	#instVars : [
		'urlString',
		'caption',
		'previewHeight'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'PictureSnippet'
]

{ #category : #building }
GtLLepiterPictureSnippetCreationRequest >> buildSnippetFor: aTool [
	| snippet |
	snippet := LePictureSnippet empty
		urlString: (self databaseUrlStringFor: aTool).
	caption ifNotNil: [ snippet caption: caption asString ].
	previewHeight ifNotNil: [ snippet previewHeight: previewHeight ].
	^ snippet
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> caption [
	^ caption
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> caption: aString [
	caption := aString
]

{ #category : #magritte }
GtLLepiterPictureSnippetCreationRequest >> captionDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Caption';
		comment: 'Optional caption for the picture.';
		accessor: #caption;
		yourself
]

{ #category : #building }
GtLLepiterPictureSnippetCreationRequest >> databaseUrlStringFor: aTool [
	"Answer the picture URL, copying a local file into the database attachments unless it is already an attachment."
	| pictureString urlUtility url database |
	pictureString := self urlString asString.
	(pictureString beginsWith: 'attachments') ifTrue: [ ^ pictureString ].

	urlUtility := GtUrlStringUtility new
		rootDirectory: aTool database localStoreRootDirectory;
		urlString: pictureString.
	urlUtility isValid ifFalse: [ ^ pictureString ].
	url := urlUtility urlString asZnUrl.
	url isFile ifFalse: [ ^ pictureString ].

	database := aTool database isLogicalDatabase
		ifTrue: [ aTool database primaryDB ]
		ifFalse: [ aTool database ].
	^ database addAttachmentByCopy: pictureString asFileReference
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> previewHeight [
	^ previewHeight
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> previewHeight: aNumber [
	previewHeight := aNumber
]

{ #category : #magritte }
GtLLepiterPictureSnippetCreationRequest >> previewHeightDescription [
	<magritteDescription>

	^ MANumberDescription new
		label: 'Preview height';
		comment: 'Optional preview height in pixels.';
		accessor: #previewHeight;
		yourself
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> urlString [
	^ urlString
]

{ #category : #accessing }
GtLLepiterPictureSnippetCreationRequest >> urlString: aString [
	urlString := aString
]

{ #category : #magritte }
GtLLepiterPictureSnippetCreationRequest >> urlStringDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'URL string';
		comment: 'URL of the picture to display.';
		accessor: #urlString;
		beRequired;
		yourself
]

{ #category : #validating }
GtLLepiterPictureSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(urlString isNil or: [ urlString asString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: self;
				missingArgument: 'urlString' ].
	(previewHeight notNil and: [ previewHeight < 0 ])
		ifTrue: [ ^ GtLProblemDomainObject new
			description: 'Preview height must be equal or greater than 0' ].
	^ aBlock value
]
