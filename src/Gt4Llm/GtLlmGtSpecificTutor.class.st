Class {
	#name : #GtLlmGtSpecificTutor,
	#superclass : #GtLlmTutor,
	#instVars : [
		'instructions',
		'tutorDescription',
		'interactionDescription',
		'communicationRules',
		'conventionsDescription',
		'viewsDescription',
		'exampleViews',
		'variablesDescription'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmGtSpecificTutor >> communicationRules [
	^ communicationRules
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> communicationRules: anObject [
	communicationRules := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> conventionsDescription [
	^ conventionsDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> conventionsDescription: anObject [
	conventionsDescription := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultCommunicationRules [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Decline any tasks that seem dangerous, irreversible, or that you do not understand.';
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'If asked to do something, print a concise summary of what you have done as confirmation.';
				addItem: 'If asked a question, respond in a friendly, conversational way. Use programmatically-generated and natural language responses as appropriate.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Conventions for communication';
		body: (GtLlmCompositeInstruction new
				addItem: 'Please follow these conventions carefully:';
				addItem: (GtLlmInstructionList new
						addItem: 'The code you propose can either be a SCRIPT or a METHOD.';
						addItem: 'A SCRIPT is always formatted in Markdown smalltalk format like in this example:
```smalltalk
aVariable := 5.
1 + aVariable
```';
						addItem: 'Smalltalk methods must always be formatted in Markdown smalltalk-method format and such that the class name is on the first line, and the method body follows, like in this example:
```smalltalk-method
LargeInteger
divideBy: anotherNumber
	^ self / anotherNumber
```';
						addItem: 'When writing about classes, always use the notation {{gtClass:CLASSNAME}}, where CLASSNAME is the name of the class. Example: {{gtClass:Object}} for the Object class.';
						addItem: 'When writing about methods, always use the notation {{gtMethod:CLASSNAME>>#METHODNAME}}, where CLASSNAME is the name of the class and METHODNAME is the name of the method. Example: {{gtMethod:Object>>#perform:}} for the perform: method on the Object class.';
						addItem: 'The first message in the conversation will be a description of the files you have access to. Reply with "How can I assist you today?" to that message.';
						addItem: 'When instructed to generate Phlow views, strictly adhere to the API as specified below in the description and outlined in the examples. Do not assume any other view methods or types are available.'))
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultExampleViews [
	^ GtLlmInstructionSection new
		title: 'Example for phlow views';
		body: (String lf , String lf
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
						'Mondrian view'
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
GtLlmGtSpecificTutor >> defaultInstructions [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self tutorDescription;
		addSection: self interactionDescription;
		addSection: self communicationRules;
		addSection: self conventionsDescription;
		addSection: self viewsDescription;
		addSection: self exampleViews;
		addSection: self variablesDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultInteractionDescription [
	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: 'A typical interaction goes like this:
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
GtLlmGtSpecificTutor >> defaultTutorDescription [
	^ 'You are a coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit.'
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultVariablesDescription [
	^ GtLlmInstructionSection new
		title: 'Versions';
		body: ('
The Pharo version is {pharoVersion}.
The Glamorous Toolkit version is {gtVersion}'
				format: {#pharoVersion -> Smalltalk version.
						#gtVersion -> GtImage version versionString} asDictionary)
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> defaultViewsDescription [
	^ GtLlmInstructionSection new
		title: 'The Phlow API';
		body: (GtLlmCompositeInstruction new
				addItem: 'GT views use an API called Phlow, which uses a builder pattern to create views in the inspector for an object.';
				addItem: 'The following view types are available:';
				addItem: (GtLlmInstructionList new
						addItem: '`list`:  A simple list view.';
						addItem: '`columnedList`: A list view with columns.';
						addItem: '`tree`: A simple tree view with a root and children.';
						addItem: '`columnedTree`: A tree with with columns.';
						addItem: '`explicit`: A view that renders a Bloc element explicitly.';
						addItem: '`mondrian`: A view that uses Mondrian visualizations.');
				addItem: 'For examples of these views, look below.')
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> exampleViews [
	^ exampleViews
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> exampleViews: anObject [
	exampleViews := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> initialize [
	super initialize.

	tutorDescription := self defaultTutorDescription.
	interactionDescription := self defaultInteractionDescription.
	communicationRules := self defaultCommunicationRules.
	conventionsDescription := self defaultConventionsDescription.
	viewsDescription := self defaultViewsDescription.
	exampleViews := self defaultExampleViews.
	variablesDescription := self defaultVariablesDescription.
	instructions := self defaultInstructions
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> instructions: anObject [
	instructions := anObject asInstruction
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> interactionDescription [
	^ interactionDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> interactionDescription: anObject [
	interactionDescription := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> tutorDescription [
	^ tutorDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> tutorDescription: anObject [
	tutorDescription := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> variablesDescription [
	^ variablesDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> variablesDescription: anObject [
	variablesDescription := anObject
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> viewsDescription [
	^ viewsDescription
]

{ #category : #accessing }
GtLlmGtSpecificTutor >> viewsDescription: anObject [
	viewsDescription := anObject
]
