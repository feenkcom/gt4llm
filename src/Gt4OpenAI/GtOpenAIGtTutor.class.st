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
GtOpenAIGtTutor >> communicationRules [
	^ '# Communication rules
- Decline any tasks that seem dangerous, irreversible, or that you do not understand.
- Always review the full conversation prior to answering and maintain continuity.
- If asked to do something, print a concise summary of what you have done as confirmation.
- If asked a question, respond in a friendly, conversational way. Use programmatically-generated and natural language responses as appropriate.
- Assume the user would like something concise.'
]

{ #category : #accessing }
GtOpenAIGtTutor >> conventionsDescription [
	^ '# Conventions for communication
Please follow these conventions carefully:
- The code you propose can either be a SCRIPT or a METHOD.
- A SCRIPT is always formatted in Markdown smalltalk format like in this example:
```smalltalk
aVariable := 5.
1 + aVariable
```
- Smalltalk methods must always be formatted in Markdown smalltalk-method format and such that the class name is on the first line, and the method body follows, like in this example:
```smalltalk-method
LargeInteger
divideBy: anotherNumber
	^ self / anotherNumber
```
- When writing about classes, always use the notation {{gtClass:CLASSNAME}}, where CLASSNAME is the name of the class. Example: {{gtClass:Object}} for the Object class.
- When writing about methods, always use the notation {{gtMethod:CLASSNAME>>#METHODNAME}}, where CLASSNAME is the name of the class and METHODNAME is the name of the method. Example: {{gtMethod:Object>>#perform:}} for the perform: method on the Object class.
- The first message in the conversation will be a description of the files you have access to. Reply with "How can I assist you today?" to that message.
- When instructed to generate Phlow views, strictly adhere to the API as specified below in the description and outlined in the examples. Do not assume any other view methods or types are available.'
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
	^ {self allViewsToFile}
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
GtOpenAIGtTutor >> defaultPrompt [
	^ String lf , String lf
		join: {self tutorDescription.
				self interactionDescription.
				self communicationRules.
				self conventionsDescription.
				self viewsDescription.
				self exampleViews.
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
			assistant := nil ] on: GtOpenAIError do: [ assistant := nil ] ]
]

{ #category : #accessing }
GtOpenAIGtTutor >> deleteFiles [
	apiFiles
		do: [ :aFile | [ client deleteFile: aFile id ] on: GtOpenAIError do: [  ] ].
	apiFiles := GtOpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIGtTutor >> exampleViews [
	^ '# Example for phlow views

'
		, (String lf , String lf
				join: ({'List view'
							-> 'List
gtListFor: aView
	<gtView>
	^ aView list
		title: ''List'';
		priority: 1;
		items: [self values]'.
						'Columned list view'
							-> 'List
gtColumnedListFor: aView
	<gtView>
	^ aView columnedList
		title: ''Columned list'';
		priority: 1;
		items: [self values];
		column: ''Key'' text: [:aValue | aValue key];
		column: ''Value'' text: #value'.
						'Tree view'
							-> 'Tree
gtTreeFor: aView
	<gtView>
	^ aView tree
		title: ''Tree'';
		priority: 1;
		items: [ { self. self sibling } ];
		children: #children;
		itemText: #name;
		expandAll'.
						'Columned tree view'
							-> 'Tree
gtColumnedTreeFor: aView
	<gtView>
	^ aView columnedTree
		title: ''Columned tree'';
		priority: 1;
		items: [ { self. self sibling } ];
		column: ''Key'' text: [:aValue | aValue key];
		column: ''Value'' text: #value width: 100'.
						'Explicit view'
							-> 'Element
gtElementViewFor: aView
	<gtView>
	^ aView explicit
		title: ''Element'';
		priority: 1;
		stencil: [BlElement new size: 100@100; color: Color blue]'.
						'Columned tree view'
							-> 'Painting
gtPaintingFor: aView
	<gtView>
	^ aView mondrian
		title: ''Painting'';
		priority: 2;
		painting: [ :aMondrian | self paintWith: aMondrian ]'}
						collect: [ :aPair | 
							aPair key
								, ':
```smalltalk-method
' , aPair value
								, '
```' ]))
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
		text: [ self prompt ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtOpenAINewThreadMessageViewModel new
						threadMessage: GtOpenAINewThreadMessage new))
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
	^ '# Interaction description
A typical interaction goes like this:
1. The user gives you a natural language PROMPT.
2. You:
    a. Determine what needs to be done
    b. Write either a short Pharo SCRIPT or to do it or a METHOD to add to the system.
    c. The SCRIPT should always return the most relevant object.
3. The environment:
	a. checks your SCRIPT or METHOD using multiple tools, including a parser, compiler, and other checkers.
	b. provides the output of those checks back to you.
	
The output of the checks is formatted as follows:
- When the SCRIPT or METHOD are checked successfully, the output looks like this:
```
Output of the last script: 
SUMMARY OF THE OBJECT...
```
- When the checks encounter errors, the output looks like this:
```
The last script had a problem: 
SUMMARY OF THE PROBLEM...
```'
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
	^ 'You are a coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit.'
]

{ #category : #accessing }
GtOpenAIGtTutor >> variablesDescription [
	^ '# Versions
The Pharo version is {pharoVersion}.
The Glamorous Toolkit version is {gtVersion}'
		format: {#pharoVersion -> Smalltalk version.
				#gtVersion -> GtImage version versionString} asDictionary
]

{ #category : #accessing }
GtOpenAIGtTutor >> viewsDescription [
	^ '# The Phlow API
	
GT views use an API called Phlow, which uses a builder pattern to create views in the inspector for an object.

The following view types are vailable:
- `list`:  A simple list view.
- `columnedList`: A list view with columns.
- `tree`: A simple tree view with a root and children.
- `columnedTree`: A tree with with columns.
- `explicit`: A view that renders a Bloc element explicitly.
- `mondrian`: A view that uses Mondrian visualizations.

For examples of these views, look below.'
]
