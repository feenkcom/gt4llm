Class {
	#name : #GtLToolMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'toolCall',
		'output'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLToolMessage class >> defaultRole [
	^ 'tool'
]

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

{ #category : #'gt - extensions' }
GtLToolMessage >> gtOutputFor: aView [
	<gtView>
	<gtLlmView>
	^ aView textEditor
		title: 'Output';
		priority: 0;
		text: [ self output ]
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
	output := anObject
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> responseModels [
	"we should collect the tools from the toolCall"
	^ {}
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> serializeResponse [
	^ {'type' -> 'function_call_output'.
		'call_id' -> toolCall id.
		'output' -> self output} asDictionary
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
