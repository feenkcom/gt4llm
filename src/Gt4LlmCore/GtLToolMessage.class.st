Class {
	#name : #GtLToolMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'toolCall',
		'output'
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

{ #category : #'as yet unclassified' }
GtLToolMessage >> content [
	^ self output
]

{ #category : #'api - accessing' }
GtLToolMessage >> contentText [
	^ self toolCall gtDisplayString
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Arguments';
		priority: 5;
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
	self toolCall ifNotNil: [ :call | call gtDisplayOn: aStream ] ifNil: [ aStream nextPutAll: 'No tool' ]
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtInspectorTargetModels [
	^ self output ifNotNil: [ :anOutput | {anOutput} ] ifNil: [ #() ]
]

{ #category : #testing }
GtLToolMessage >> isToolMessage [

	^ true
]

{ #category : #accessing }
GtLToolMessage >> output [
	^ output
]

{ #category : #accessing }
GtLToolMessage >> output: anObject [
	self assert: [ anObject isKindOf: GtLDomainObject ].
	output := anObject
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
GtLToolMessage >> serializeForOpenAIResponsesAPI [
	"Output should be defined using tools.
	Available output values:
		- array of objects
		- string"
	| anOutput |
	self flag: #todo.
	
	anOutput := self output ifNotNil: #serializeToOpenAIResponseJsonString.
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
