Class {
	#name : #GtLlmAssistantInstruction,
	#superclass : #Object,
	#instVars : [
		'name',
		'actions',
		'description',
		'formats',
		'sections'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmAssistantInstruction class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> actionNamed: aString [
	^ actions detect: [ :anAction | anAction name = aString ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> actions [
	^ actions
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> addAction: anAction [
	actions add: anAction
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> addActions: aListOfActions [
	actions addAll: aListOfActions
]

{ #category : #accessing }
GtLlmAssistantInstruction >> addComponent: aComponent [
	formats add: aComponent
]

{ #category : #accessing }
GtLlmAssistantInstruction >> addComponents: aListOfComponents [
	formats addAll: aListOfComponents
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> addSection: aSection [
	sections add: aSection
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> addSections: aSection [
	sections addAll: aSection
]

{ #category : #accessing }
GtLlmAssistantInstruction >> asInstructionPiece [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self description;
		sections:
				self sections
						,
							{(GtLlmInstructionSection new
								source: self;
								title: 'Format components';
								body:
										(GtLlmInstructionWithSections new
												source: self;
												introduction:
														'Each format component has a name, a data format (such as JSON, YAML, etc.), a Markdown code block annotation tag that encloses it, and some examples.
							
The components that make up the state are as follows:';
												sections: formats)).
							(GtLlmInstructionSection new
								source: self;
								title: 'Actions';
								body:
										(GtLlmInstructionWithSections new
												introduction: 'All actions are listed below.';
												sections:
														(actions collect: [ :anAction | anAction asInstructionPiece ]))).
							(self errorHandlingDescription)}
]

{ #category : #accessing }
GtLlmAssistantInstruction >> asJsonSchema [
	^ {'type' -> 'object'.
		'properties'
			-> (formats
					collect: [ :aComponent | aComponent name -> aComponent asJsonSchema ])
					asDictionary.
		'required' -> (formats collect: [:aFormat | aFormat name ]).
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
GtLlmAssistantInstruction >> communicationConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'Any action mut be answered by an action result, no extraneous prose or explanations. Only non-action messages may be answered in prose.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
GtLlmAssistantInstruction >> componentNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> defaultSections [
	^ {self interactionDescription.
		self communicationConventionsDescription.
		self toolUseDescription} asOrderedCollection
]

{ #category : #accessing }
GtLlmAssistantInstruction >> description [
	^ description
]

{ #category : #accessing }
GtLlmAssistantInstruction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmAssistantInstruction >> errorHandlingDescription [
	^ GtLlmInstructionSection new
		title: 'Error handling description';
		body: 'If an error occurs during an action, a message will be sent that starts with `An error occured:` and the error message below that. You then correct the mistake by sending an action result that corrects the mistake.'
]

{ #category : #accessing }
GtLlmAssistantInstruction >> formatNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #accessing }
GtLlmAssistantInstruction >> formats [
	^ formats
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [  actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
GtLlmAssistantInstruction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmAssistantInstruction >> initialize [
	formats := OrderedCollection new.
	actions := GtLlmActionsGroup new.
	description := ''.
	sections := self defaultSections
]

{ #category : #accessing }
GtLlmAssistantInstruction >> interactionDescription [
	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: 'A typical interaction goes like this:
1. You are given the current state and an action to perform.
2. You:
    a. Determine what needs to be done
    b. Perform the action on the state.
    c. Output the new state.
3. The environment:
	a. checks your output state using multiple tools and user feedback.
	b. provides the current state and next action to you (returning back to step 1.).
	
The state is an aggregate of the components listed below.'
]

{ #category : #accessing }
GtLlmAssistantInstruction >> name [
	^ name
]

{ #category : #accessing }
GtLlmAssistantInstruction >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantInstruction >> replaceActions: aListOfActions [
	actions removeAll addAll: aListOfActions
]

{ #category : #accessing }
GtLlmAssistantInstruction >> replaceComponents: aListOfComponents [
	formats removeAll addAll: aListOfComponents
]

{ #category : #accessing }
GtLlmAssistantInstruction >> sections [
	^ sections
]

{ #category : #accessing }
GtLlmAssistantInstruction >> sections: anObject [
	sections := anObject
]

{ #category : #accessing }
GtLlmAssistantInstruction >> toolUseDescription [
	^ GtLlmInstructionSection new
		title: 'Tool use description';
		body: 'You have access to various tools. Tool use is governed by the following rules:

- Only use tools if you cannot answer the user''s question or request without it.
- Prefer checking with tools over assumptions. Verify your statements using tools unless you are absolutely certain.'
]
