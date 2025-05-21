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
		sections: self sections
				, {GtLlmInstructionSection new
							source: self;
							title: 'Format components';
							body: (GtLlmInstructionWithSections new
									source: self;
									introduction: 'Each format component has a name, a data format (such as JSON, YAML, etc.), a Markdown code block annotation tag that encloses it, and some examples.
							
The components that make up the state are as follows:';
									sections: formats).
						GtLlmInstructionSection new
							source: self;
							title: 'Actions';
							body: (GtLlmInstructionWithSections new
									introduction: 'All actions are listed below.';
									sections: (actions collect: [ :anAction | anAction asInstructionPiece ]))}
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
	| instructions |
	instructions := GtLlmInstructionList new
			addItem: 'Always review the full conversation prior to answering and maintain continuity.';
			addItem: 'Assume the user would like something concise when producing text.';
			addItem: 'Prefer asking clarifying follow-up questions or using tools (see  the section "Tool use policy") over assumptions, especially when in doubt.';
			addItem: 'Refuse actions that cannot be performed using your capabilities. When an action is refused, return a textual explanation of why it isn’t possible to fulfill the request.';
			addItem: 'Similarly, give a concise description of any error you encounter on tool use or other system errors.'.

	GtLlmFeatures multiStep
		ifTrue: [ instructions
				addItem: 'Multi-step actions (i.e. those involving tools) should be answered by a summary of the intended steps to take. If the user confirms this course of action, take it.' ].

	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: instructions
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
	| body |
	body := GtLlmFeatures multiStep
			ifTrue: [ 'Interactions are structured like this:
1. The assistant (you) is given the current state and an action to perform.
2. The assistant;
    a. Determines what needs to be done. It consults tools as necessary and asks follow-up questions if the action is unclear. Multi-step actions require a summary of necessary steps beforehand and a user confirmation (see "Communication rules").
    b. Performs the action on the state.
    c. Outputs the new state.
3. The user:
	a. checks the output state.
	b. provides the current state and next action to you (returning back to step 1.).
	
The state is an aggregate of the components listed below, sent to you as a JSON object.' ]
			ifFalse: [ 'Interactions are structured like this:
1. The assistant (you) is given the current state and an action to perform.
2. The assistant;
    a. Determines what needs to be done. It consults tools as necessary and asks follow-up questions if the action is unclear.
    b. Performs the action on the state.
    c. Outputs the new state.
3. The user:
	a. checks the output state.
	b. provides the current state and next action to you (returning back to step 1.).
	
The state is an aggregate of the components listed below, sent to you as a JSON object.' ].

	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: body
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
		title: 'Tool use policy';
		body: 'You have access to various tools. Tool use is governed by the following rules:

- Only use tools if you cannot answer the user''s question or request with certainty otherwise, except when writing code.
- When writing code, ALWAYS use tools extensively to check the environment before suggesting anything or writing code. You MUST use tools before writing any code. Failure to do so is a violation of protocol.
- Prefer checking with tools over assumptions. Verify your statements using tools unless you are absolutely certain.'
]
