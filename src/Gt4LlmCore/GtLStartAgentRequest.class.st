"
Magritte request object for starting an agent from the current chat.
"
Class {
	#name : #GtLStartAgentRequest,
	#superclass : #Object,
	#instVars : [
		'agentName',
		'prompt',
		'shouldForkCurrentChat',
		'toolNames',
		'modelName',
		'taskDescription',
		'instructionPageReferences'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLStartAgentRequest >> agentName [
	^ agentName
]

{ #category : #accessing }
GtLStartAgentRequest >> agentName: aString [
	agentName := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> agentNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Agent name';
		accessor: #agentName;
		comment:'The name of the agent to use for this task';
		beRequired
]

{ #category : #views }
GtLStartAgentRequest >> gtViewPromptFor: aView [
	<gtView>
	
	prompt ifNil: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'Prompt';
		priority: 10;
		text: [ prompt ]
]

{ #category : #accessing }
GtLStartAgentRequest >> instructionPageReferences [
	^ instructionPageReferences
]

{ #category : #accessing }
GtLStartAgentRequest >> instructionPageReferences: anObject [
	instructionPageReferences := anObject
]

{ #category : #magritte }
GtLStartAgentRequest >> instructionPageReferencesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #instructionPageReferences;
		classes: { GtLLepiterPageReference};
		comment: 'The names of the Lepiter pages that contain instructions for the agent';
		beOptional
]

{ #category : #accessing }
GtLStartAgentRequest >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLStartAgentRequest >> modelName: aString [
	modelName := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> modelNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Model name';
		accessor: #modelName;
		comment:'The model to use in this chat. If empty the model of the parent chat is used';
		beOptional
]

{ #category : #printing }
GtLStartAgentRequest >> printOn: aStream [
	aStream 
		nextPutAll: 'Start agent: ';
		nextPutAll: (self agentName ifNil: [ '<missing name>' ]);
		nextPutAll: '; ';
		nextPutAll: (self taskDescription ifNil: [ '<missing description>' ])
]

{ #category : #accessing }
GtLStartAgentRequest >> prompt [
	^ prompt
]

{ #category : #accessing }
GtLStartAgentRequest >> prompt: aString [
	prompt := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> promptDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Prompt';
		accessor: #prompt;
		comment:'The task for the agent to perform';
		beRequired
]

{ #category : #accessing }
GtLStartAgentRequest >> shouldForkCurrentAgent [
	^ shouldForkCurrentChat
]

{ #category : #accessing }
GtLStartAgentRequest >> shouldForkCurrentAgent: aBoolean [
	shouldForkCurrentChat := aBoolean
]

{ #category : #magritte }
GtLStartAgentRequest >> shouldForkCurrentAgentDescription [
	<magritteDescription>
	
	^ MABooleanDescription new
		label: 'Inherit current history';
		accessor: #shouldForkCurrentAgent;
		comment:'Indicates if the new agent should either fork the current agent and inherit all its history, or start a new independent agent. Should only be set to true in case there is a good reason to do so for the given task.';
		beOptional
]

{ #category : #accessing }
GtLStartAgentRequest >> taskDescription [
	^ taskDescription
]

{ #category : #accessing }
GtLStartAgentRequest >> taskDescription: aString [
	taskDescription := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> taskDescriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Task Description';
		accessor: #taskDescription;
		comment:'A short description of the task';
		beRequired
]

{ #category : #accessing }
GtLStartAgentRequest >> toolNames [
	^ toolNames
]

{ #category : #accessing }
GtLStartAgentRequest >> toolNames: aCollectionOfToolNames [
	toolNames := aCollectionOfToolNames
]

{ #category : #magritte }
GtLStartAgentRequest >> toolNamesDescription [
	<magritteDescription>
	
	^ MAToManyScalarRelationDescription new
		label: 'Tool names';
		accessor: #toolNames;
		classes: { String };
		comment: 'Indicates the list of tools to be used by this agent. If not used the default list of tools is used.';
		beOptional
]
