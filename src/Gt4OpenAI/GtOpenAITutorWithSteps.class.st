Class {
	#name : #GtOpenAITutorWithSteps,
	#superclass : #GtOpenAIGtTutor,
	#instVars : [
		'steps',
		'stepMessage',
		'backStepMessage',
		'selectStepMessage'
	],
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #accessing }
GtOpenAITutorWithSteps >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantStepChat new
			assistant: self assistant;
			pipeline: pipelineBuilder value;
			stepMessage: self stepMessage;
			backStepMessage: self backStepMessage;
			selectStepMessage: self selectStepMessage;
			steps: self steps.
	chats add: aChat.

	self files ifNotEmpty: [ aChat sendMessage: self files toFileDescriptions ].

	^ aChat
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> addStep: aStep [
	steps add: aStep
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> backStepMessage [
	^ backStepMessage
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> backStepMessage: anObject [
	backStepMessage := anObject
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultAssistantDescription [
	^ 'Answers requests with multiple steps.'
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultAssistantName [
	^ 'GT Step-wise Tutor - ' , FileLocator home basename
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultInteractionDescription [
	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: 'A typical interaction goes like this:
1. The user gives you a natural language PROMPT.
2. You:
    a. Determine what step you are in
    b. Determine what needs to be done
    c. Write either a short Pharo SCRIPT or to do it or a METHOD to add to the system.
    d. The SCRIPT should always return the most relevant object.
3. The environment:
	e. checks your SCRIPT or METHOD using multiple tools, including a parser, compiler, and other checkers.
	f. provides the output of those checks back to you.
	
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
```
- The message that moves the conversation onto the next step is formatted as such:
```
Move on to the next step.
```'
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultTutorDescription [
	^ 'You are a coding assistant called GT Tutor that generates and auto-executes Pharo Smalltalk code for use inside Glamorous Toolkit. You follow a step-based approach to solving problems.'
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> gtStepsFor: aView [
	<gtView>
	^ aView forward
		title: 'Steps';
		priority: 8;
		object: [ self steps ];
		view: #gtStepsFor:
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> initialize [
	super initialize.
	 
	steps := GtOpenAIStepsGroup new.
	files := GtOpenAIResourceFilesGroup new.
	stepMessage := 'Let''s move on to the next step!'.
	backStepMessage := 'Let''s go back to the previous step!'.
	selectStepMessage := 'Let''s go to step `{1}`.'.
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> instructions [
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self tutorDescription;
		addSection: self interactionDescription;
		addSection: self stepsDescription;
		addSection: self communicationRules;
		addSection: self conventionsDescription;
		addSection: self viewsDescription;
		addSection: self exampleViews;
		addSection: self variablesDescription
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> selectStepMessage [
	^ selectStepMessage
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> selectStepMessage: anObject [
	selectStepMessage := anObject
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> stepMessage [
	^ stepMessage
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> stepMessage: anObject [
	stepMessage := anObject
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> steps [
	^ steps
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> stepsDescription [
	^ GtLlmInstructionSection new
		title: 'Communication steps';
		body: (GtLlmCompositeInstruction new items: (self steps collect: #asInstruction))
]
