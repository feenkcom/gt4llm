Class {
	#name : #GtOpenAIGtSpecificTutor,
	#superclass : #GtLlmGtSpecificTutor,
	#instVars : [
		'apiKey',
		'assistant',
		'assistantName',
		'assistantDescription',
		'tools',
		'files',
		'apiFiles'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtSpecificTutor class >> instance [
	^ instance
		ifNil: [ instance := self withApiKeyFromFile createAssistant ]
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor class >> instance: aTutor [
	instance := aTutor
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor class >> isTutorAvailable [
	instance ifNotNil: [ ^ true ].
	^ false
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor class >> withApiKeyFromFile [
	^ self new apiKey: GtOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantChat new
			assistant: self assistant;
			tutor: self;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	self files
		ifNotEmpty: [ aChat
				addFiles: self files ].

	^ aChat
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> addFile: aFile [
	files add: aFile
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> allViewsToFile [
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
GtOpenAIGtSpecificTutor >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> apiKey: anObject [
	apiKey := anObject.
	
	self onApiKeyChanged
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistant [
	self
		assert: [ assistant isNotNil ]
		description: [ 'Assistant must be created explicitly, e.g., by calling #createAssistant' ].
	^ assistant
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistantDescription [
	^ assistantDescription
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistantDescription: anObject [
	assistantDescription := anObject
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistantName [
	^ assistantName
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> assistantName: anObject [
	assistantName := anObject
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> cleanUp [
	self deleteAssistant.
	self deleteFiles
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> createAssistant [
	assistant := client
			createAssistant: (GtOpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: self instructions instructionString;
					tools: self tools).

	files
		do: [ :aFile | 
			| file |
			file := client uploadFile: aFile file withPurpose: 'assistants'.
			aFile remoteId: file id.
			apiFiles add: file ].

	self class finalizationRegistry add: self
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> defaultAssistantDescription [
	^ 'Teaches you about GT.'
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> defaultAssistantName [
	^ 'GT Tutor - ' , FileLocator home basename
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> defaultFiles [
	^ {self allViewsToFile}
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> defaultTools [
	^ {GtOpenAITool new type: 'file_search'}
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> deleteAssistant [
	assistant
		ifNotNil: [ [ client deleteAssistant: assistant id.
			assistant := nil ] on: GtOpenAIError do: [ assistant := nil ] ]
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> deleteFiles [
	apiFiles
		do: [ :aFile | [ client deleteFile: aFile id ] on: GtOpenAIError do: [  ] ].
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> ensureAssistant [
	assistant ifNil: [ self createAssistant ]
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> files [
	^ files
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> files: aCollection [
	files := aCollection
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> finalize [
	self cleanUp.
	
	super finalize
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> gtCleanUpFor: anAction [
	<gtAction>
	self hasAssistant ifFalse: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons cancel;
		tooltip: 'Clean up assistant and files';
		priority: 5;
		action: [ self cleanUp ]
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> gtCreateFor: anAction [
	<gtAction>
	self hasAssistant ifTrue: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Create assistant and files';
		priority: 5;
		action: [ self createAssistant ]
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 7;
		object: [ self files ];
		view: #gtFilesFor:
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> gtSummaryFor: aView [
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
GtOpenAIGtSpecificTutor >> hasAssistant [
	^ assistant isNotNil
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> initialize [
	super initialize.
	
	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	files := GtOpenAIResourceFilesGroup withAll: self defaultFiles.
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #'as yet unclassified' }
GtOpenAIGtSpecificTutor >> messageClass [
	^ GtOpenAIThreadMessage
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> onApiKeyChanged [
	client := GtOpenAIClient new apiKey: self apiKey
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> packageNamesToFiles: aCollectionOfPackageNames [
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
GtOpenAIGtSpecificTutor >> summaryItems [
	^ {'Name' -> self assistantName.
		'Description' -> self assistantDescription.
		'Model' -> self model.
		'Tools' -> self tools.
		'Prompt' -> instructions}
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIGtSpecificTutor >> tools: anObject [
	tools := anObject
]
