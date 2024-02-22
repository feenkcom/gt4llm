Class {
	#name : #GtOpenAIGtTutor,
	#superclass : #Object,
	#instVars : [
		'prompt',
		'apiKey',
		'client',
		'assistant',
		'model',
		'assistantName',
		'assistantDescription',
		'tools',
		'chats',
		'files',
		'apiFiles',
		'context',
		'smalltalkMethodPipeline'
	],
	#classInstVars : [
		'globalInstance'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtTutor class >> globalInstance [
	^ globalInstance
		ifNil: [ globalInstance := self withApiKeyFromClipboard createAssistant ]
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
			pipeline: context;
			smalltalkMethodPipeline: smalltalkMethodPipeline.
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
	aFile := FileLocator temp / 'AllViews' , 'st'.
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
GtOpenAIGtTutor >> chats [
	^ chats
]

{ #category : #accessing }
GtOpenAIGtTutor >> check: aString [
	<return: #GtLlmCheckerResult>
	^ context check: aString
]

{ #category : #accessing }
GtOpenAIGtTutor >> cleanUp [
	self deleteAssistant.
	self deleteFiles
]

{ #category : #accessing }
GtOpenAIGtTutor >> conventionsDescription [
	^ 'Please follow these conventions carefully:
- Decline any tasks that seem dangerous, irreversible, or that you don''t understand.
- Always review the full conversation prior to answering and maintain continuity.
- If asked for information, just print the information clearly and concisely.
- If asked to do something, print a concise summary of what you''ve done as confirmation.
- If asked a question, respond in a friendly, conversational way. Use programmatically-generated and natural language responses as appropriate.
- If you need clarification, return a SCRIPT that prints your question. In the next interaction, continue based on the user''s response.
- Assume the user would like something concise. For example rather than printing a massive table, filter or summarize it to what''s likely of interest.
- Actively clean up any temporary processes or files you use.
- When looking through files, use git as available to skip files, and skip hidden files (.env, .git, etc) by default.
- You can enrich any object with inspector views for visualization.
- ALWAYS Return your SCRIPT inside of a single pair of ``` delimiters. Only the console output of the first such SCRIPT is visible to the user, so make sure that it''s complete and don''t bother returning anything else. Smalltalk language snippets must be annotated as such, and new methods must always be annotated using smalltalk-method.
- When writing about classes, always use the notation \{\{gtClass:CLASSNAME\}\}, where CLASSNAME is the name of the class. Example: \{\{gtClass:Object\}\} for the Object class.
- When writing about methods, always use the notation \{\{gtMethod:CLASSNAME>>#METHODNAME\}\}, where CLASSNAME is the name of the class and METHODNAME is the name of the method. Example: \{\{gtMethod:Object>>#perform:\}\} for the perform: method on the Object class.
- Smalltalk methods must always be formatted such that the class name is on the first line, and the method body follows. Example:
```smalltalk-method
LargeInteger
divideBy: anotherNumber
	^ self / anotherNumber
```'
]

{ #category : #accessing }
GtOpenAIGtTutor >> createAssistant [
	assistant := client
			createAssistant: (GtOpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: self prompt;
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
	^ (self packageNamesToFiles: {#'GToolkit-Phlow-Examples'})
		, {self allViewsToFile}
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultPrompt [
	^ {Character lf.
		Character lf}
		join: {self tutorDescription.
				self interactionDescription.
				self conventionsDescription.
				self variablesDescription}
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultTools [
	^ {GtOpenAITool new type: 'retrieval'}
]

{ #category : #accessing }
GtOpenAIGtTutor >> deleteAssistant [
	assistant
		ifNotNil: [ [ client deleteAssistant: assistant id.
			assistant := nil ] on: GtOpenAIError do: [  ] ]
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
GtOpenAIGtTutor >> gtChatsFor: aView [
	<gtView>
	^ aView forward
		title: 'Chats';
		priority: 2;
		object: [ chats ];
		view: #gtChatsFor:;
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'New Chat'
			action: [ :aButton :aTab | 
				self addChat.
				aTab viewContentElement phlow update ]
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
GtOpenAIGtTutor >> gtPromptFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self prompt ]
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
	
	prompt := self defaultPrompt.
	model := self defaultModel.
	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	chats := GtOpenAIAssistantChatGroup new.
	context :=  GtLlmContext defaultPipeline.
	smalltalkMethodPipeline := GtLlmCheckPipeline forLanguage: 'smalltalk-method'.
	files := GtOpenAIResourceFilesGroup withAll: self defaultFiles.
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIGtTutor >> interactionDescription [
	^ 'A typical interaction goes like this:
1. The user gives you a natural language PROMPT.
2. You:
    i. Determine what needs to be done
    ii. Write a short Pharo SCRIPT to do it 
    iii. Communicate back to the user by returning the object in the code that is most important.
3. The compiler checks your SCRIPT using a parser then runs it using an executor

You''ll get to see a summary of the provided object as output before your next interaction. If you need to review those 
outputs before completing the task, you can print the word "CONTINUE" at the end of your SCRIPT. 
This can be useful for summarizing documents or technical readouts, reading instructions before
deciding what to do, or other tasks that require multi-step reasoning.
A typical "CONTINUE" interaction looks like this:
1. The user gives you a natural language PROMPT.
2. You:
    i. Determine what needs to be done
    ii. Determine that you need to see the output of some subprocess call to complete the task
    iii. Write a short Pharo SCRIPT to print that and then print the word "CONTINUE"
3. The compiler
    i. Checks and runs your SCRIPT
    ii. Captures the output and appends it to the conversation as "Output of the last script:". If an error occurs the output will be "The last script had a problem:".
    iii. Finds the word "CONTINUE" and sends control back to you
4. You again:
    i. Look at the original PROMPT + the "Output of the last script:" or "The last script had a problem:" to determine what needs to be done
    ii. Write a short Pharo SCRIPT to do it
    iii. Communicate back to the user by returning the most important object in the code.
5. The compiler...'
]

{ #category : #accessing }
GtOpenAIGtTutor >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIGtTutor >> model: anObject [
	model := anObject
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
GtOpenAIGtTutor >> prompt [
	^ prompt
]

{ #category : #accessing }
GtOpenAIGtTutor >> prompt: anObject [
	prompt := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> summaryItems [
	^ {'Name' -> self assistantName.
		'Description' -> self assistantDescription.
		'Model' -> self model.
		'Tools' -> self tools.
		'Prompt' -> self prompt}
]

{ #category : #accessing }
GtOpenAIGtTutor >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIGtTutor >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtOpenAIGtTutor >> tutorDescription [
	^ 'You are a command-line coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit.'
]

{ #category : #accessing }
GtOpenAIGtTutor >> variablesDescription [
	^ 'Today''s date is {date}.
The current working directory is {cwd}.
The user''s operating system is {os}.
The Pharo version is {pharoVersion}
The Glamorous Toolkit version is {gtVersion}'
		format: {#date -> Date today.
				#cwd -> FileLocator imageDirectory pathString.
				#os -> Smalltalk os family.
				#pharoVersion -> Smalltalk version.
				#gtVersion -> GtImage version versionString} asDictionary
]
