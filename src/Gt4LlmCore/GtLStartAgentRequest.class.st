"
Magritte request object for starting an agent from the current chat.
"
Class {
	#name : #GtLStartAgentRequest,
	#superclass : #Object,
	#instVars : [
		'agentName',
		'description',
		'prompt',
		'model',
		'shouldForkCurrentChat'
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

{ #category : #accessing }
GtLStartAgentRequest >> description [
	^ description
]

{ #category : #accessing }
GtLStartAgentRequest >> description: aString [
	description := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		accessor: #description;
		comment:'A short description of the task';
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
GtLStartAgentRequest >> model [
	^ model
]

{ #category : #accessing }
GtLStartAgentRequest >> model: aString [
	model := aString
]

{ #category : #magritte }
GtLStartAgentRequest >> modelDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Model';
		accessor: #model;
		comment:'The model to use in this chat. If empty the model of the parent chat is used';
		beRequired
]

{ #category : #printing }
GtLStartAgentRequest >> printOn: aStream [
	aStream 
		nextPutAll: 'Start agent: ';
		nextPutAll: (self agentName ifNil: [ 'unnamed' ]);
		nextPutAll: '; ';
		nextPutAll: self description
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
GtLStartAgentRequest >> shouldForkCurrentChat [
	^ shouldForkCurrentChat
]

{ #category : #accessing }
GtLStartAgentRequest >> shouldForkCurrentChat: aBoolean [
	shouldForkCurrentChat := aBoolean
]

{ #category : #magritte }
GtLStartAgentRequest >> shouldForkCurrentChatDescription [
	<magritteDescription>
	
	^ MABooleanDescription new
		label: 'Inherit current history';
		accessor: #shouldForkCurrentChat;
		comment:'Indicates if the new agent should either fork the current chat and inherit all its history, or start a new independent chat. Should only be set to true in case there is a good reason to do so for the given task.';
		beRequired
]
