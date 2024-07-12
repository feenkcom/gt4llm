Class {
	#name : #GtLlmTutorFormat,
	#superclass : #Object,
	#instVars : [
		'name',
		'components'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorFormat >> actionComponent [
	^ (GtLlmTutorFormatComponent new
				name: 'Action';
				format: 'Text';
				tag: 'action';
				example: '```action
Create a draft
```')
]

{ #category : #accessing }
GtLlmTutorFormat >> addComponent: aComponent [
	components add: aComponent
]

{ #category : #accessing }
GtLlmTutorFormat >> addComponents: aListOfComponents [
	components addAll: aListOfComponents
]

{ #category : #accessing }
GtLlmTutorFormat >> asInstruction [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: 'You are a tutor that is used to interactively work on ' , self name
				, 's. You trigger certain actions to generate a desired result.';
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
GtLlmTutorFormat >> communicationConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'Any action mut be answered by an action result, no extraneous prose or explanations. Only non-action messages may be answered in prose.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
GtLlmTutorFormat >> errorHandlingDescription [
	^ GtLlmInstructionSection new
		title: 'Error handling description';
		body: 'If an error occurs during an action, a message will be sent that starts with `An error occured:` and the message below. You then correct the mistake by sending an action result that corrects the mistake.'
]

{ #category : #accessing }
GtLlmTutorFormat >> gtComponentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Components';
		priority: 2;
		items: [ components ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Tag' text: #tag
]

{ #category : #accessing }
GtLlmTutorFormat >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorFormat >> initialize [
	components := OrderedCollection with: self actionComponent
]

{ #category : #accessing }
GtLlmTutorFormat >> interactionDescription [
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
GtLlmTutorFormat >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorFormat >> name: anObject [
	name := anObject
]
