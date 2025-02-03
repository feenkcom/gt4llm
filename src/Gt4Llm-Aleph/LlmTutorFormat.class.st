Class {
	#name : #LlmTutorFormat,
	#superclass : #Object,
	#instVars : [
		'name',
		'components',
		'actions',
		'instructions'
	],
	#category : #'Gt4Llm-Aleph-Tutor'
}

{ #category : #accessing }
LlmTutorFormat >> actionComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new beRequired
		name: 'Action';
		format: 'Text';
		example: '```
Create a draft
```'
]

{ #category : #'as yet unclassified' }
LlmTutorFormat >> addAction: anAction [
	actions add: anAction
]

{ #category : #accessing }
LlmTutorFormat >> addComponent: aComponent [
	components add: aComponent
]

{ #category : #accessing }
LlmTutorFormat >> addComponents: aListOfComponents [
	components addAll: aListOfComponents
]

{ #category : #accessing }
LlmTutorFormat >> asInstruction [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self instructions;
		sections: {self interactionDescription.
				self communicationConventionsDescription.
				GtLlmInstructionSection new
					source: self;
					title: 'Components';
					body: (GtLlmInstructionWithSections new
							source: self;
							introduction: 'Each component has a name, a data format (such as JSON, YAML, etc.), a Markdown code block annotation tag that encloses it, and some examples.
							
The components that make up the state are as follows:';
							sections: components).
				self errorHandlingDescription}
]

{ #category : #accessing }
LlmTutorFormat >> asJsonSchema [
	^ {'type' -> 'object'.
		'properties'
			-> (components
					collect: [ :aComponent | aComponent name -> aComponent asJsonSchema ])
					asDictionary.
		'required' -> (components collect: #name).
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
LlmTutorFormat >> communicationConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'Any action mut be answered by an action result, no extraneous prose or explanations. Only non-action messages may be answered in prose.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
LlmTutorFormat >> componentNamed: aName [
	^ components detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #accessing }
LlmTutorFormat >> components [
	^ components
]

{ #category : #accessing }
LlmTutorFormat >> errorHandlingDescription [
	^ GtLlmInstructionSection new
		title: 'Error handling description';
		body: 'If an error occurs during an action, a message will be sent that starts with `An error occured:` and the message below. You then correct the mistake by sending an action result that corrects the mistake.'
]

{ #category : #'as yet unclassified' }
LlmTutorFormat >> formatComponents [
	^ components
]

{ #category : #'as yet unclassified' }
LlmTutorFormat >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [  actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
LlmTutorFormat >> gtComponentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Components';
		priority: 2;
		items: [ components sorted: [ :a :b | a priority < b priority ] ];
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
						components remove: anItem.
						aButton phlow fireUpdateWish ] ]
		width: 70
]

{ #category : #accessing }
LlmTutorFormat >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
LlmTutorFormat >> initialize [
	components := OrderedCollection with: self actionComponent.
	actions := GtLlmActionsGroup new.
	instructions := ''
]

{ #category : #accessing }
LlmTutorFormat >> instructions [
	^ instructions
]

{ #category : #accessing }
LlmTutorFormat >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
LlmTutorFormat >> interactionDescription [
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
LlmTutorFormat >> name [
	^ name
]

{ #category : #accessing }
LlmTutorFormat >> name: anObject [
	name := anObject
]
