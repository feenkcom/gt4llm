Class {
	#name : #LlmTutorInstruction,
	#superclass : #Object,
	#instVars : [
		'name',
		'actions',
		'description',
		'formats'
	],
	#category : #'Gt4Llm-Tutor-Tutor'
}

{ #category : #accessing }
LlmTutorInstruction >> actionComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatDescription new beRequired
		name: 'Action';
		format: 'Text';
		example: '```
Create a draft
```'
]

{ #category : #'as yet unclassified' }
LlmTutorInstruction >> actionNamed: aString [
	^ actions detect: [ :anAction | anAction name = aString ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
LlmTutorInstruction >> actions [
	^ actions
]

{ #category : #'as yet unclassified' }
LlmTutorInstruction >> addAction: anAction [
	actions add: anAction
]

{ #category : #'as yet unclassified' }
LlmTutorInstruction >> addActions: aListOfActions [
	actions addAll: aListOfActions
]

{ #category : #accessing }
LlmTutorInstruction >> addComponent: aComponent [
	formats add: aComponent
]

{ #category : #accessing }
LlmTutorInstruction >> addComponents: aListOfComponents [
	formats addAll: aListOfComponents
]

{ #category : #accessing }
LlmTutorInstruction >> asInstructionPiece [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self description;
		sections: {self interactionDescription.
				self communicationConventionsDescription.
				GtLlmInstructionSection new
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
							sections: (actions collect: #asInstructionPiece)).
				self errorHandlingDescription}
]

{ #category : #accessing }
LlmTutorInstruction >> asJsonSchema [
	^ {'type' -> 'object'.
		'properties'
			-> (formats
					collect: [ :aComponent | aComponent name -> aComponent asJsonSchema ])
					asDictionary.
		'required' -> (formats collect: #name).
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
LlmTutorInstruction >> communicationConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'Any action mut be answered by an action result, no extraneous prose or explanations. Only non-action messages may be answered in prose.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
LlmTutorInstruction >> componentNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #accessing }
LlmTutorInstruction >> description [
	^ description
]

{ #category : #accessing }
LlmTutorInstruction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
LlmTutorInstruction >> errorHandlingDescription [
	^ GtLlmInstructionSection new
		title: 'Error handling description';
		body: 'If an error occurs during an action, a message will be sent that starts with `An error occured:` and the message below. You then correct the mistake by sending an action result that corrects the mistake.'
]

{ #category : #accessing }
LlmTutorInstruction >> formatNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #accessing }
LlmTutorInstruction >> formats [
	^ formats
]

{ #category : #'as yet unclassified' }
LlmTutorInstruction >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [  actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
LlmTutorInstruction >> gtFormatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Formats';
		priority: 2;
		items: [ formats sorted: [ :a :b | a priority < b priority ] ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority' text: #priority width: 70;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						formats remove: anItem.
						aButton phlow fireUpdateWish ] ]
		width: 70
]

{ #category : #accessing }
LlmTutorInstruction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
LlmTutorInstruction >> initialize [
	formats := OrderedCollection with: self actionComponent.
	actions := GtLlmActionsGroup new.
	description := ''
]

{ #category : #accessing }
LlmTutorInstruction >> interactionDescription [
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
LlmTutorInstruction >> name [
	^ name
]

{ #category : #accessing }
LlmTutorInstruction >> name: anObject [
	name := anObject
]
