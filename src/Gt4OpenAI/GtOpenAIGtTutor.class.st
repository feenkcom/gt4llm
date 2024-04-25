Class {
	#name : #GtOpenAIGtTutor,
	#superclass : #GtLlmGtTutor,
	#instVars : [
		'apiKey',
		'assistant',
		'assistantName',
		'assistantDescription',
		'tools',
		'files',
		'apiFiles'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtTutor class >> instance [
	^ instance
		ifNil: [ instance := self withApiKeyFromClipboard createAssistant ]
]

{ #category : #accessing }
GtOpenAIGtTutor class >> instance: aTutor [
	^ instance := aTutor
]

{ #category : #accessing }
GtOpenAIGtTutor class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAIGtTutor >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantChat new
			assistant: self assistant;
			pipeline: context.
	chats add: aChat.

	aChat sendMessage: self files toFileDescriptions.

	^ aChat
]

{ #category : #accessing }
GtOpenAIGtTutor >> addFile: aFile [
	files add: aFile
]

{ #category : #accessing }
GtOpenAIGtTutor >> allViewsToFile [
	| views aFile |
	views := 'gtView' gtPragmas.
	aFile := FileLocator temp / 'AllViews' , 'st.txt'.
	aFile ensureDelete.
	aFile
		writeStreamDo: [ :aStream | 
			aStream
				nextPutAll: ('
'
						join: (views contents
								collect: [ :aMethod | 
									'```smalltalk-method
' , aMethod methodClass asString
										, '
' , aMethod sourceCode
										, '
```' ])) ].
	^ GtOpenAIResourceFile new
		file: aFile;
		description: 'This file lists all the views defined in the image at time of assistant creation in smalltalk-method format.'
]

{ #category : #accessing }
GtOpenAIGtTutor >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtOpenAIGtTutor >> apiKey: anObject [
	apiKey := anObject.
	
	self onApiKeyChanged
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistant [
	self
		assert: [ assistant isNotNil ]
		description: [ 'Assistant must be created explicitly, e.g., by calling #createAssistant' ].
	^ assistant
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistantDescription [
	^ assistantDescription
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistantDescription: anObject [
	assistantDescription := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistantName [
	^ assistantName
]

{ #category : #accessing }
GtOpenAIGtTutor >> assistantName: anObject [
	assistantName := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> cleanUp [
	self deleteAssistant.
	self deleteFiles
]

{ #category : #accessing }
GtOpenAIGtTutor >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIGtTutor >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> createAssistant [
	assistant := client
			createAssistant: (GtOpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: instructions;
					tools: self tools).

	files
		do: [ :aFile | 
			| file |
			file := client uploadFile: aFile file withPurpose: 'assistants'.
			client createAssistantFile: file id forAssistant: assistant id.
			aFile remoteId: file id.
			apiFiles add: file ].

	self class finalizationRegistry add: self
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultAssistantDescription [
	^ 'Teaches you about GT.'
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultAssistantName [
	^ 'GT Tutor - ' , FileLocator home basename
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultFiles [
	^ {self allViewsToFile}
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultTools [
	^ {GtOpenAITool new type: 'retrieval'}
]

{ #category : #accessing }
GtOpenAIGtTutor >> deleteAssistant [
	assistant
		ifNotNil: [ [ client deleteAssistant: assistant id.
			assistant := nil ] on: GtOpenAIError do: [ assistant := nil ] ]
]

{ #category : #accessing }
GtOpenAIGtTutor >> deleteFiles [
	apiFiles
		do: [ :aFile | [ client deleteFile: aFile id ] on: GtOpenAIError do: [  ] ].
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIGtTutor >> files [
	^ files
]

{ #category : #accessing }
GtOpenAIGtTutor >> files: aCollection [
	files := aCollection
]

{ #category : #accessing }
GtOpenAIGtTutor >> finalize [
	self cleanUp.
	
	super finalize
]

{ #category : #accessing }
GtOpenAIGtTutor >> gtCleanUpFor: anAction [
	<gtAction>
	self hasAssistant ifFalse: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons cancel;
		tooltip: 'Clean up assistant and files';
		priority: 5;
		action: [ self cleanUp ]
]

{ #category : #accessing }
GtOpenAIGtTutor >> gtCreateFor: anAction [
	<gtAction>
	self hasAssistant ifTrue: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Create assistant and files';
		priority: 5;
		action: [ self createAssistant ]
]

{ #category : #accessing }
GtOpenAIGtTutor >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 7;
		object: [ self files ];
		view: #gtFilesFor:
]

{ #category : #accessing }
GtOpenAIGtTutor >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 1;
		items: [ self summaryItems ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtOpenAIGtTutor >> hasAssistant [
	^ assistant isNotNil
]

{ #category : #accessing }
GtOpenAIGtTutor >> initialize [
	super initialize.
	
	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	chats := GtOpenAIAssistantChatGroup new.
	files := GtOpenAIResourceFilesGroup withAll: self defaultFiles.
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIGtTutor >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIGtTutor >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> onApiKeyChanged [
	client := GtOpenAIClient new apiKey: self apiKey
]

{ #category : #accessing }
GtOpenAIGtTutor >> packageNamesToFiles: aCollectionOfPackageNames [
	^ aCollectionOfPackageNames
		collect: [ :aPackageName | 
			| classes aFile |
			classes := aPackageName asPackage definedClasses.
			aFile := FileLocator temp / aPackageName , 'package'.
			aFile ensureDelete.
			aFile
				writeStreamDo: [ :aStream | 
					aStream
						nextPutAll: ('
'
								join: (classes
										collect: [ :aClass | String streamContents: [ :s | aClass fileOutOn: s ] ])) ].
			GtOpenAIResourceFile new
				file: aFile;
				description: 'A serialized Pharo package named ' , aPackageName ]
]

{ #category : #accessing }
GtOpenAIGtTutor >> summaryItems [
	^ {'Name' -> self assistantName.
		'Description' -> self assistantDescription.
		'Model' -> self model.
		'Tools' -> self tools.
		'Prompt' -> instructions}
]

{ #category : #accessing }
GtOpenAIGtTutor >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIGtTutor >> tools: anObject [
	tools := anObject
]
