Class {
	#name : #GtOpenAIResponseProvider,
	#superclass : #GtOpenAIProvider,
	#instVars : [
		'tools',
		'instructions',
		'executions'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider class >> providerName [
	^ 'OpenAI Responses'
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> addTool: aTool [
	(tools anySatisfy: [ :tool | tool name = aTool name ])
		ifTrue: [ self error: 'Cannot add a tool of the same name multiple times.' ].

	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultTools [
	^ GtLlmToolsGroup new
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> executions [
	^ executions
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 5;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> handleToolCall: aToolCall [
	| toolOutput |
	chat removeLastMessage.
	chat
		addMessage: (GtOpenAIRawToolMessage new
				toolCall: aToolCall;
				rawData: aToolCall rawData).
	toolOutput := tools performToolCall: aToolCall.
	chat
		addMessage: (GtLlmToolMessage new
				toolCall: aToolCall;
				output: toolOutput).

	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> initialize [
	super initialize.

	tools := self defaultTools.
	
	executions := OrderedCollection new.
]

{ #category : #accessing }
GtOpenAIResponseProvider >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIResponseProvider >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIResponseProvider >> performToolCallsIn: result [
	| toolOutputs |
	toolOutputs := result toolCalls
			collect: [ :aToolCall | 
				| toolOutput |
				chat
					addMessage: (GtOpenAIRawToolMessage new
							toolCall: aToolCall;
							rawData: aToolCall rawData;
							reasoning: (result output
									detect: [ :anOutput | (anOutput rawData at: 'type') = 'reasoning' ]
									ifNone: [ nil ])).
				toolOutput := tools performToolCall: aToolCall.
				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput) ].

	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> sendFiles: aListOfFileReferences withMessage: aString [
	self
		sendAssistantMessage: (self userMessageClass new
				content: {{'type' -> 'input_text'.
							'text' -> aString} asDictionary}
						, (aListOfFileReferences
								collect: [ :aFileReference | 
									{'type' -> 'input_image'.
										'image_url'
											-> ('data:image/jpeg;base64,' , aFileReference binaryContents base64Encoded)}
										asDictionary ]);
				role: 'user';
				chat: self)
]

{ #category : #accessing }
GtOpenAIResponseProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIResponseProvider >> tools: anObject [
	tools := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> triggerAssistant [
	self chat signalRunHasStarted.
	assistantWorking := true.

	self executeWait
]
