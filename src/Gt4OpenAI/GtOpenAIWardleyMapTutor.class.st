Class {
	#name : #GtOpenAIWardleyMapTutor,
	#superclass : #GtOpenAITutorWithSteps,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultCommunicationRules [
	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: (GtLlmInstructionList new
				addItem: 'Always review the full conversation prior to answering and maintain continuity.';
				addItem: 'If asked a question, respond in a friendly, conversational way.';
				addItem: 'Assume the user would like something concise.')
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultConventionsDescription [
	^ GtLlmInstructionSection new
		title: 'Conventions for communication';
		body: 'Please follow the conventions outlined in each step.'
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultExampleViews [
	^ ''
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultInteractionDescription [
	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: 'A typical interaction goes like this:
1. The user gives you a natural language PROMPT.
2. You:
    a. Determine what needs to be done
    b. Write one or more instructions in the format specified below.
3. The environment:
	a. checks and executes the instructions.
	b. provides the output of those checks back to you.
	
The output of the checks is formatted as follows:
- When the instructions are executed successfully, the output looks like this:
```
Output of the instructions: 
SUMMARY OF THE MAP...
```
- When the instructions encounter errors, the output looks like this:
```
The instructions had a problem: 
SUMMARY OF THE PROBLEM...
```
- The message that moves the conversation onto the next step (sendable by either party) is formatted as such:
```
Let''s move on to the next step!
```
- The message that moves the conversation back to the previous step (sendable by either party) is formatted as such:
```
Let''s go back to the previous step.
```
- The message that moves the conversation to any named step (sendable by either party) is formatted as such:
```
Let''s go to step `NAME_OF_STEP`.
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultTutorDescription [
	^ 'You are an assistant called Wardley Map Tutor that generates Wardley Maps by prompt in multiple steps.'
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> defaultViewsDescription [
	^ ''
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> initialize [
	super initialize.

	pipelineBuilder := [ GtLlmContext new
			instance: GtLlmWardleyMapCreator new;
			isImmutableInstance: true ].
			
	self initializeSteps
]

{ #category : #accessing }
GtOpenAIWardleyMapTutor >> initializeSteps [
	self
		addStep: (GtLlmTutorStep new
				name: 'Ask for a topic';
				description: 'Firstly, ask for the topic of the Wardley map to be generated.';
				rules: {'Ask "What should the topic of the Wardley map be?"'.
						'After the user specifies the Wardley map topic, move on to the next step.'});
		addStep: (GtLlmTutorStep new
				name: 'Create a set of nodes';
				description: 'Create a set of nodes by writing a snippet that returns them.';
				rules: {'A node has a name and is always formatted in Markdown format like in this example:
```
{"name": "business decision"}
```'.
						'A snippet may contain multiple nodes, like in this example:
```
{"name" : "business decision"}
{"name" : "developer"}
```'};
				pipeline: GtLlmWardleyMapNodeStep new);
		addStep: (GtLlmTutorStep new
				name: 'Position the nodes';
				description: 'Position the nodes by writing a snippet.';
				rules: {'A position has a node name, a X coordinate (in the range 0 to 1), and a Y coordinate (in the range 0 to 1), and is always formatted in Markdown format like in this example:
```
{"node": "business decision", "x": 0.3, "y": 0.5}
```'.
						'A snippet may contain multiple nodes, like in this example:
```
{"node": "business decision", "x": 0.3, "y": 0.5}
{"node": "developer", "x": 0.6, "y": 0.2}
```'};
				pipeline: GtLlmWardleyMapPositionStep new);
		addStep: (GtLlmTutorStep new
				name: 'Connect the nodes';
				description: 'Connect the nodes by writing a snippet.';
				rules: {'A connection has a from node name and a to node name, and is always formatted in Markdown format like in this example:
```
{"from": "business decision", "to": "developer}
```'.
						'A snippet may contain multiple nodes, as specified in the other steps above.'};
				pipeline: GtLlmWardleyMapConnectionStep new)
]
