Class {
	#name : #GtLlmGtTutor,
	#superclass : #Object,
	#instVars : [
		'client',
		'model',
		'instructions',
		'chats',
		'context'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmGtTutor >> addChat [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmGtTutor >> chat [
	^ chats ifNotEmpty: #last ifEmpty: [ self addChat ]
]

{ #category : #accessing }
GtLlmGtTutor >> chats [
	^ chats
]

{ #category : #accessing }
GtLlmGtTutor >> check: aString [
	<return: #GtLlmStepResult>
	^ context check: aString
]

{ #category : #accessing }
GtLlmGtTutor >> communicationRules [
	^ '# Communication rules
- Decline any tasks that seem dangerous, irreversible, or that you do not understand.
- Always review the full conversation prior to answering and maintain continuity.
- If asked to do something, print a concise summary of what you have done as confirmation.
- If asked a question, respond in a friendly, conversational way. Use programmatically-generated and natural language responses as appropriate.
- Assume the user would like something concise.'
]

{ #category : #accessing }
GtLlmGtTutor >> conventionsDescription [
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
GtLlmGtTutor >> defaultInstructions [
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
GtLlmGtTutor >> defaultModel [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmGtTutor >> exampleViews [
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
GtLlmGtTutor >> gtChatsFor: aView [
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
GtLlmGtTutor >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ instructions ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new
						threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtLlmGtTutor >> initialize [
	super initialize.
	
	instructions := self defaultInstructions.
	model := self defaultModel.
	chats := GtLlmChatsGroup new.
	context :=  GtLlmContext defaultPipeline
]

{ #category : #accessing }
GtLlmGtTutor >> interactionDescription [
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
GtLlmGtTutor >> model [
	^ model
]

{ #category : #accessing }
GtLlmGtTutor >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmGtTutor >> tutorDescription [
	^ 'You are a coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit.'
]

{ #category : #accessing }
GtLlmGtTutor >> variablesDescription [
	^ '# Versions
The Pharo version is {pharoVersion}.
The Glamorous Toolkit version is {gtVersion}'
		format: {#pharoVersion -> Smalltalk version.
				#gtVersion -> GtImage version versionString} asDictionary
]

{ #category : #accessing }
GtLlmGtTutor >> viewsDescription [
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
