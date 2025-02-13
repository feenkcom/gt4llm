Class {
	#name : #GtLlmTutorInstruction,
	#superclass : #Object,
	#instVars : [
		'name',
		'actions',
		'description',
		'formats',
		'sections'
	],
	#category : #'Gt4Llm-Tutor-Tutor'
}

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> actionNamed: aString [
	^ actions detect: [ :anAction | anAction name = aString ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> actions [
	^ actions
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> addAction: anAction [
	actions add: anAction
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> addActions: aListOfActions [
	actions addAll: aListOfActions
]

{ #category : #accessing }
GtLlmTutorInstruction >> addComponent: aComponent [
	formats add: aComponent
]

{ #category : #accessing }
GtLlmTutorInstruction >> addComponents: aListOfComponents [
	formats addAll: aListOfComponents
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> addSection: aSection [
	sections add: aSection
]

{ #category : #accessing }
GtLlmTutorInstruction >> asInstructionPiece [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self description;
		sections: self sections, {
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
GtLlmTutorInstruction >> asJsonSchema [
	^ {'type' -> 'object'.
		'properties'
			-> (formats
					collect: [ :aComponent | aComponent name -> aComponent asJsonSchema ])
					asDictionary.
		'required' -> (formats collect: #name).
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
GtLlmTutorInstruction >> communicationConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'Any action mut be answered by an action result, no extraneous prose or explanations. Only non-action messages may be answered in prose.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
GtLlmTutorInstruction >> componentNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> defaultSections [
	^ {self interactionDescription.
		self communicationConventionsDescription} asOrderedCollection
]

{ #category : #accessing }
GtLlmTutorInstruction >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorInstruction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorInstruction >> errorHandlingDescription [
	^ GtLlmInstructionSection new
		title: 'Error handling description';
		body: 'If an error occurs during an action, a message will be sent that starts with `An error occured:` and the message below. You then correct the mistake by sending an action result that corrects the mistake.'
]

{ #category : #accessing }
GtLlmTutorInstruction >> formatNamed: aName [
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
]

{ #category : #accessing }
GtLlmTutorInstruction >> formats [
	^ formats
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [  actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
GtLlmTutorInstruction >> gtFormatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Formats';
		priority: 2;
		items: [ formats sorted: [ :a :b | a priority < b priority ] ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority'
			text: #priority
			width: 70;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						formats remove: anItem.
						anItem removeFromSystem.
						aButton phlow fireToolUpdateWish ] ]
			width: 70
]

{ #category : #accessing }
GtLlmTutorInstruction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorInstruction >> initialize [
	formats := OrderedCollection new.
	actions := GtLlmActionsGroup new.
	description := ''.
	sections := self defaultSections
]

{ #category : #accessing }
GtLlmTutorInstruction >> interactionDescription [
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
GtLlmTutorInstruction >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorInstruction >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorInstruction >> replaceActions: aListOfActions [
	actions removeAll addAll: aListOfActions
]

{ #category : #accessing }
GtLlmTutorInstruction >> replaceComponents: aListOfComponents [
	formats removeAll addAll: aListOfComponents
]

{ #category : #accessing }
GtLlmTutorInstruction >> sections [
	^ sections
]

{ #category : #accessing }
GtLlmTutorInstruction >> sections: anObject [
	sections := anObject
]
