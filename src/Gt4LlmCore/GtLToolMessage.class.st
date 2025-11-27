Class {
	#name : #GtLToolMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'toolCall',
		'output'
	],
	#category : #Gt4LlmCore
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

	^ aVisitor visitGtLlmToolMessage: self
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

{ #category : #'as yet unclassified' }
GtLToolMessage >> contentText [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView forward
		title: 'Arguments';
		priority: 5;
		object: [ self toolCall ];
		view: #gtArgumentsFor:
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtLToolMessage >> gtOutputFor: aView [
	<gtView>
	<gtLlmMessageView>
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
GtLToolMessage >> serializeResponse [
	^ {'type' -> 'function_call_output'.
		'call_id' -> toolCall id.
		'output' -> self output} asDictionary
]

{ #category : #accessing }
GtLToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLToolMessage >> toolCall: anObject [
	toolCall := anObject
]
