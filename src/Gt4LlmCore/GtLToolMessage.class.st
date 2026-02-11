Class {
	#name : #GtLToolMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'toolCall',
		'output',
		'executionState',
		'requestResponse'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLToolMessage class >> leJsonV4Name [
	^ #gtLToolMessage
]

{ #category : #visiting }
GtLToolMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLToolMessage: self
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> action [
	^ self toolCall humanReadable
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> actionModel [
	^ self toolCall
]

{ #category : #'api - execution' }
GtLToolMessage >> beFinishedExecutionState [
	self executionState: GtLMessageState finished
]

{ #category : #'api - execution' }
GtLToolMessage >> beRunningExecutionState [
	self executionState: GtLMessageState running
]

{ #category : #'api - execution' }
GtLToolMessage >> beSkippedExecutionState [
	self executionState: GtLMessageState skipped
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> chat: aChat [
	super chat: aChat.
	chat  
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat]
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> content [
	^ self output
]

{ #category : #'api - accessing' }
GtLToolMessage >> contentText [
	^ self toolCall gtDisplayString
]

{ #category : #'api - execution' }
GtLToolMessage >> executionState [
	<return: #GtLMessageState>
	^ executionState
]

{ #category : #'api - execution' }
GtLToolMessage >> executionState: aState [
	executionState = aState ifTrue: [ ^ self ].
	
	executionState := aState.
	self notifyExecutionStateChanged.
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Arguments';
		priority: 15;
		object: [ self toolCall ];
		view: #gtArgumentsFor:
]

{ #category : #'gt - extensions' }
GtLToolMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	^ aView empty
]

{ #category : #printing }
GtLToolMessage >> gtDisplayOn: aStream [
	self toolCall
		ifNotNil: [ :call | call gtDisplayOn: aStream ]
		ifNil: [ aStream nextPutAll: 'No tool' ]
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtInspectorTargetModels [
	^ self output ifNotNil: [ :anOutput | {anOutput} ] ifNil: [ #() ]
]

{ #category : #views }
GtLToolMessage >> gtToolCallFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Tool call';
		tooltip: 'Spawn the tool call';
		action: [ :button | button phlow spawnObject: self toolCall ]
]

{ #category : #initialization }
GtLToolMessage >> initialize [
	super initialize.
	executionState := GtLMessageState created
]

{ #category : #testing }
GtLToolMessage >> isToolMessage [

	^ true
]

{ #category : #'api - execution' }
GtLToolMessage >> messageExecutionStateLabel [
	^ self executionState messageExecutionStateLabel
]

{ #category : #'private - notifying' }
GtLToolMessage >> notifyExecutionStateChanged [
	self announce: (GtLMessageExecutionStateChanged new
		message: self;
		executionState: executionState)
]

{ #category : #accessing }
GtLToolMessage >> output [
	<return: #TGtLDomainObject>
	^ output
]

{ #category : #accessing }
GtLToolMessage >> output: anObject [
	self assert: [ anObject isKindOf: GtLDomainObject ].
	output := anObject
]

{ #category : #accessing }
GtLToolMessage >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLToolMessage >> requestResponse: aRequestResponse [
	self assert: [ aRequestResponse isNotNil ].
	
	requestResponse
		ifNotNil: [ requestResponse := requestResponse withFollowingRequestResponse: aRequestResponse ]
		ifNil: [ requestResponse := aRequestResponse ]
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> responseModels [
	"we should collect the tools from the toolCall"
	^ {}
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> role [
	^ 'tool'
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> serializeForAnthropicMessagesAPI [
	"[
  {
    ""type"": ""tool_result"",
    ""tool_use_id"": ""toolu_01D7FLrfh4GYq7yT1ULFeyMV"",
    ""content"": ""259.75 USD""
  }
]
	Documentation: https://platform.claude.com/docs/en/api/messages/create"

	| anOutput | 
	
	anOutput := self output ifNotNil: [ :each | each serializeToAnthropicResponseOutput ].

	^ {
		'content' ->{{
				'type' -> 'tool_result'.
				'tool_use_id' -> toolCall id.
				'content' -> anOutput} asDictionary}.
		'role' -> 'user' }asDictionary 
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> serializeForOpenAIResponsesAPI [
	"Output should be defined using tools.
	Available output values:
		- array of objects of type:
			- 'input_text' (with 'text' containing value), 
			- 'input_image', 
			- 'output_text', 
			- 'refusal', 
			- 'input_file', 
			- 'computer_screenshot', and 
			- 'summary_text'
		- string
	Documentation: https://platform.openai.com/docs/guides/function-calling#formatting-results"

	| anOutput | 
	self flag: #todo.
	anOutput := self output ifNotNil: [ :each | each serializeToOpenAIResponseOutput ].

	^ {'type' -> 'function_call_output'.
		'call_id' -> toolCall id.
		'output' -> anOutput} asDictionary
]

{ #category : #'api - accessing' }
GtLToolMessage >> toolArguments [
	"Return tool arguments in a form of associations: argumentName -> argumentValue"

	<return: #Collection of: #Association>
	^ self toolCall arguments associations
]

{ #category : #accessing }
GtLToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLToolMessage >> toolCall: anObject [
	toolCall := anObject
]

{ #category : #'api - accessing' }
GtLToolMessage >> toolDescription [
	"Return tool description"

	<return: #String>
	^ self toolCall description
]

{ #category : #'api - accessing' }
GtLToolMessage >> toolName [
	^ self toolCall name
]

{ #category : #'api - converting' }
GtLToolMessage >> viewModelClass [
	^ GtLToolMessageViewModel
]
