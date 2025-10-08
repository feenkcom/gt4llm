Class {
	#name : #GtLlmToolMessage,
	#superclass : #GtLlmBasicChatMessage,
	#instVars : [
		'toolCall'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmToolMessage class >> defaultRole [
	^ 'tool'
]

{ #category : #accessing }
GtLlmToolMessage class >> leJsonV4Name [

	^ #gtLlmToolMessage
]

{ #category : #visiting }
GtLlmToolMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmToolMessage: self
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> action [
	^ self toolCall humanReadable
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> actionModel [
	^ self toolCall
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> arguments [
	^ toolCall arguments
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView forward
		title: 'Arguments';
		priority: 5;
		object: [ self toolCall ];
		view: #gtArgumentsFor:
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> gtOutputFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Output';
		priority: 1;
		text: [ self output ]
]

{ #category : #accessing }
GtLlmToolMessage >> output [
	^ toolCall result
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> serializeResponse [
	^ {'type' -> 'function_call_output'.
		'call_id' -> toolCall id.
		'output' -> self output} asDictionary
]

{ #category : #accessing }
GtLlmToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLlmToolMessage >> toolCall: anObject [
	toolCall := anObject
]
