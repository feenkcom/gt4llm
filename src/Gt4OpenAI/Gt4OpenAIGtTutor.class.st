Class {
	#name : #Gt4OpenAIGtTutor,
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
		'executor',
		'files'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
Gt4OpenAIGtTutor class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantChat new
			assistant: self assistant;
			executor: self executor.
	chats add: aChat.
	^ aChat
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> addFile: aFile [
	files add: aFile
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> apiKey [
	^ apiKey
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> apiKey: anObject [
	apiKey := anObject.
	
	self onApiKeyChanged
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistant [
	self
		assert: [ assistant isNotNil ]
		description: [ 'Assistant must be created explicitly, e.g., by calling #createAssistant' ].
	^ assistant
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistantDescription [
	^ assistantDescription
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistantDescription: anObject [
	assistantDescription := anObject
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistantName [
	^ assistantName
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> assistantName: anObject [
	assistantName := anObject
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> chats [
	^ chats
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> createAssistant [
	assistant := client
			createAssistant: (Gt4OpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: self prompt;
					tools: self tools).

	files
		do: [ :aFile | 
			| file |
			file := client uploadFile: aFile withPurpose: 'assistants'.
			client createAssistantFile: file id forAssistant: assistant id ]
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultAssistantDescription [
	^ 'Teaches you about GT.'
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultAssistantName [
	^ 'GT Tutor'
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultFiles [
	^ self
		packageNamesToFiles: {#'GToolkit-Phlow'.
				#'GToolkit-Phlow-Examples'}
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultPrompt [
	^ 'You are a command-line coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit.

A typical interaction goes like this:
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
    ii. Captures the output and appends it to the conversation as "LAST SCRIPT OUTPUT:". If an error occurs the output will be "LAST SCRIPT ERROR:".
    iii. Finds the word "CONTINUE" and sends control back to you
4. You again:
    i. Look at the original PROMPT + the "LAST SCRIPT OUTPUT:" or "LAST SCRIPT ERROR:" to determine what needs to be done
    ii. Write a short Pharo SCRIPT to do it
    iii. Communicate back to the user by returning the most important object in the code.
5. The compiler...

Please follow these conventions carefully:
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
- ALWAYS Return your SCRIPT inside of a single pair of ``` delimiters. Only the console output of the first such SCRIPT is visible to the user, so make sure that it''s complete and don''t bother returning anything else.
- When writing about classes, always use the notation \{\{gtClass:CLASSNAME\}\}, where CLASSNAME is the name of the class. Example: \{\{gtClass:Object\}\} for the Object class.
- When writing about methods, always use the notation \{\{gtMethod:CLASSNAME>>#METHODNAME\}\}, where CLASSNAME is the name of the class and METHODNAME is the name of the method. Example: \{\{gtMethod:Object>>#perform:\}\} for the perform: method on the Object class.

Today''s date is {date}.
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

{ #category : #accessing }
Gt4OpenAIGtTutor >> defaultTools [
	^ {Gt4OpenAITool new type: 'retrieval'}
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> execute: aString [
	<return: #Gt4OpenAIExecutionResult>
	^ executor execute: aString
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> files [
	^ files
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> files: aCollection [
	files := aCollection
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> gtChatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 2;
		items: [ chats ];
		column: 'Assistant' text: [ :aChat | aChat assistant id ];
		column: 'Messages' text: [ :aChat | aChat messages size ];
		column: 'Last updated' text: [ :aChat | aChat lastUpdate ifNil: [ '' ] ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'New Chat'
			action: [ :aButton :aTab | 
				self addChat.
				aTab viewContentElement phlow update ]
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> gtFilesFor: aView [
	<gtView>
	^ aView list
		title: 'Files';
		priority: 7;
		items: [ self files ]
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> gtPromptFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self prompt ]
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> gtSummaryFor: aView [
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
Gt4OpenAIGtTutor >> initialize [
	super initialize.
	
	prompt := self defaultPrompt.
	model := self defaultModel.
	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	chats := OrderedCollection new.
	executor :=  Gt4OpenAIExecutor new.
	files := OrderedCollection withAll: self defaultFiles
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> onApiKeyChanged [
	client := Gt4OpenAIClient new apiKey: self apiKey
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> packageNamesToFiles: aCollectionOfPackageNames [
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
			aFile ]
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> prompt [
	^ prompt
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> prompt: anObject [
	prompt := anObject
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> summaryItems [
	^ {'Name' -> self assistantName.
		'Description' -> self assistantDescription.
		'Model' -> self model.
		'Tools' -> self tools.
		'Prompt' -> self prompt}
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> tools [
	^ tools
]

{ #category : #accessing }
Gt4OpenAIGtTutor >> tools: anObject [
	tools := anObject
]
